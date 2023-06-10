require 'test_helper'

class NotificationManagerServiceTest < ActiveSupport::TestCase
  setup do
    @service = NotificationManagerService.new
    @triggers = [{ rain: Date.today }]
    @conditional_monitoring_service = ConditionalMonitoringService.new
  end

  test 'should notify when there are triggers' do
    @conditional_monitoring_service.stubs(:check_forecasts_today).returns(@triggers)
    ConditionalMonitoringService.stubs(:new).returns(@conditional_monitoring_service)

    mailer = mock('mailer')
    NotificationsMailer.stubs(:with).with(@triggers.first).returns(mailer)
    mailer.stubs(:rain_predicted).returns(mailer)
    mailer.expects(:deliver_now).returns(true)

    @service.notify_about_today
  end

  test 'should not notify when there are no triggers' do
    @conditional_monitoring_service.stubs(:check_forecasts_today).returns([])
    ConditionalMonitoringService.stubs(:new).returns(@conditional_monitoring_service)

    NotificationsMailer.expects(:with).never

    @service.notify_about_today
  end
end
