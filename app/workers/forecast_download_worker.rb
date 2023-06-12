# frozen_string_literal: true

class ForecastDownloadWorker
  include Sidekiq::Worker

  def perform
    WeatherService.new.fetch_forecasts # TODO: make it scheduled
  end
end
