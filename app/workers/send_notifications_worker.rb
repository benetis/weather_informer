class SendNotificationsWorker
  include Sidekiq::Worker
  def perform

    manager = NotificationManagerService.new

    manager.notify_about_today

    puts "Job 'notify_about_today' done"
  end
end

