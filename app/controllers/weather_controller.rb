# frozen_string_literal: true

class WeatherController < ActionController::Base
  skip_before_action :verify_authenticity_token

  # Temporary method to fetch places, will be moved to background job
  def fetch_places
    WeatherService.new.call_places
    puts "done"
  end

  def fetch_forecast
    WeatherService.new.call_forecast
    puts "done"
  end
end
