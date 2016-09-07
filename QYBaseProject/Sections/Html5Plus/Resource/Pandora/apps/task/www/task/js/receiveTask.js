mui.plusReady(function() {
   var reason=plus.storage.getItem("zhuanjiao");
   if(reason!=null){
   	   $("#reason").html(reason);
   }else{
   	    $("#reason").hide();
   }
	//设置当前页面，调用返回按钮，返回列表
	plus.storage.setItem("taskBackUrl","tabList.html");
	console.log(plus.storage.getItem("taskBackUrl"))

	$("#toTaskDecompose").click(function(){
		window.location.href="taskDecompose.html";
	});
	$("#toList").click(function(){
		window.location.href="tabList.html";
	});
	var creatName=plus.storage.getItem("creatName");
	console.log(creatName);
	$("#formTask").html("你已领取了“"+creatName+"”发布的任务");
	$("#reason").click(function(){
		window.location.href="TaskDetail.html";
	});
		
});
    