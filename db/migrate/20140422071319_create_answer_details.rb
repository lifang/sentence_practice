class CreateAnswerDetails < ActiveRecord::Migration
  def change
    create_table :answer_details do |t|
    	t.integer :question_id 
    	t.integer :answer_times
    	t.integer :correct_times
    	t.integer :user_id
    	t.boolean :status, :default => false

    	t.timestamps
    end
    add_index :answer_details, :question_id
    add_index :answer_details, :user_id
  end
end
