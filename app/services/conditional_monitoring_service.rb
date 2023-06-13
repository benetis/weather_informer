# frozen_string_literal: true

class ConditionalMonitoringService
  HOT_TEMP_RANGE = 25...30
  CLEAR_SKY_HOT_TEMP_RANGE = 24...29

  SCORCHING_TEMP_RANGE = 30..100
  CLEAR_SKY_SCORCHING_TEMP_RANGE = 29..100

  CLEAR_SKY_RANGE = 0..30

  def check_forecasts(time_range, conditions)
    forecasts = Forecast.within_time_range(time_range)

    find_triggers(forecasts, conditions)
  end

  def find_triggers(forecasts, conditions)
    conditions.flat_map do |condition|
      forecasts.reduce([]) do |triggers, forecast|
        case condition
        when :rain
          triggers << { :rain => forecast.forecast_timestamp } if will_rain?(forecast)
        when :hot
          triggers << { :hot => forecast.forecast_timestamp } if is_hot?(forecast)
        when :scorching
          triggers << { :scorching => forecast.forecast_timestamp } if is_scorching?(forecast)
        when :windy
          triggers << { :windy => forecast.forecast_timestamp } if forecast&.wind_gust >= 10
        else
          puts "Unknown condition: #{condition}"
        end
        triggers
      end
    end
  end

  def will_rain?(forecast)
    forecast&.total_precipitation&.positive?
  end

  private

  def temperature_in_range?(forecast, clear_sky_range, other_range)
    if forecast&.cloud_cover&.in?(CLEAR_SKY_RANGE)
      forecast&.feels_like_temperature&.in?(clear_sky_range)
    else
      forecast&.feels_like_temperature&.in?(other_range)
    end
  end

  def is_hot?(forecast)
    temperature_in_range?(forecast, CLEAR_SKY_HOT_TEMP_RANGE, HOT_TEMP_RANGE)
  end

  def is_scorching?(forecast)
    temperature_in_range?(forecast, CLEAR_SKY_SCORCHING_TEMP_RANGE, SCORCHING_TEMP_RANGE)
  end

end
