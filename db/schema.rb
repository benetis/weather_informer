# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_16_095214) do
  create_table "forecasts", force: :cascade do |t|
    t.integer "place_id", null: false
    t.datetime "forecast_creation_timestamp", null: false
    t.datetime "forecast_timestamp", null: false
    t.float "air_temperature"
    t.float "feels_like_temperature"
    t.float "wind_speed"
    t.float "wind_gust"
    t.float "wind_direction"
    t.float "cloud_cover"
    t.float "sea_level_pressure"
    t.float "relative_humidity"
    t.float "total_precipitation"
    t.string "condition_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_forecasts_on_place_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "administrative_division"
    t.string "country"
    t.string "country_code"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "place_id", null: false
    t.string "telegram_chat_id"
    t.string "place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_users_on_place_id"
    t.index ["telegram_chat_id"], name: "index_users_on_telegram_chat_id", unique: true
  end

  add_foreign_key "forecasts", "places"
  add_foreign_key "users", "places"
end
