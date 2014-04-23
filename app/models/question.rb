#encoding: utf-8
class Question < ActiveRecord::Base
	attr_protected :authentications
	has_many :answer_details, :dependent => :destroy
	LEVEL_TYPE = {:START => 0, :PRIMARY => 1, :EXAMINATION => 2, :ENTRANCE => 3, :FOUR => 4, :SIX => 5, :ABROAD => 6}
	               #0 入门     1 初级    2 中考    3 高考    4 四级    5 六级    6  出国
	LEVEL_NAME = {0 => "入门", 1 => "初级", 2 => "中考", 3 =>"高考", 4 =>"四级", 5 => "六级", 6 => "出国"}              
end
