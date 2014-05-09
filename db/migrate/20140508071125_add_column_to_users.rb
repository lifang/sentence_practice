class AddColumnToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_first, :boolean, :default => true
  end
end
