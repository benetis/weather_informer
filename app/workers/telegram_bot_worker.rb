# app/workers/telegram_bot_worker.rb

require 'telegram/bot'
class TelegramBotWorker
  include Sidekiq::Worker

  def perform(*args)
    token = Rails.application.credentials.dig(:telegram_api_key)

    Telegram::Bot::Client.run(token) do |bot|
      Thread.new do
          bot.listen do |message|
            case message.text
            when '/start'
              bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}, #{message.chat.id}")
            when '/stop'
              bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
            end
          end
      end

      Thread.new do
        loop do
          message_info = RedisConnection.current.lpop('telegram_messages')
          if message_info
            message_info = JSON.parse(message_info, symbolize_names: true)
            bot.api.send_message(chat_id: message_info[:chat_id], text: message_info[:text])
          else
            sleep 5
          end
        end
      end
    end

  end
end
