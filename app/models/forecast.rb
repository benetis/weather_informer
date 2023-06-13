class Forecast < ApplicationRecord
  
  scope :within_time_range, ->(time_range) { where(forecast_timestamp: time_range).deduplicate_by_most_recent }

  def self.deduplicate_by_most_recent
    group(:forecast_timestamp).maximum(:forecast_creation_timestamp).map do |value, timestamp|
      where(:forecast_timestamp => value, :forecast_creation_timestamp => timestamp).take
    end
  end

end
