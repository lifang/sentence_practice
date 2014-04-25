class QuestionsController < ApplicationController
	def index
		user_id = cookies[:user_id]
		@user = User.find_by_id user_id
		@questions = Question.where(["level_types = ?", @user.level]).limit(5)
	end

end
