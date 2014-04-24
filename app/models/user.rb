#encoding: utf-8
class User < ActiveRecord::Base
	attr_protected :authentications
	has_many :share_records, :dependent => :destroy
	has_many :answer_details, :dependent => :destroy
	FIRST_REWORD_GOLD = 20
	INIT_COMPLETE_PER_CENT = 0
	INIT_LEVEL = 0
end
