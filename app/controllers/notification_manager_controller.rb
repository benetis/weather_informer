class NotificationManagerController < ApplicationController
  skip_before_action :verify_authenticity_token

  def notify_about_today
    NotificationManagerService.new.notify_about_today
    render json: { status: :ok }
  end

end
