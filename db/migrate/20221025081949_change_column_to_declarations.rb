class ChangeColumnToDeclarations < ActiveRecord::Migration[7.0]
  def change
    change_column_default :declarations, :is_shared, from: false, to: true
  end
end
