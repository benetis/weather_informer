# frozen_string_literal: true

class TelegramPrinter

  def next_rains(forecast)
    if forecast.nil?
      return "Lietus artimiausią savaitę nenumatytas"
    end

    if forecast[:rain].forecast_timestamp.today?
      return "Lietus šiandien apie #{forecast[:rain].forecast_timestamp.strftime('%H:%M')}"
    end

    if forecast[:rain].forecast_timestamp.tomorrow?
      return "Lietaus prognozė rytoj apie #{forecast[:rain].forecast_timestamp.strftime('%H:%M')}"
    end

    "Lietus prognozuojamas #{forecast[:rain].forecast_timestamp.strftime('%Y-%m-%d %H:%M')}, #{forecast[:rain].feels_like_temperature}°C"
  end

  def print_triggers(triggers)
    if triggers.empty?
      return "Jokių įspėjimų šiandien"
    end

    triggers.map do |trigger|
      if trigger[:rain]
        next_rains(trigger)
      elsif trigger[:hot]
        "Karšta #{trigger[:hot].forecast_timestamp.strftime('%H:%M')}, temperatūra #{trigger[:hot].feels_like_temperature}°C"
      elsif trigger[:scorching]
        "Ugnikalnio vidus ♨️♨️♨️ @ #{trigger[:scorching].forecast_timestamp.strftime('%H:%M')}, #{trigger[:scorching].feels_like_temperature}°C"
      elsif trigger[:windy]
        "Vėjuota #{trigger[:windy].forecast_timestamp.strftime('%H:%M')}, vėjo gūsis #{trigger[:windy].wind_gust} m/s"
      end
    end.join("\n")
  end
end
