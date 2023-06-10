# frozen_string_literal: true

class ConditionalMonitoringService
  def check_forecasts_today
    forecasts = Forecast.where(forecast_timestamp: Date.today.beginning_of_day..Date.today.end_of_day)

    triggers = forecasts.reduce([]) do |triggers, forecast|
      triggers << forecast_triggers(forecast)
    end

    triggers.flatten
  end

  def forecast_triggers(forecast)
    triggers = []

    triggers << { :rain => forecast.forecast_timestamp } if will_rain?(forecast)

    triggers
  end

  def will_rain?(forecast)
    forecast.total_precipitation > 0
  end
end