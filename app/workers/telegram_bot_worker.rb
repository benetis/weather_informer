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
            when /kaunas/i
              kaunas_selected(bot, message)
            when /orai/i
              weather_today_selected(bot, message)
            when '.'
              dot_selected(bot, message)
            end

          when Telegram::Bot::Types::CallbackQuery
            touch_callback(bot, message)
          end
        end

        Thread.new do
          loop do
            message_info = RedisConnection.current.lpop('telegram_messages')
            if message_info
              send_notification(bot, message_info)
            else
              sleep 5
            end
          end
        end
      end
    end
  end

  private

  def send_notification(bot, message_info)
    message_info = JSON.parse(message_info, symbolize_names: true)
    logger.info "Sending telegram message: #{message_info}"
    bot.api.send_message(chat_id: message_info[:chat_id], text: message_info[:text])
  end

  def touch_callback(bot, message)
    if message.data == 'touch'
      bot.api.send_message(chat_id: message.from.id, text: "<Placeholder>")
    end
  end

  def dot_selected(bot, message)
    kb = [[
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Kada lis?', callback_data: 'touch'),
          ]]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: message.chat.id, text: 'Pasirink', reply_markup: markup)
  end

  def weather_today_selected(bot, message)
    bot.api.send_message(chat_id: message.chat.id, text: "Nėra lietaus")
  end

  def kaunas_selected(bot, message)
    bot.api.send_message(chat_id: message.chat.id, text: "<Placeholder command>, #{message.chat.id}")
  end
end
