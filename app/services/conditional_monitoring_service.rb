# frozen_string_literal: true

class ConditionalMonitoringService
  def check_forecasts_today
    forecasts = Forecast
                  .where(forecast_timestamp: today)
                  .group_by(&:forecast_timestamp)
                  .map do |_, forecasts|
      return_newest_forecast(forecasts)
    end

    check_forecasts_for_triggers(forecasts).flatten
  end

  def forecast_triggers(forecast)
    triggers = []

    triggers << { :rain => forecast.forecast_timestamp } if will_rain?(forecast)

    triggers
  end

  def will_rain?(forecast)
    forecast&.total_precipitation&.positive?
  end

  private

  def today
    Date.today.beginning_of_day..Date.today.end_of_day
  end

  def check_forecasts_for_triggers(forecasts)
    triggers = forecasts.reduce([]) do |triggers, forecast|
      triggers << forecast_triggers(forecast)
    end
  end

  def return_newest_forecast(forecasts)
    forecasts.reject { |f| f.forecast_creation_timestamp.nil? }.max_by(&:forecast_creation_timestamp)
  end

end
