class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :uniq_id
    	t.integer :level
    	t.integer :complete_per_cent
    	t.integer :gold
    	t.string :open_id

      	t.timestamps
    end
  end
end
