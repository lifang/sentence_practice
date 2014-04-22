class User < ActiveRecord::Base
	attr_protected :authentications
	has_many :share_records, :dependent => :destroy
	has_many :answer_details, :dependent => :destroy
end
