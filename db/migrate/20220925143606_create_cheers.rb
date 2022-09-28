class CreateCheers < ActiveRecord::Migration[7.0]
  def change
    create_table :cheers do |t|
      t.references :user,         null: false, foreign_key: true, type: :uuid
      t.references :declaration,  null: false, foreign_key: true

      t.timestamps
    end

    add_index :cheers, %i[user_id declaration_id], unique: true
  end
end
