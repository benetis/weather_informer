# app/workers/telegram_bot_worker.rb

require 'telegram/bot'

class TelegramBotWorker
  include Sidekiq::Worker

  def perform(*args)
    token = Rails.application.credentials.dig(:telegram_api_key)

    Telegram::Bot::Client.run(token) do |bot|
      Thread.new do
        bot.listen do |message|
          case message
          when Telegram::Bot::Types::Message
            case message.text
            when 'place'
              bot.api.send_message(chat_id: message.chat.id, text: "<Placeholder command>, #{message.chat.id}")
            when 'weather'
              bot.api.send_message(chat_id: message.chat.id, text: "It's sunny today")
            when 'go'
              kb = [[
                      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'When is the next rain?', callback_data: 'touch'),
                    ]]
              markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
              bot.api.send_message(chat_id: message.chat.id, text: 'Make a choice', reply_markup: markup)
            end

          when Telegram::Bot::Types::CallbackQuery
            # Here you can handle your callbacks from inline buttons
            if message.data == 'touch'
              bot.api.send_message(chat_id: message.from.id, text: "<Placeholder>")
            end

          end
        end

        Thread.new do
          loop do
            message_info = RedisConnection.current.lpop('telegram_messages')
            if message_info
              message_info = JSON.parse(message_info, symbolize_names: true)
              logger.info "Sending telegram message: #{message_info}"
              bot.api.send_message(chat_id: message_info[:chat_id], text: message_info[:text])
            else
              sleep 5
            end
          end
        end
      end
    end
  end
end
