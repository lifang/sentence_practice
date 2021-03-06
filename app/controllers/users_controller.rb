#encoding: utf-8
include QuestionsHelper
class UsersController < ApplicationController
	#我的概览
	def index
		@status = params[:status]
		user_id = cookies[:user_id]
		if user_id.present?
			@user = User.find_by_id user_id
			if @user.present? 
				info = Question.get_next_question @user
				@question = info[:question]
				@step = info[:step]		
				current_level_questions = Question.where(["level_types = ?",@user.level])
				current_level_questions_id = current_level_questions.map(&:id)
				@questions = Question.where(["level_types = ?", @user.level])
				@current_level_questions_count = current_level_questions.length
				@one_day_answer_count =  AnswerDetail
					.where("(created_at > CURRENT_TIMESTAMP - INTERVAL 1 day or 
						updated_at > CURRENT_TIMESTAMP - INTERVAL 1 day) and user_id = #{@user.id}").count
				if @step == "first"
					@finish_questions_count = AnswerDetail.where(["question_id in (?) and first_status = ? and user_id = ?",
						current_level_questions_id, true, @user.id]).count if current_level_questions_id.present? && 
										current_level_questions_id.any?
				else
					@finish_questions_count = AnswerDetail.where(["question_id in (?) and second_status = ? and user_id = ?",
						current_level_questions_id, true, @user.id]).count if current_level_questions_id.present? && 
										current_level_questions_id.any?
				end
        #File.open("#{Rails.root}/public/1.log", "a"){|f| f.write @finish_questions_count.to_s + "------------"}
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
		questions_id = params[:questions_id]
		questions_id = encode_str questions_id
		@questions_id = questions_id.gsub(/\n/,"")
		# p @questions_id
		@gold = user.gold
		if user
			if @correct_counts < 5
				if user.gold > 0
					user.update_attributes(:gold => (user.gold-1))
				end	
			elsif @correct_counts == 5
				user.update_attributes(:gold => (user.gold+1))
			elsif @correct_counts > 5
				user.update_attributes(:gold => (user.gold+2))	
			end 
		end
	end

	#显示得分
	def show_score
		@correct_counts =  params[:correct_counts].to_i
		@collections_id = params[:collections_id]
		@gold = params[:gold].to_i
		user_id = cookies[:user_id]
		@user = User.find_by_id user_id
		info = Question.get_next_question @user
		@question = info[:question]
		@step = info[:step]	
		current_level_questions = Question.where(["level_types = ?",@user.level])
		current_level_questions_id = current_level_questions.map(&:id)
		@current_level_questions_count = current_level_questions.length
		if @step == "first"
			@finish_questions_count = AnswerDetail.where(["question_id in (?) and first_status = ? and user_id = ?",
				current_level_questions_id, true, @user.id]).count if current_level_questions_id.present? && 
								current_level_questions_id.any?
		else
			@finish_questions_count = AnswerDetail.where(["question_id in (?) and second_status = ? and user_id = ?",
				current_level_questions_id, true, @user.id]).count if current_level_questions_id.present? && 
								current_level_questions_id.any?
		end

	end	

	#解锁等级
	def unlock_next_level
		user_id = cookies[:user_id]
		user = User.find_by_id user_id
		correct_counts = params[:correct_counts]
		if user
			if correct_counts.present?
				correct_counts = correct_counts.to_i
				if correct_counts < 5
					# if user.gold > 0
						# user.update_attributes(:gold => (user.gold-1))
					# end	
				elsif correct_counts == 5
					user.update_attributes(:gold => (user.gold+1))
				elsif correct_counts > 5
					user.update_attributes(:gold => (user.gold+2))	
				end
			end	
			info = Question.get_next_question user
			@question = info[:question]
			@step = info[:step]
			recduce_gold = 10
			if !@question.present?
				# case user.level
				# 	when Question::LEVEL_TYPE[:START] then recduce_gold = 20
				# 	when Question::LEVEL_TYPE[:PRIMARY] then recduce_gold = 50
				# 	when Question::LEVEL_TYPE[:EXAMINATION] then recduce_gold = 100
				# 	when Question::LEVEL_TYPE[:ENTRANCE] then recduce_gold = 50
				# 	when Question::LEVEL_TYPE[:FOUR] then recduce_gold = 100
				# 	when Question::LEVEL_TYPE[:SIX] then recduce_gold = 100				
				# end
		        if user.level != Question::LEVEL_TYPE[:ABROAD]
		          if user.gold >= recduce_gold
		            @status = true
		            flash[:notice] = "解锁成功，恭喜您升入新等级！"
		            user.update_attributes(:level => (user.level+1), :gold => (user.gold-recduce_gold))
		          else
		            @status = false
		            flash[:notice] = "您的金币不足，无法解锁新等级！"
		          end
		        else
		           @status = true
		           flash[:notice] = "恭喜您通关完成！"
		        end
			end
		end
	end		

	def share
		share_open_id = params[:share_open_id]
		user_id = cookies[:user_id]
		user = User.find_by_id user_id
		if share_open_id.present? 
			if !user.present?
				cookies[:share_open_id] = share_open_id
				redirect_to :action => :share
			else
				if user.open_id != share_open_id
					cookies[:share_open_id] = share_open_id
					cookies[:user_id] = nil
					redirect_to :action => :share
				else
						
				end	
			end	
		else
			if user.present?
				redirect_to :share_open_id => user.open_id	
			end
		end
	end	

	#统计
	def statistics
		@user_count = User.count

		@answer_details_count = AnswerDetail.count

		@one_day_user_count = AnswerDetail.select("DISTINCT user_id")
				   .where("created_at > CURRENT_TIMESTAMP - INTERVAL 1 day or 
						updated_at > CURRENT_TIMESTAMP - INTERVAL 1 day").count

		@one_day_answer_count =  AnswerDetail
					.where("created_at > CURRENT_TIMESTAMP - INTERVAL 1 day or 
						updated_at > CURRENT_TIMESTAMP - INTERVAL 1 day").count

		@seven_day_user_count = AnswerDetail.select("DISTINCT user_id")
				   .where("created_at > CURRENT_TIMESTAMP - INTERVAL 7 day or
				   		updated_at > CURRENT_TIMESTAMP - INTERVAL 7 day ").count 

		@seven_day_answer_count = AnswerDetail
				   .where("created_at > CURRENT_TIMESTAMP - INTERVAL 7 day or 
				   		updated_at > CURRENT_TIMESTAMP - INTERVAL 7 day").count

		@thirty_day_user_count = AnswerDetail.select("DISTINCT user_id")
				   .where("created_at > CURRENT_TIMESTAMP - INTERVAL 30 day or 
				   		updated_at > CURRENT_TIMESTAMP - INTERVAL 30 day").count
				
		@thirty_day_answer_count = AnswerDetail
				   .where("created_at > CURRENT_TIMESTAMP - INTERVAL 30 day or 
				   		updated_at > CURRENT_TIMESTAMP - INTERVAL 30 day").count
	end	

	#回顾
	def review
		questions_id = params[:questions_id]
		@questions = []
		if questions_id.present?
			questions_id = decode_str questions_id
			questions_id = questions_id.split(",,")
			if questions_id.any?
				@questions = Question.where("id in (?)", questions_id)
			end
		end
	end	
end
