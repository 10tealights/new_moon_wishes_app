class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :need_newmoon_msg,  :boolean, null: false, default: false
    add_column :users, :need_fullmoon_msg, :boolean, null: false, default: false
  end
end
