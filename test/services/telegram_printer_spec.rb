require 'test_helper'

class TelegramPrinterTest < Minitest::Test
  def setup
    @telegram_printer = TelegramPrinter.new
  end

  def test_next_rains_when_forecast_is_nil
    assert_equal "Lietus artimiausią savaitę nenumatytas", @telegram_printer.next_rains(nil)
  end

  def test_next_rains_when_forecast_is_today
    forecast = { rain: Time.now }
    expected_output = "Lietus šiandien apie #{forecast[:rain].strftime('%H:%M')}"
    assert_equal expected_output, @telegram_printer.next_rains(forecast)
  end

  def test_next_rains_when_forecast_is_tomorrow
    forecast = { rain: Time.now + 1.day }
    expected_output = "Lietaus prognozė rytoj apie #{forecast[:rain].strftime('%H:%M')}"
    assert_equal expected_output, @telegram_printer.next_rains(forecast)
  end

  def test_next_rains_when_forecast_is_in_future
    forecast = { rain: Time.now + 2.days }
    expected_output = "Lietus prognozuojamas #{forecast[:rain].strftime('%Y-%m-%d %H:%M')}"
    assert_equal expected_output, @telegram_printer.next_rains(forecast)
  end
end
