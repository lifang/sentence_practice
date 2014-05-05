#encoding: utf-8
include Oauth2Helper
class LoginsController < ApplicationController
  def request_qq
    redirect_to "#{Oauth2Helper::REQUEST_URL_QQ}?#{Oauth2Helper::REQUEST_ACCESS_TOKEN.map{|k,v|"#{k}=#{v}"}.join("&")}"
  end

  def respond_qq
    render :layout=>"application"
  end

  def enter
    share_open_id = cookies[:share_open_id]
    nickname = params[:nickname]
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
      	@user = User.create(:level => User::INIT_LEVEL, :complete_per_cent => User::INIT_COMPLETE_PER_CENT, :gold => User::FIRST_REWORD_GOLD, :uniq_id => openid,:open_id =>cookies[:open_id] )
        share_record = ShareRecord.find_by_open_id_and_user_id share_open_id, @user.id
        if share_record.nil? && share_open_id.present?
          ShareRecord.create(:user_id => @user.id, :open_id => share_open_id, :status => ShareRecord::STATUS[:UNFINISH])
        end
        cookies[:user_id] = @user.id
      else
      	cookies[:user_id] = @user.id
        if @user.open_id.nil?
          @user.update_attributes(:open_id=> cookies[:open_id])
        end
      end
      user_url="https://graph.qq.com"
      user_route="/user/get_user_info?access_token=#{access_token}&oauth_consumer_key=#{Oauth2Helper::APPID}&openid=#{openid}"
      user_info=create_get_http(user_url,user_route)
      nickname = user_info["nickname"]
      if @user
        if nickname.present?
          @user.update_attributes(:nickname => nickname)  
        else 
          @user.update_attributes(:nickname => "qq用户") 
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
