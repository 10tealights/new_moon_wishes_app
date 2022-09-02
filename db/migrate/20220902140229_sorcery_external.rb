class SorceryExternal < ActiveRecord::Migration[7.0]
  def change
    create_table :authentications do |t|
      t.string :user_id, :provider, :uid, null: false

      t.timestamps                        null: false
    end

    add_index :authentications, [:provider, :uid]
    add_index :authentications, :user_id
  end
end
