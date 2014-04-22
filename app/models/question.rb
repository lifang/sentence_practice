class Question < ActiveRecord::Base
	attr_protected :authentications
	has_many :answer_details, :dependent => :destroy
end
