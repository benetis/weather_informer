class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.references :place, null: false, foreign_key: true

      t.string :telegram_chat_id
      t.string :place

      t.timestamps
    end
    add_index :users, :telegram_chat_id, unique: true
  end
end
