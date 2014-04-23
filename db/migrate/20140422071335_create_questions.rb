class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
    	t.integer :level_types
    	t.string :translation
    	t.string :original_sentence
    	
    	t.timestamps
    end
    add_index :questions, :level_types
  end
end
