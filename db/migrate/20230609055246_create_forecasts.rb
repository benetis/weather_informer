class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|

      t.references :place, null: false, foreign_key: true
      t.datetime :forecast_creation_timestamp
      t.datetime :forecast_timestamp
      t.float :air_temperature
      t.float :feels_like_temperature
      t.float :wind_speed
      t.float :wind_gust
      t.float :wind_direction
      t.float :cloud_cover
      t.float :sea_level_pressure
      t.float :relative_humidity
      t.float :total_precipitation
      t.string :condition_code


      t.timestamps
    end
  end
end
