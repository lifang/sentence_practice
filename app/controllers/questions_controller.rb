#encoding: utf-8
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
			@question = Question.where(["level_types = ? and id not in (?)", @user.level, answer_details_id]).order("Rand()").limit(5)
		else
			@question = Question.where(["level_types = ?", @user.level]).order("Rand()").limit(1)	
		end	
	end

	def check_answer
		user_id = cookies[:user_id].to_i
		question_id_str = params[:question_id_str]
		question_result = params[:question_result]
		step = params[:step]
		question_id = question_id_str.gsub(/question_/,"").to_i
		@question = Question.find_by_id question_id 
		if @question
			answer_details = AnswerDetail.find_by_user_id_and_question_id user_id, @question.id
			if answer_details
				if question_result == "true"
					answer_details.update_attributes(:correct_times => (answer_details.correct_times+1))
					@status = true
					@notice = "答对了！"
				elsif question_result == "false"
					@status = false
					@notice = "答错了！"
				end
			else
				answer_details = AnswerDetail.create(:user_id => user_id, :question_id => @question.id, :answer_times => 1, :correct_times => 0)
				if question_result == "true"
					answer_details.update_attributes(:correct_times => (answer_details.correct_times+1))
					@status = true
					@notice = "答对了！"
				elsif question_result == "false"
					@status = false
					@notice = "答错了！"
				end
			end
			if(answer_details.correct_times.to_f / answer_details.answer_times) >= 0.6	
				if step == "first"
					answer_details.update_attributes(:first_status => AnswerDetail::STATUS[:FINISH])
				elsif step == "second"
					answer_details.update_attributes(:second_status => AnswerDetail::STATUS[:FINISH])
				end	
			end	
		end	
	end	
end
