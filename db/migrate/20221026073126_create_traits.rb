class CreateTraits < ActiveRecord::Migration[7.0]
  def change
    create_table :traits do |t|
      t.string :keyword
      t.references :zodiac_sign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
