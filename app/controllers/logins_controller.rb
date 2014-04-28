#encoding: utf-8
class LoginsController < ApplicationController
  def request_qq
    redirect_to "#{Oauth2Helper::REQUEST_URL_QQ}?#{Oauth2Helper::REQUEST_ACCESS_TOKEN.map{|k,v|"#{k}=#{v}"}.join("&")}"
  end

  def respond_qq
    render :layout=>"application"
  end

  def enter
  	begin
      meters=params[:access_token].split("&")
      access_token=meters[0].split("=")[1]
      expires_in=meters[1].split("=")[1].to_i
      openid=params[:open_id]
      unless openid
        flash[:share_notice]="网络繁忙，稍后重试"
        throw_error
      end
      @user= User.find_by_uniq_id(openid)
      if @user.nil?
      	@user = User.create(:level => User::INIT_LEVEL, :complete_per_cent => User::INIT_COMPLETE_PER_CENT, :gold => User::FIRST_REWORD_GOLD, :uniq_id => openid)
        cookies[:user_id] = @user.id
      else
      	cookies[:user_id] = @user.id
        if @user.open_id.nil?
          @user.update_attributes(:open_id=> cookies[:open_id])
        end
      end
      data=true
    rescue
      data=false
    end
    respond_to do |format|
      format.json {
        render :json=>data
      }
    end	
  end

  def exit
  	cookies[:user_id] = nil	
  	redirect_to "/"
  end	
end
