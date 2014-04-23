#encoding: utf-8
class ShareRecord < ActiveRecord::Base
	attr_protected :authentications
	belongs_to :user
	STATUS = {:UNFINISH => 0, :FINISH => 1}
	STATUS_NAME = {0=>'未奖励', 1=>'已奖励'}

end
