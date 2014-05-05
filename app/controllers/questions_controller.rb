#encoding: utf-8
include QuestionsHelper
class QuestionsController < ApplicationController
	def index
		user_id = cookies[:user_id]
		@user = User.find_by_id user_id
		if @user
			info = Question.get_next_question @user
			@question = info[:question]
			@step = info[:step]
			if @user.level == Question::LEVEL_TYPE[:START]
				#奖励分享用户的金币
				answer_details = AnswerDetail.where(["user_id = ?", @user.id])
				answer_details_count = answer_details.length
				share_record = ShareRecord.find_by_user_id_and_status @user.id, ShareRecord::STATUS[:UNFINISH]
				if share_record && answer_details_count == 0 
					share_user = User.find_by_open_id share_record.open_id
					if share_user
						share_user.update_attributes(:gold => (share_user.gold+10))	
						share_record.update_attributes(:status => ShareRecord::STATUS[:FINISH])
					end	
				end
			end
		end	
	end

	def get_next_question
		user_id = cookies[:user_id]
		@user = User.find_by_id user_id
		if @user
			@recduce_gold = 0
			case @user.level
				when Question::LEVEL_TYPE[:START] then @recduce_gold = 20
				when Question::LEVEL_TYPE[:PRIMARY] then @recduce_gold = 50
				when Question::LEVEL_TYPE[:EXAMINATION] then @recduce_gold = 100
				when Question::LEVEL_TYPE[:ENTRANCE] then @recduce_gold = 50
				when Question::LEVEL_TYPE[:FOUR] then @recduce_gold = 100
				when Question::LEVEL_TYPE[:SIX] then @recduce_gold = 100				
			end
			@level_name = Question::LEVEL_NAME[@user.level+1]
			info = Question.get_next_question @user
			@question = info[:question]
			@step = info[:step]
		end
	end	

	def check_answer
		user_id = cookies[:user_id].to_i
		question_id = params[:question_id]
		question_result = params[:question_result]
		step = params[:step]
		@question = Question.find_by_id question_id 
		if @question
			answer_details = AnswerDetail.find_by_user_id_and_question_id user_id, @question.id
			if answer_details
				answer_details.update_attributes(:answer_times => (answer_details.answer_times+1))
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
			answer_details = AnswerDetail.find_by_id answer_details.id
			if((answer_details.correct_times.to_f / answer_details.answer_times)*100) >= 60
				if step == "first"
					# if question_result == "true"
						answer_details.update_attributes(:first_status => AnswerDetail::STATUS[:FINISH], 
							:correct_times => 0, :answer_times => 0)
					# end	
				elsif step == "second"
					# if question_result == "true"
						answer_details.update_attributes(:second_status => AnswerDetail::STATUS[:FINISH],
							:correct_times => 0, :answer_times => 0)
					# end	
				end	
			end	
		end	
	end	
end
