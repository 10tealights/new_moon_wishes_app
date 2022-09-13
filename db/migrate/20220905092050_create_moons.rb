class CreateMoons < ActiveRecord::Migration[7.0]
  def change
    create_table :moons do |t|
      t.references :zodiac_sign, null: false, foreign_key: true
      t.datetime :newmoon_time,  null: false
      t.datetime :fullmoon_time, null: false

      t.timestamps
    end
  end
end
