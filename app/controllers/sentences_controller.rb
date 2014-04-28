#encoding: utf-8
class SentencesController < ApplicationController
	def index
		# cookies[:user_id] = 1
    cookies[:open_id] = params[:open_id]
		user_id = cookies[:user_id]
		if user_id.present?
			@user = User.find_by_id user_id.to_i
			if @user.present?
				redirect_to :controller => :users, :action => :index	
			end	
		end	
	end	
end
