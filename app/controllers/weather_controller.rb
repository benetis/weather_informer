# frozen_string_literal: true

class WeatherController < ActionController::Base
  skip_before_action :verify_authenticity_token, only: :fetch_places

  # Temporary method to fetch places, will be moved to background job
  def fetch_places
    WeatherService.new.call_places
    puts "done"
  end
end
