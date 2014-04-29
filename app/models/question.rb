#encoding: utf-8
class Question < ActiveRecord::Base
	attr_protected :authentications
	has_many :answer_details, :dependent => :destroy
	LEVEL_TYPE = {:START => 0, :PRIMARY => 1, :EXAMINATION => 2, :ENTRANCE => 3, :FOUR => 4, :SIX => 5, :ABROAD => 6}
	               #0 入门     1 初级    2 中考    3 高考    4 四级    5 六级    6  出国
	LEVEL_NAME = {0 => "入门", 1 => "初级", 2 => "中考", 3 =>"高考", 4 =>"四级", 5 => "六级", 6 => "出国"}     

	def self.get_next_question user
		questions = Question.where(["level_types = ?", user.level])
		if questions.any?
			questions_id = questions.map(&:id)
			questions_count = questions.length if questions.any?
			answer_details = AnswerDetail.where(["first_status = ? and user_id = ? and question_id in (?)", true, user.id, questions_id])
			step = "first"
			if answer_details.length == questions_count
				step = "second"
				answer_details = AnswerDetail.where(["second_status = ? and user_id = ? and question_id in (?)", true, user.id, questions_id])
			end
			answer_details_id = answer_details.map(&:question_id)
			if answer_details_id.any?
				question = Question.where(["level_types = ? and id not in (?)",user.level, answer_details_id]).order("Rand()").limit(1)
			else
				question = Question.where(["level_types = ?", user.level]).order("Rand()").limit(1)
			end	
			question = question.first
		end	
		{:question => question, :step => step}
	end         
end
