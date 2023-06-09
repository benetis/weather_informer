# "place": {
#   "code": "kaunas",
#   "name": "Kaunas",
#   "administrativeDivision": "Kauno miesto savivaldybė",
#   "country": "Lietuva",
#   "countryCode": "LT",
#   "coordinates": {
#     "latitude": 54.898214,
#     "longitude": 23.904482
#   }
# },


class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :code
      t.string :name
      t.string :administrative_division
      t.string :country
      t.string :country_code
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
