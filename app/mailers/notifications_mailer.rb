class NotificationsMailer < ApplicationMailer

  default from: Rails.application.credentials.dig(:smtp, :from)

  def rain_predicted
    @greeting = "Hi"

    mail to: Rails.application.credentials.dig(:emails_to_notify).first
  end
end
