mui.plusReady(function(){
		setBackUrl("");
		//页面滚动
		mui('.mui-scroll-wrapper').scroll();
		var userId=window.windowCommon.approveLoginId;
		//获取操作页面参数
		var mapParam=getPageParam("flow_operate");
		var instanceId=mapParam.get("instanceId");
		var type=mapParam.get("type");
		var turn=mapParam.get("turn");
		if(type==2){//撤销
			$("#title").html("撤销");
			$("#state").hide();
			$("#advice").attr("placeholder","请输入撤销原因");
		}else if(type==1){//拒绝
			$("#title").html("审批");
			$("#state").html("拒绝");
			$("#advice").attr("placeholder","请输入批复内容（非必填）");
		}else if(type==0){//同意
			$("#title").html("审批");
			$("#state").html("同意");
			$("#advice").attr("placeholder","请输入批复内容（非必填）");
		}else if(type==3){//转交
			var userName = eval('('+turn+')').userName;
			$("#title").html("审批");
			$("#state").html("转交给:"+userName);
			$("#advice").attr("placeholder","请输入批复内容（非必填）");
		}
		
		//点击提交按钮
		$("#operSubmit").click(function(){
			$("#operSubmit").attr("disabled",true);
			var advice = $("#advice").val();
			var userId=window.windowCommon.approveLoginId;
			if(type==2){//撤销
				discharge(instanceId, userId, advice);
			}else if(type==1){//拒绝
				noAgree(instanceId, userId, advice);
			}else if(type==0){//同意
				agree(instanceId, userId, advice);
			}else if(type==3){//转交
				var turner=eval('('+turn+')');
				turnTo(instanceId, userId, advice,turner);
			}
		});
});
//撤销
function discharge(instanceId, userId, advice) {
	if (advice != null && advice != "" && advice.length > 300) {
		mui.toast("撤销原因字数不超过300");
		$("#operSubmit").attr("disabled", false);
		return false;
	}
	$.ajax({
		url: window.windowCommon.basePath + "baseworkflow/approve.c?_clientType=wap",
		type: "post",
		data: {
			"instanceId": instanceId,
			"approveResult": "2",
			"userId": userId,
			"advice": advice
		},
		success: function(msg) {
			if(msg.indexOf("100||")==0){
		    	mui.toast("提交成功");
		    	clearCacheData("flow_myStart_data");
		    	//打开我的申请页面 
		    	window.location.href="../fixedflow/myStartList.html";
		     }else{
		     	 mui.toast("提交失败");
		    	 $("#operSubmit").attr("disabled",false);
		     }
		}
	});
}
//拒绝
function noAgree(instanceId, userId, advice) {
	if (advice != null && advice != "" && advice.length >= 500) {
		mui.toast("批复内容应小于500个字");
		$("#operSubmit").attr("disabled", false);
		return false;
	}
	$.ajax({
		type: "post",
		url: window.windowCommon.basePath + "baseworkflow/approve.c",
		data: {
			"instanceId": instanceId,
			"approveResult": "1",
			"userId": userId,
			"advice": advice
		},
		success: function(msg) {
			if(msg.indexOf("100||")==0){
		    	mui.toast("提交成功");
		    	//清理申请列表缓存数据
            	clearCacheData("flow_myWait_data");
            	clearCacheData("flow_myProcessed_data");
		    	//跳转到我的申请页面
				window.location.href="../fixedflow/myApproveListLeft.html";
		     }else{
		     	 mui.toast("提交失败");
		    	 $("#operSubmit").attr("disabled",false);
		     }
		}
	});
}
//同意
function agree(instanceId, userId, advice) {
	if (advice != null && advice != "" && advice.length >= 500) {
		mui.toast("批复内容应小于500个字");
		$("#operSubmit").attr("disabled", false);
		return false;
	}
	$.ajax({
		type: "post",
		url: window.windowCommon.basePath + "baseworkflow/approve.c",
		data: {
			"instanceId": instanceId,
			"approveResult": "0",
			"userId": userId,
			"advice": advice
		},
		success: function(msg) {
			if(msg.indexOf("100||")==0){
		    	mui.toast("提交成功");
				//清理申请列表缓存数据
            	clearCacheData("flow_myWait_data");
            	clearCacheData("flow_myProcessed_data");
		    	//跳转到我的申请页面
				window.location.href="../fixedflow/myApproveListLeft.html";
		     }else{
		     	 mui.toast("提交失败");
		    	 $("#operSubmit").attr("disabled",false);
		     }
		}
	});
}
//转交
function turnTo(instanceId, userId, advice,turner) {
	var userName = turner.userName;
	var photoUrl = turner.userPhoto;
	var ss = {
		userId: turner.userId,
		userName: userName,
		photoUrl: photoUrl
	};
	var sr = JSON.stringify(ss);
	if (advice != null && advice != "" && advice.length >= 500) {
		mui.toast("批复内容应小于500个字");
		$("#operSubmit").attr("disabled", false);
		return false;
	}
	$.ajax({
		type: "post",
		url: window.windowCommon.basePath + "baseworkflow/turn.c",
		data: {
			"instanceId": instanceId,
			"turner": sr,
			"userId": userId,
			"advice": advice
		},
		success: function(msg) {
			if(msg.indexOf("100||")==0){
		    	mui.toast("提交成功");
				//清理申请列表缓存数据
            	clearCacheData("flow_myWait_data");
            	clearCacheData("flow_myProcessed_data");
		    	//跳转到我的申请页面
				window.location.href="../fixedflow/myApproveListLeft.html";
		     }else{
		     	 mui.toast("提交失败");
		    	 $("#operSubmit").attr("disabled",false);
		     }
		}
	});
}