mui.plusReady(function(){
	//获取页面参数
	var mapParam=getPageParam("flow_detail");
	var instanceId=mapParam.get("instanceId");
	var title=mapParam.get("title");
	var operation=mapParam.get("operation");
	showWaiting("加载中，请等待...");
	$.ajax({
		url:window.windowCommon.basePath+"baseworkflow/view.c?instanceId="+instanceId,
		type:"POST",
		cache:true,
		success:function(msg){
			if(msg.indexOf("100||")==0){
				var result = msg.substring(5);
				showDataWithHTML(result,operation);
				closeWaiting();
			}
		}
	});
});

function showDataWithHTML(result,operation){
	 result = jQuery.parseJSON(result);
	   //发起人的姓名和头像
	   var 	createrName = result.createrName;
	   var  createrPhoto = result.createrPhoto;
	     var imgName=createrName;
		 if(createrName!=null&&createrName.length>2){
		 	imgName=createrName.substring(createrName.length-2,createrName.length);
		 }
		  var col=letterCode(imgName);
		 $("#imgName").html(imgName);
		 $("#imgDiv").addClass("head-bg-"+col);
		 if(createrPhoto!=null&&createrPhoto!=""&&createrPhoto!=undefined){
			 $("#photo").attr("src",createrPhoto);
			 $("#imgName").hide();
		 }else{
			 $("#photo").hide();
		 }
	   $("#userName").html(createrName);
	   //表单解析
	   var formData = jQuery.parseJSON(result.formData);
	   //用处
	   var useful = formData.useful;
	   $("#useful").html(useful); 
	   //备注
	   var remark = formData.remark;
	   $("#remark").html(remark);
	   //图片
//	   processPhoto(formData.imgs);
	   //审批历史
	   processUserInfos(result.history,result.totalState,result.approverId,operation);
}