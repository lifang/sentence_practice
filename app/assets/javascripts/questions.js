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
    $(obj).css("color","#ccc");
    $(obj).removeAttr("onclick");
    var question_id = $(obj).parents(".ex_con").attr("id");
    $(".btn_box").find(".current_question_id").val(question_id);
    var text_li = "<li>"+ word + "</li>&nbsp;";
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
	var question_div = $(obj).parent().prev().find(".ex_con");
	var index_order = $(question_div).find(".index_order").val();
	if(index_order != "")
	{	
		var li_last = $(question_div).find(".answer").find("ul").children().last();
		if($(li_last).index() != 0)
		{	
			var last_index = index_order.lastIndexOf(",");
			if(last_index < 0 && index_order != "") 	
			{
				var resume_index = index_order;
				var resume_li = $(question_div).find(".chooseArea").find("ul").find("li:eq("+ resume_index +")");
				$(resume_li).attr("onclick","select_item(this)");
				$(resume_li).removeAttr("style");
				$(question_div).find(".index_order").val("");
				$(question_div).find(".answer_text").val("");
			}
			else if(last_index >= 0)
			{
				var resume_index = index_order.substr(last_index+1);
				var resume_li = $(question_div).find(".chooseArea").find("ul").find("li:eq("+ resume_index +")");
				$(resume_li).attr("onclick","select_item(this)");
				$(resume_li).removeAttr("style");
				$(resume_li).css("cursor","pointer");
				var index_order = index_order.substring(0,last_index);
				$(question_div).find(".index_order").val(index_order);
				var answer_text = $(question_div).find(".answer_text");
				var last_place_index = $(answer_text).val().lastIndexOf(" ");
				var answer = $(answer_text).val();
				if(last_place_index > 0 && answer != "")
				{
					answer = answer.substring(0,last_place_index);
					$(answer_text).val(answer);	
				}
				
			}
			$(li_last).remove();
			var index_order = $(question_div).find(".index_order").val();
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
				var children_length = $(question_div).find(".word_number").val();
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

//检查答案
function check_answer(obj)
{
	var step = $(".btn_box").find(".step").val();
	var question_id = $(obj).parent().prev().find(".question_id").val();
	var correct_answer = $(obj).parent().prev().find(".correct_answer").val();
	var answer = $(obj).parent().prev().find(".answer_text").val();
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
	        question_id : question_id,
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
	        question_id : question_id,
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
	// $("#panel").empty();
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
	// var div_obj = $(div_id);
	// $("#panel").append(div_obj);
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
		var question_id = $(".question_id").val();
		var step = $(".step").val();
		$.ajax({
	      async:true,
	      type: "GET",
	      url: "/questions/get_next_question",
	      dataType: "script",
	      data : {
	      	step : step,
	        question_id : question_id,
	      },
	      success: function(data){
	      }
	    });

	}
	$(obj).parents(".tab").empty();
	$(obj).parents(".tab").hide();
	$("#panel").hide();
	$("#result").hide();
}

//倒计时
function startTime()
{
	var time = $(".time").val();
	time = parseInt(time);
	var unlock_level_display =  $("#unlock_level").css("display");
	if(unlock_level_display == "none")
	{
		if(time > 0)
		{
			time = time - 1;
			$(".time").val(time);
			var per_cent = (time/60.0)*100;
			// $(".timer").find("p").text("剩余"+time+"秒");
			$(".timer").find("p").css("width", per_cent+"%");
			$(".num").text(time);
		}	
		else
		{
			$(".tab").hide();
			popup("#time_limit");
		}
	}	
}

function view_score(obj)
{
	var correct_counts = $(".correct_counts").val();
	$.ajax({
	      async:true,
	      type: "POST",
	      url: "/users/calculate_score",
	      dataType: "script",
	      data : {
	      	correct_counts : correct_counts
	      },
	      success: function(data){
	      }
    });
}

function unlock_next_level(obj)
{
	var correct_counts = $(".correct_counts").val();
	$.ajax({
	      async:true,
	      type: "POST",
	      url: "/users/unlock_next_level",
	      dataType: "script",
	      data : {
	     	correct_counts : correct_counts	
	      },
	      success: function(data){
	      }
    });		
}
