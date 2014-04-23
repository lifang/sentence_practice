#encoding: utf-8
class SentencesController < ApplicationController
	def index
		user_id = cookies[:user_id]
		if user_id.present?
			@user = User.find_by_id user_id
			if @user.present?
				render :json => {:notice => "You have login success！"}	
			end
		end	
	end	
end
