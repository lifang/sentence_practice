// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//点选单词
function select_item(obj)
{
	$("#back_step_btn").attr("onclick","back_step(this)");
	$("#back_step_btn").removeClass("gray_btn")
	$("#back_step_btn").addClass("orange_btn");
    var word = $(obj).text();
    $(obj).css("cursor","default");
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
    	// alert(all_index);
    	var all_index = all_index.split(",");
    	var select_item_length = all_index.length;
    	var children_length = $(obj).parents(".ex_con").find(".word_number").val();
    	if(select_item_length == children_length)
    	{
    		$("#finish_btn").removeClass("gray_btn");
    		$("#finish_btn").addClass("orange_btn");
    		$("#finish_btn").attr("onclick","check_answer(this)");
    	}	
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
					$(resume_li).css("cursor","pointer");
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
				var index_order = $("#"+current_question_id).find(".index_order").val();
				if(index_order == "")
				{
					$("#back_step_btn").removeAttr("onclick");
					$("#back_step_btn").removeClass("orange_btn");
					$("#back_step_btn").addClass("gray_btn");
				}
				else
				{
					var index_arr = index_order.split(",");
					var index_arr_length = index_arr.length;
					var children_length = $("#"+current_question_id).find(".word_number").val();
					if(index_arr_length < children_length)
					{
						$("#finish_btn").removeClass("orange_btn");
    					$("#finish_btn").addClass("gray_btn");
    					$("#finish_btn").removeAttr("onclick");	
					}
				}	
			}
			
		}
	}	
}

//检查答案
function check_answer(obj)
{

	var last_question_id_str = $(".btn_box").find(".last_question_id").val();
	var step = $(".btn_box").find(".step").val();
	var current_question_id = $(obj).parents(".btn_box").find(".current_question_id").val();
	var correct_answer = $("#"+current_question_id).find(".correct_answer").val();
	var answer = $("#"+current_question_id).find(".answer_text").val();
	correct_answer = correct_answer.replace(/\s/g,"");
	answer = answer.replace(/\s/g,"");
	$("#finish_btn").removeClass("orange_btn");
	$("#finish_btn").addClass("gray_btn");
	$("#finish_btn").removeAttr("onclick");
	$("#back_step_btn").removeClass("orange_btn");
	$("#back_step_btn").addClass("gray_btn");
	$("#back_step_btn").removeAttr("onclick");
	if(answer == correct_answer)
	{
		$.ajax({
	      async:true,
	      type: "POST",
	      url: "/questions/check_answer",
	      dataType: "script",
	      data : {
	      	step : step,
	      	last_question_id_str : last_question_id_str,
	        question_id_str : current_question_id,
	        question_result : "true"
	      },
	      success: function(data){
	      }
	    });
	}
	else
	{
		$.ajax({
	      async:true,
	      type: "POST",
	      url: "/questions/check_answer",
	      dataType: "script",
	      data : {
	      	step : step,
	      	last_question_id_str : last_question_id_str,
	        question_id_str : current_question_id,
	        question_result : "false"
	      },
	      success: function(data){
	      }
	    });
	}
}

//
function popup(div_id)
{

	var windows_height = $(window).height();
	var windows_width = $(window).width();
	$("#panel").height(windows_height);
	$("#panel").width(windows_width);
	var div_height = $(div_id).height();
	var div_width = $(div_id).width();
	var top = (windows_height - div_height)/2;
	var left = (windows_width - div_width)/2;	
	$(div_id).css("top", top);
	$(div_id).css("left", left);
	$(div_id).css("z-index", 100);
	$(div_id).show();
	var div_obj = $(div_id);
	$("#panel").append(div_obj);
	$("#panel").show();
}

function continue_question(obj)
{
	var correct = $(obj).parents(".tab").find(".status").val();
	var correct_counts = $(".correct_counts").val();
	if(correct_counts == "" && correct == 1)
	{
		$(".correct_counts").val(correct);
	}
	else
	{
		correct_counts = parseInt(correct_counts) + parseInt(correct);
		$(".correct_counts").val(correct_counts);
		// alert(correct_counts);
	}
	if(correct == 1 || correct == 0)
	{
		var current_question_id = $(".current_question_id").val();
		// alert(current_question_id);
		$("[id='"+current_question_id+"']").hide();
		$("[id='"+current_question_id+"']").next().show();
		$("[id='"+current_question_id+"']").remove();
	}
	$(obj).parents(".tab").empty();
	$(obj).parents(".tab").hide();
	$("#result").hide();
}