#encoding: utf-8
class UsersController < ApplicationController
	#我的概览
	def index
		url = request.url 
		@status = url.scan(/status\=.*/).first.to_s.gsub(/status\=/,"")
		user_id = cookies[:user_id]
		if user_id.present?
			@user = User.find_by_id user_id
			if @user.present? 
				info = Question.get_next_question @user
				@question = info[:question]			
				current_level_questions = Question.where(["level_types = ?",@user.level])
				current_level_questions_id = current_level_questions.map(&:id)
				@questions = Question.where(["level_types = ?", @user.level])
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

	#计算金币
	def calculate_score
		user_id = cookies[:user_id]
		user = User.find_by_id user_id
		correct_counts = params[:correct_counts]
		@correct_counts = correct_counts.to_i
		if user
			if @correct_counts < 5
				user.update_attributes(:gold => (user.gold-1))
			elsif @correct_counts == 5
				user.update_attributes(:gold => (user.gold+1))
			elsif @correct_counts > 5
				user.update_attributes(:gold => (user.gold+2))	
			end 
		end
	end

	#显示得分
	def show_score
		url = request.url
		user_id = cookies[:user_id]
		@correct_counts = url.scan(/correct_counts\=.*/).first.to_s.gsub(/correct_counts\=/,"").to_i
		user = User.find_by_id user_id
		current_level_questions = Question.where(["level_types = ?",user.level])
		current_level_questions_id = current_level_questions.map(&:id)
		@current_level_questions_count = current_level_questions.length
		@finish_questions_count = AnswerDetail.where(["question_id in (?) and second_status = ? and user_id = ?",
				current_level_questions_id, true, user.id]).count if current_level_questions_id.present? && 
								current_level_questions_id.any?
	end	

	#解锁等级
	def unlock_next_level
		user_id = cookies[:user_id]
		user = User.find_by_id user_id
		if user
			if user.gold >= 20
				info = Question.get_next_question user
				@question = info[:question]
				@step = info[:step]
				if !@question.present?
					@status = true
					flash[:notice] = "解锁成功，恭喜您升入新等级！"
					user.update_attributes(:level => (user.level+1), :gold => (user.gold-20))
				end
			else
				@status = false
				flash[:notice] = "您的金币不足，无法解锁新等级！"
			end	
		end	
		p @status
	end		
end
