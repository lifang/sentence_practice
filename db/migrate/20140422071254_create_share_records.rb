class CreateShareRecords < ActiveRecord::Migration
  def change
    create_table :share_records do |t|
    	t.integer :user_id 
    	t.string :open_id
    	t.boolean :status, :default => false

    	t.timestamps
    end
    add_index :share_records, :user_id 
  end
end
