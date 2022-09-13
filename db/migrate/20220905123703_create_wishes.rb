class CreateWishes < ActiveRecord::Migration[7.0]
  def change
    create_table :wishes do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :moon, null: false, foreign_key: true
      t.text :memo

      t.timestamps
    end
  end
end
