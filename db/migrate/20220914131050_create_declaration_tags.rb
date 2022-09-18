class CreateDeclarationTags < ActiveRecord::Migration[7.0]
  def change
    create_table :declaration_tags do |t|
      t.references :declaration, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :declaration_tags, %i[declaration_id tag_id], unique: true
  end
end
