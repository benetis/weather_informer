# frozen_string_literal: true

class NotificationManagerService

  def notify_about_today
    triggers = ConditionalMonitoringService.new.check_forecasts(Time.now..Time.now.end_of_day, [:rain])

    if need_to_notify?(triggers)
      triggers.each do |trigger|
        case trigger
        in { rain: _ }
          send_rain_notifications(trigger)
        else
          puts "Unknown trigger: #{trigger}"
        end
      end
    end
  end

  private

  def send_rain_notifications(trigger)
    if Rails.configuration.x.send_email
      send_email(trigger)
    end

    if Rails.configuration.x.send_telegram
      send_telegram_notification(trigger)
    end
  end

  def send_telegram_notification(trigger)
    enqueue_telegram_message({
                               :text => "It will rain today @ #{trigger}",
                               :chat_id => Rails.application.credentials.dig(:telegram_chats_to_notify).first
                             }.to_json)
  end

  def send_email(trigger)
    NotificationsMailer.with(trigger).rain_predicted(trigger).deliver_now
  end

  def enqueue_telegram_message(message)
    RedisConnection.current.rpush('telegram_messages', message)
  end

  def need_to_notify?(triggers)
    triggers.any?
  end
end

