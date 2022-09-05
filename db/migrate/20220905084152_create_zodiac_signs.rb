class CreateZodiacSigns < ActiveRecord::Migration[7.0]
  def change
    create_table :zodiac_signs do |t|
      t.integer :name, null: false

      t.timestamps
    end
    add_index :zodiac_signs, :name, unique: true
  end
end
