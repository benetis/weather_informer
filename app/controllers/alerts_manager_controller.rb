class AlertsManagerController < ApplicationController
  skip_before_action :verify_authenticity_token

  def send_alert
    NotificationsMailer.rain_predicted.deliver_now
  end

end
