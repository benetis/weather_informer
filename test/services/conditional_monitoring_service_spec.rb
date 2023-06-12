require 'test_helper'

class ForecastTest < ActiveSupport::TestCase

  def setup
    @kaunas = places(:kaunas)
    @forecast_with_rain = Forecast.create!(place_id: @kaunas.id, forecast_timestamp: Date.today, total_precipitation: 5)
    @forecast_without_rain = Forecast.create!(place_id: @kaunas.id, forecast_timestamp: Date.today, total_precipitation: 0)

    assert @forecast_with_rain.save
    assert @forecast_without_rain.save
  end

  def test_check_forecasts_today
    service = ConditionalMonitoringService.new
    triggers = service.check_forecasts_today

    assert_kind_of Array, triggers
    assert_equal 1, triggers.count
    assert_equal({ :rain => @forecast_with_rain.forecast_timestamp }, triggers.first)
  end

  def test_triggers_with_rain
    service = ConditionalMonitoringService.new

    result = service.forecast_triggers(@forecast_with_rain)

    assert_kind_of Array, result
    assert_equal 1, result.count
    assert_equal({ :rain => @forecast_with_rain.forecast_timestamp }, result.first)
  end

  def test_triggers_without_rain
    service = ConditionalMonitoringService.new
    result = service.forecast_triggers(@forecast_without_rain)

    assert_kind_of Array, result
    assert_empty result
  end

  def test_will_rain_positive
    service = ConditionalMonitoringService.new
    assert service.send(:will_rain?, @forecast_with_rain)
  end

  def test_will_rain_negative
    service = ConditionalMonitoringService.new
    assert_not service.send(:will_rain?, @forecast_without_rain)
  end

  def test_deduplicate_forecasts
    service = ConditionalMonitoringService.new

    @updated_rain_forecast = Forecast.create!(
      place_id: @kaunas.id,
      forecast_timestamp: Date.today,
      total_precipitation: 6,
      forecast_creation_timestamp: Time.now.minus_with_duration(1.hour)
    )
    @updated_again_rain_forecast = Forecast.create!(
      place_id: @kaunas.id,
      forecast_timestamp: Date.today,
      total_precipitation: 6,
      forecast_creation_timestamp: Time.now.minus_with_duration(15.minutes)
    )

    assert @updated_rain_forecast.save
    assert @updated_again_rain_forecast.save

    triggers = service.check_forecasts_today

    assert_kind_of Array, triggers
    assert_equal 1, triggers.count
  end

end
