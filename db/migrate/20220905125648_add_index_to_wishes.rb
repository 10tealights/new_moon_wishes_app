class AddIndexToWishes < ActiveRecord::Migration[7.0]
  def change
    add_index :wishes, %i[user_id moon_id], unique: true
  end
end
