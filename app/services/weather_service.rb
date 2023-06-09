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
end
