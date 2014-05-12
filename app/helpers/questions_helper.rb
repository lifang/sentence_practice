module QuestionsHelper
	require "base64"
	def load_select_item content
		li = "<li onclick='select_item(this)' style='cursor:pointer;' oncontextmenu='self.event.returnValue=false'
onselectstart='return false'>#{content}</li>"
		li.html_safe
	end

	def load_level_name level
		level = level.to_i
		# LEVEL_NAME = {1 => "入门", 2 => "初级", 3 => "中考", 4 =>"高考", 5 =>"四级", 6 => "六级", 7 => "出国"}
		if level >= 1 && level <=3
			level_name = Question::LEVEL_NAME[1]
		elsif level >= 4 && level <=6
			level_name = Question::LEVEL_NAME[2]
		elsif level >= 7 && level <=9
			level_name = Question::LEVEL_NAME[3]
		elsif level >= 10 && level <=15
			level_name = Question::LEVEL_NAME[4]
		elsif level >= 16 && level <=18
			level_name = Question::LEVEL_NAME[5]
		elsif level >= 19 && level <=24
			level_name = Question::LEVEL_NAME[6]
		elsif level >= 25 && level <=30
			level_name = Question::LEVEL_NAME[7]
		end
		level_name.html_safe	
	end	

	def encode_str str
		str = Base64.encode64(str)
		str
	end

	def decode_str str
		str = Base64.decode64(str)
		str
	end
end
