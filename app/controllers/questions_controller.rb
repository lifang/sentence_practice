include QuestionsHelper
class QuestionsController < ApplicationController
	def index
		user_id = cookies[:user_id]
		@user = User.find_by_id user_id
		questions_count = Question.where(["level_types = ?", @user.level]).count
		answer_details = AnswerDetail.where(["first_status = ? and user_id = ?", true, @user.id])
		@step = "first"
		if answer_details.length == questions_count
			@step = "second"
			answer_details = AnswerDetail.where(["second_status = ? and user_id = ?", true, @user.id])
		end
		answer_details_id = answer_details.map(&:question_id)
		if answer_details_id.any?
			@questions = Question.where(["level_types = ? and id is not in (?)", @user.level, answer_details_id]).order("Rand()").limit(5)
		else
			@questions = Question.where(["level_types = ?", @user.level]).order("Rand()").limit(5)	
		end	
	end

	def check_answer
	end	
end
