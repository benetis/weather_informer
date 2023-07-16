require 'test_helper'

class TelegramPrinterTest < Minitest::Test
  def setup
    @telegram_printer = TelegramPrinter.new
  end

  def test_next_rains_when_forecast_is_nil
    assert_equal "Lietus artimiausią savaitę nenumatytas", @telegram_printer.next_rains(nil)
  end

  def test_next_rains_when_forecast_is_today
    now = Time.now
    forecast = { rain: OpenStruct.new(forecast_timestamp: now) }
    expected_output = "Lietus šiandien apie #{forecast[:rain].forecast_timestamp.in_time_zone(TelegramPrinter::TIME_ZONE).strftime('%H:%M')}"
    assert_equal expected_output, @telegram_printer.next_rains(forecast)
  end

  def test_next_rains_when_forecast_is_tomorrow
    time = Time.now + 1.day
    forecast = { rain: OpenStruct.new(forecast_timestamp: time) }
    expected_output = "Lietaus prognozė rytoj apie #{forecast[:rain].forecast_timestamp.in_time_zone(TelegramPrinter::TIME_ZONE).strftime('%H:%M')}"
    assert_equal expected_output, @telegram_printer.next_rains(forecast)
  end

  def test_next_rains_when_forecast_is_in_future
    now = Time.now + 2.days
    forecast = { rain: OpenStruct.new(forecast_timestamp: now) }
    expected_output = "Lietus prognozuojamas #{forecast[:rain]
                                                 .forecast_timestamp
                                                 .in_time_zone(TelegramPrinter::TIME_ZONE)
                                                 .strftime('%Y-%m-%d %H:%M')}, °C"
    assert_equal expected_output, @telegram_printer.next_rains(forecast)
  end
end
