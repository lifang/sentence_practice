// JavaScript Document

// 登录页自动轮换内容
$(document).ready(function(){
	var objStr = ".ad ul li";
	$(objStr + ":not(:first)").css("display","none");
	setInterval(function(){
	if( $(objStr + ":last").is(":visible") )
	{
		$(objStr + ":first").fadeIn("slow").addClass("in");
		$(objStr + ":last").fadeOut("slow");
	}
	else{
		$(objStr + ":visible").addClass("in");
		$(objStr + ".in").next().fadeIn("slow");
		$(objStr + ".in").fadeOut("slow").removeClass("in");
	}
	},4000) //每3秒钟切换
})

//article高度
$(function(){
	var ch = document.documentElement.clientHeight;
	var cw = document.documentElement.clientWidth;

    $("article").css("min-height",ch);//最外层	
})