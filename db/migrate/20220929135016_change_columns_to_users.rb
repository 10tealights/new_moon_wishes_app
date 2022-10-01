class ChangeColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :line_uid, :string
    add_column :users, :picture_url, :string
    add_column :users, :line_name, :string
    remove_column :users, :account_id, :string
    change_column :users, :email, :string, null: true
  end
end
