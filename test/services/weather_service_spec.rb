require 'test_helper'
require 'webmock/minitest'

class WeatherServiceTest < ActiveSupport::TestCase
  def setup
    @weather_service = WeatherService.new
    @forecast_data = {
      'forecastCreationTimeUtc' => '2023-06-09 01:57:23',
      'place' => {
        'code' => 'kaunas',
        'name' => 'Kaunas',
        'administrativeDivision' => 'Kauno miesto savivaldybė',
        'country' => 'Lietuva',
        'countryCode' => 'LT',
        'coordinates' => { 'latitude' => 54.8985, 'longitude' => 23.9036 }
      },
      'forecastTimestamps' => [
        {
          'forecastTimestampUtc' => '2023-06-09 02:00:00',
          'airTemperature' => 1.1,
          'windSpeed' => 2.2,
          'windGust' => 3.3,
          'windDirection' => 4.4,
          'cloudCover' => 5.5,
          'seaLevelPressure' => 6.6,
          'relativeHumidity' => 7.7,
          'totalPrecipitation' => 8.8,
          'conditionCode' => 'clear'
        }
      ]
    }

    stub_request(:get, /api.meteo.lt/)
      .to_return(body: @forecast_data.to_json, status: 200)

    places(:kaunas)
  end

  test 'creates a new Forecast record for each forecast item' do
    assert_difference 'Forecast.count', 1 do
      @weather_service.call_forecast
    end
  end

  test 'saves the correct data to the Forecast record' do
    @weather_service.call_forecast

    forecast = Forecast.first
    assert_equal places(:kaunas).id, forecast.place_id
    assert_equal 'forecast_creation_time', forecast.forecast_creation_timestamp
    assert_equal 'forecast_timestamp', forecast.forecast_timestamp
    assert_equal 1.1, forecast.air_temperature
    assert_equal 2.2, forecast.wind_speed
    assert_equal 3.3, forecast.wind_gust
    assert_equal 4.4, forecast.wind_direction
    assert_equal 5.5, forecast.cloud_cover
    assert_equal 6.6, forecast.sea_level_pressure
    assert_equal 7.7, forecast.relative_humidity
    assert_equal 8.8, forecast.total_precipitation
    assert_equal 'condition_code', forecast.condition_code
  end
end
