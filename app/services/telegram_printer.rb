# frozen_string_literal: true

class TelegramPrinter

  TIME_ZONE = 'Europe/Vilnius'

  def next_rains(forecast)
    if forecast.nil?
      return "Lietus artimiausią savaitę nenumatytas"
    end

    if forecast[:rain].forecast_timestamp.in_time_zone(TIME_ZONE).today?
      return "Lietus šiandien apie #{print_hours(forecast[:rain].forecast_timestamp)}"
    end

    if forecast[:rain].forecast_timestamp.in_time_zone(TIME_ZONE).tomorrow?
      return "Lietaus prognozė rytoj apie #{print_hours(forecast[:rain].forecast_timestamp)}"
    end

    "Lietus prognozuojamas #{forecast[:rain].forecast_timestamp.in_time_zone(TIME_ZONE).strftime('%Y-%m-%d %H:%M')}, #{forecast[:rain].feels_like_temperature}°C"
  end

  def print_triggers(triggers)
    if triggers.empty?
      return "Jokių įspėjimų šiandien"
    end

    triggers.map do |trigger|
      if trigger[:rain]
        next_rains(trigger)
      elsif trigger[:hot]
        "Karšta #{print_hours(trigger[:hot].forecast_timestamp)}, temperatūra #{trigger[:hot].feels_like_temperature}°C"
      elsif trigger[:scorching]
        "Ugnikalnio vidus ♨️♨️♨️ @ #{print_hours(trigger[:scorching].forecast_timestamp)}, #{trigger[:scorching].feels_like_temperature}°C"
      elsif trigger[:windy]
        "Vėjuota #{print_hours(trigger[:windy].forecast_timestamp)}, vėjo gūsis #{trigger[:windy].wind_gust} m/s"
      end
    end.join("\n")
  end

  def print_hours(timestamp)
    timestamp.in_time_zone(TIME_ZONE).strftime('%H:%M')
  end

end
