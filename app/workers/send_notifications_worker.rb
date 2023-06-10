class SendNotificationsWorker
  include Sidekiq::Worker
  def perform
    # controller = NotificationManagerController.new
    #
    # controller.notify_about_today
    # puts "Job 'notify_about_today' done"
  end
end

