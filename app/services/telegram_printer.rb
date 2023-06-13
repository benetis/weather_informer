# frozen_string_literal: true

class TelegramPrinter

  def next_rains(forecast)
    if forecast.nil?
      return "Lietus artimiausią savaitę nenumatytas"
    end

    if forecast[:rain].today?
      return "Lietus šiandien apie #{forecast[:rain].strftime('%H:%M')}"
    end

    if forecast[:rain].tomorrow?
      return "Lietaus prognozė rytoj apie #{forecast[:rain].strftime('%H:%M')}"
    end

    "Lietus prognozuojamas #{forecast[:rain].strftime('%Y-%m-%d %H:%M')}"
  end

  def print_triggers(triggers)
    if triggers.empty?
      return "Jokių įspėjimų šiandien"
    end

    triggers.map do |trigger|
      if trigger[:rain]
        next_rains(trigger)
      elsif trigger[:hot]
        "Karšta #{trigger[:hot].strftime('%H:%M')}"
      elsif trigger[:scorching]
        "Ugnikalnio vidus ♨️♨️♨️ #{trigger[:scorching].strftime('%H:%M')}"
      elsif trigger[:windy]
        "Vėjuota #{trigger[:windy].strftime('%H:%M')}"
      end
    end.join("\n")
  end
end
