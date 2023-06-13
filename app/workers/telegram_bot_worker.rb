# app/workers/telegram_bot_worker.rb

require 'telegram/bot'

class TelegramBotWorker
  include Sidekiq::Worker

  def initialize
    @bot_service = TelegramBotService.new
  end

  def perform(*args)
    token = Rails.application.credentials.dig(:telegram_api_key)
    allowed_chat_ids = Rails.application.credentials.dig(:telegram_allowed_chat_ids)

    Telegram::Bot::Client.run(token) do |bot|
      Thread.new do
        bot.listen do |message|
          if message.chat.id.in?(allowed_chat_ids)
            logger.info "Received message: #{message}"
          else
            logger.info "Received message from not allowed chat: #{message}"
            next
          end

          case message
          when Telegram::Bot::Types::Message
            case message.text
            when /kaunas/i
              @bot_service.kaunas_selected(bot, message)
            when /orai/i
              @bot_service.weather_today_selected(bot, message)
            when '.'
              @bot_service.dot_selected(bot, message)
            end

          when Telegram::Bot::Types::CallbackQuery
            @bot_service.button_callback(bot, message)
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
end
