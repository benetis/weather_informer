# app/workers/telegram_bot_worker.rb

require 'telegram/bot'
class TelegramBotWorker
  include Sidekiq::Worker

  def perform(*args)
    token = Rails.application.credentials.dig(:telegram_api_key)

    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
        when '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
        end
      end
    end
  end
end
