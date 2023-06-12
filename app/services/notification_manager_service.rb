# frozen_string_literal: true

class NotificationManagerService

  def notify_about_today
    triggers = ConditionalMonitoringService.new.check_forecasts_today

    if need_to_notify?(triggers)
      triggers.each do |trigger|
        case trigger
        in { rain: _ }
          if Rails.configuration.x.send_email
            NotificationsMailer.with(trigger).rain_predicted(trigger).deliver_now
          end

          if Rails.configuration.x.send_telegram
            enqueue_telegram_message({
                                       :text => "It will rain today @ #{trigger}",
                                       :chat_id => Rails.application.credentials.dig(:telegram_chats_to_notify).first
                                     }.to_json)
            puts "Sending telegram notification"
          end
        else
          puts "Unknown trigger: #{trigger}"
        end
      end
    end
  end

  private

  def enqueue_telegram_message(message)
    RedisConnection.current.rpush('telegram_messages', message)
  end

  def need_to_notify?(triggers)
    triggers.any?
  end
end

