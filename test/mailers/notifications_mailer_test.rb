require "test_helper"

class NotificationsMailerTest < ActionMailer::TestCase
  test "rain_predicted" do
    mail = NotificationsMailer.rain_predicted
    assert_equal "Rain predicted", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
