class CreateDeclarations < ActiveRecord::Migration[7.0]
  def change
    create_table :declarations do |t|
      t.references :wish,     null: false, foreign_key: true
      t.string :message,      null: false
      t.integer :come_true,   null: false, default: 0
      t.boolean :is_shared,   null: false, default: false

      t.timestamps
    end
  end
end
