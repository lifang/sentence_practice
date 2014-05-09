# encoding: utf-8
module Oauth2Helper
  require 'net/http'
  require "uri"
  require 'openssl'
  require 'net/http/post/multipart'
  
  #qq登录参数

  REQUEST_URL_QQ="https://graph.qq.com/oauth2.0/authorize"
  #请求openId
  REQUEST_OPENID_URL="https://graph.qq.com/oauth2.0/me"
  #请求详参
  APPID="101071254" #production appid
  # APPID="101069759" #test appid
  REQUEST_ACCESS_TOKEN={
    :response_type=>"token",
    :client_id=>APPID,
    :redirect_uri=>"#{Constant::SERVER_PATH}/logins/respond_qq",
    :scope=>"get_user_info,add_topic,add_pic_t,add_share,add_t",
    :state=>"1"
  }

  #构造get请求
  def create_get_http(url,route)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.port==443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request= Net::HTTP::Get.new(route)
    back_res =http.request(request)
    return JSON back_res.body
  end

end
