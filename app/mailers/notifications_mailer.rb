class NotificationsMailer < ApplicationMailer

  default from: Rails.application.credentials.dig(:smtp, :from)

  def rain_predicted(trigger)
    @greeting = "Rain is predicted today! #{trigger[:rain]}"

    mail to: Rails.application.credentials.dig(:emails_to_notify).first
  end
end
