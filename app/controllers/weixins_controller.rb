#encoding: utf-8
class WeixinsController < ApplicationController
  require 'digest/sha1'
  require 'net/http'
  require "uri"
  require 'openssl'
  require "open-uri"
  require "tempfile"
  #用于处理相应服务号的请求以及
  def accept_token
    signature, timestamp, nonce, echostr, cweb = params[:signature], params[:timestamp], params[:nonce], params[:echostr], params[:cweb]
    tmp_encrypted_str = get_signature(cweb, timestamp, nonce)
    if request.request_method == "POST" && tmp_encrypted_str == signature
      if params[:xml][:MsgType] == "text"   #用户发送文字消息
        content = params[:xml][:Content]
        if content=="试炼"
          @message = "&lt;a href='#{Constant::SERVER_PATH}?open_id=#{params[:xml][:FromUserName]}' &gt;点击试炼&lt;/a&gt;"
          xml = teplate_xml
          render :xml => xml        #关注 自动回复的文字消息
        else
          render :text => "请正确输入！"
        end
      else
        render :text => "ok"
      end
    elsif request.request_method == "GET" && tmp_encrypted_str == signature  #配置服务器token时是get请求
      render :text => tmp_encrypted_str == signature ? echostr :  false
    end
  end



  # 返回结构
  def teplate_xml
    template_xml =
      <<Text
<xml>
  <ToUserName><![CDATA[#{params[:xml][:FromUserName]}]]></ToUserName>
  <FromUserName><![CDATA[#{params[:xml][:ToUserName]}]]></FromUserName>
  <CreateTime>#{Time.now.to_i}</CreateTime>
  <MsgType><![CDATA[text]]></MsgType>
  <Content>#{@message}</Content>
  <FuncFlag>0</FuncFlag>
</xml>
Text
    template_xml
  end

  #验证请求是否从微信发出
  def get_signature(cweb, timestamp, nonce)
    tmp_arr = [cweb, timestamp, nonce]
    tmp_arr.sort!
    tmp_str = tmp_arr.join
    tmp_encrypted_str = Digest::SHA1.hexdigest(tmp_str)
    tmp_encrypted_str
  end
end
