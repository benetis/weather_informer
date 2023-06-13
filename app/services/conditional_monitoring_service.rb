# frozen_string_literal: true

class ConditionalMonitoringService
  def check_forecasts(time_range, conditions)
    forecasts = Forecast.within_time_range(time_range)

    find_triggers(forecasts, conditions)
  end

  def will_rain?(forecast)
    forecast&.total_precipitation&.positive?
  end

  def find_triggers(forecasts, conditions)
    conditions.flat_map do |condition|
      forecasts.reduce([]) do |triggers, forecast|
        case condition
        when :rain
          triggers << { :rain => forecast.forecast_timestamp } if will_rain?(forecast)
        else
          puts "Unknown condition: #{condition}"
        end
        triggers
      end
    end
  end

end
