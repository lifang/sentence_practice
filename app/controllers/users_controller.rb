class UsersController < ApplicationController
	def index
		user_id = cookies[:user_id]
		if user_id.present?
			@user = User.find_by_id user_id
			if @user.present? 
				current_level_questions = Question.where(["level_types = ?",@user.level])
				current_level_questions_id = current_level_questions.map(&:id)
				@current_level_questions_count = current_level_questions.length
				@finish_questions_count = AnswerDetail.where(["question_id in (?) and second_status = ? and user_id = ?",
						current_level_questions_id, true, @user.id]).count if current_level_questions_id.present? && 
										current_level_questions_id.any?
			else	
				redirect_to root_path
			end	
		else
			redirect_to root_path		
		end	
	end	
end
