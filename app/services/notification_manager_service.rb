# frozen_string_literal: true

class NotificationManagerService
  def check_last_forecast
    forecast = Forecast.last

    if will_rain?(forecast)
      # send_alert(forecast)
    end
  end

  def will_rain?(forecast)
    forecast.total_precipitation > 0
  end
end
