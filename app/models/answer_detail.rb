class AnswerDetail < ActiveRecord::Base
	attr_protected :authentications
	belongs_to :user
	belongs_to :question
	STATUS = {:UNFINISH => 0, :FINISH => 1}
	STATUS_NAME = {0=>'未完成', 1=>'已完成'}
end
