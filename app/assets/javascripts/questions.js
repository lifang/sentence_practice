// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//点选单词
function select_item(obj)
{
    var word = $(obj).text();
    var answer = $(obj).parents(".ex_con").find(".answer_text").val();
    answer = answer + " " + word;
    $(obj).parents(".ex_con").find(".answer_text").val(answer);
    var index = $(obj).index();
    var index_order = $(obj).parents(".ex_con").find(".index_order").val();
    if(index_order == "")
    {
    	$(obj).parents(".ex_con").find(".index_order").val(index);
    }
    else
	{
		$(obj).parents(".ex_con").find(".index_order").val(index_order+","+index);
	}
    $(obj).css("background-color","#eee");
    $(obj).removeAttr("onclick");
    var question_id = $(obj).parents(".ex_con").attr("id");
    $(".btn_box").find(".current_question_id").val(question_id);
    var text_li = "<li>"+ word + "</li>";
    $(obj).parents(".ex_con").find(".answer").find("ul").append(text_li);
    var all_index = $(obj).parents(".ex_con").find(".index_order").val();
    //判断选完当前词语后，词语是否全部填写完毕
    if(all_index != "")
    {
    	alert(all_index);
    	var index_arry = all_index.split(",");
    	var children_length = $(obj).parents("ul").children().last().index();
    }
}

//做题时后退一步
function back_step(obj)
{
	var current_question_id = $(obj).parents(".btn_box").find(".current_question_id").val();
	if(current_question_id != "")
	{
		var index_order = $("#"+current_question_id).find(".index_order").val();
		if(index_order != "")
		{	
			var li_last = $("#"+current_question_id).find(".answer").find("ul").children().last();
			if($(li_last).index() != 0)
			{	
				var last_index = index_order.lastIndexOf(",");
				if(last_index < 0 && index_order != "") 	
				{
					var resume_index = index_order;
					var resume_li = $("#"+current_question_id).find(".chooseArea").find("ul").find("li:eq("+ resume_index +")");
					$(resume_li).attr("onclick","select_item(this)");
					$(resume_li).removeAttr("style");
					$("#"+current_question_id).find(".index_order").val("");
					$("#"+current_question_id).find(".answer_text").val("");
				}
				else if(last_index >= 0)
				{
					var resume_index = index_order.substr(last_index+1);
					var resume_li = $("#"+current_question_id).find(".chooseArea").find("ul").find("li:eq("+ resume_index +")");
					$(resume_li).attr("onclick","select_item(this)");
					$(resume_li).removeAttr("style");
					var index_order = index_order.substring(0,last_index);
					$("#"+current_question_id).find(".index_order").val(index_order);
					var answer_text = $("#"+current_question_id).find(".answer_text");
					var last_place_index = $(answer_text).val().lastIndexOf(" ");
					var answer = $(answer_text).val();
					if(last_place_index > 0 && answer != "")
					{
						answer = answer.substring(0,last_place_index);
						$(answer_text).val(answer);	
					}
					
				}
				$(li_last).remove();
			}
			
		}
	}	
}

