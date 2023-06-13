# frozen_string_literal: true

class TelegramPrinter

  def next_rains(forecast)
    if forecast.nil?
      "Lietus artimiausią savaitę nenumatytas"
    end

    if forecast[:rain].today?
      "Lietus šiandien apie #{forecast[:rain].strftime('%H:%M')}"
    end

    if forecast[:rain].tomorrow?
      "Lietaus prognozė rytoj apie #{forecast[:rain].strftime('%H:%M')}"
    end

    "Lietus prognozuojamas #{forecast[:rain].strftime('%Y-%m-%d %H:%M')}"
  end
end
