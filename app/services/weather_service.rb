# frozen_string_literal: true

class WeatherService
  def initialize
    @meteo = Meteo.new
  end

  def call_places
    begin
      place = @meteo.get_place('kaunas')

      if place.success?
        Place.create(
          code: place['code'],
          name: place['name'],
          administrative_division: place['administrativeDivision'],
          country: place['country'],
          country_code: place['countryCode'],
          latitude: place['coordinates']['latitude'],
          longitude: place['coordinates']['longitude']
        )
      end

    rescue StandardError => e
      Rails.logger.error "MeteoService error: #{e.message}"
      nil
    end
  end

  def call_forecast
    begin
      forecast = @meteo.get_forecast('kaunas')

      if forecast.success?
        Forecast.create(
          place_id: forecast['place']['code'],
          forecast_timestamp: forecast['forecastTimestampUtc'],
          air_temperature: forecast['airTemperature'],
          wind_speed: forecast['windSpeed'],
          wind_gust: forecast['windGust'],
          wind_direction: forecast['windDirection'],
          cloud_cover: forecast['cloudCover'],
          sea_level_pressure: forecast['seaLevelPressure'],
          relative_humidity: forecast['relativeHumidity'],
          total_precipitation: forecast['totalPrecipitation'],
          condition_code: forecast['conditionCode']
        )
      end

    rescue StandardError => e
      Rails.logger.error "MeteoService error: #{e.message}"
      nil
    end
  end
end
