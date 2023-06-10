# frozen_string_literal: true

class NotificationManagerService

  def notify_about_today
    triggers = ConditionalMonitoringService.new.check_forecasts_today

    if need_to_notify?(triggers)
      triggers.each do |trigger|
        case trigger
        in { rain: _ }
          NotificationsMailer.with(trigger).rain_predicted(trigger).deliver_now
        else
          puts "Unknown trigger: #{trigger}"
        end
      end
    end
  end

  private

  def need_to_notify?(triggers)
    triggers.any?
  end
end

