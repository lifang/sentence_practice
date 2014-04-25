module QuestionsHelper
	def load_select_item content
		li = "<li onclick='select_item(this)' style='cursor:pointer;' oncontextmenu='self.event.returnValue=false'
onselectstart='return false'>#{content}</li>"
		li.html_safe
	end
end
