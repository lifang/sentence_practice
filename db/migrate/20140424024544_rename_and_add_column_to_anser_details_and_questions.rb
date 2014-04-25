class RenameAndAddColumnToAnserDetailsAndQuestions < ActiveRecord::Migration
  def change
  	rename_column :answer_details, :status, :first_status
  	add_column :answer_details, :second_status, :boolean, :default => false
  	add_column :questions, :similar_words, :string
  end
end
