require "test_helper"

class NotificationsMailerTest < ActionMailer::TestCase
  test "rain_predicted" do
    trigger = { :rain => "2021-08-01 00:00:00" }
    mail = NotificationsMailer.rain_predicted(trigger)
    assert_equal "Rain predicted", mail.subject
    assert_equal [Rails.application.credentials.dig(:emails_to_notify).first], mail.to
    assert_equal [Rails.application.credentials.dig(:smtp, :from)], mail.from
  end

end
