# frozen_string_literal: true

class WeatherService
  def initialize
    @meteo = Meteo.new
  end

  def fetch_places
    begin
      place = @meteo.get_place('kaunas')

      if place.success?
        response = JSON.parse(place.body)
        Place.create(
          code: response['code'],
          name: response['name'],
          administrative_division: response['administrativeDivision'],
          country: response['country'],
          country_code: response['countryCode'],
          latitude: response['coordinates']['latitude'],
          longitude: response['coordinates']['longitude']
        )
      end

    rescue StandardError => e
      Rails.logger.error "MeteoService error: #{e.message}"
      nil
    end
  end

  def fetch_forecasts
    begin
      forecast = @meteo.get_forecast('kaunas')

      if forecast.success?
        response = JSON.parse(forecast.body)
        forecast_created_at = response['forecastCreationTimeUtc']
        place = Place.find_by(code: response['place']['code'])

        response['forecastTimestamps'].each do |forecast_item|
          Forecast.create(
            place_id: place.id,
            forecast_creation_timestamp: forecast_created_at,
            forecast_timestamp: forecast_item['forecastTimeUtc'],
            air_temperature: forecast_item['airTemperature'],
            feels_like_temperature: forecast_item['feelsLikeTemperature'],
            wind_speed: forecast_item['windSpeed'],
            wind_gust: forecast_item['windGust'],
            wind_direction: forecast_item['windDirection'],
            cloud_cover: forecast_item['cloudCover'],
            sea_level_pressure: forecast_item['seaLevelPressure'],
            relative_humidity: forecast_item['relativeHumidity'],
            total_precipitation: forecast_item['totalPrecipitation'],
            condition_code: forecast_item['conditionCode']
          )
        end
      else
        Rails.logger.error "MeteoService error: #{forecast['error']['message']}"
      end

    rescue StandardError => e
      Rails.logger.error "MeteoService error: #{e.message}"
      nil
    end
  end
end
