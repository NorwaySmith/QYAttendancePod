mui.plusReady(function(){
		//页面滚动
		mui('.mui-scroll-wrapper').scroll();
		var userId=window.windowCommon.approveLoginId;
		//获取详情页面参数
		var mapParam=getPageParam("flow_detail");
		var instanceId=mapParam.get("instanceId");
		var operation=mapParam.get("operation");
		if(operation=="view"){
			$("#viewOper").show();
			$("#approveOper").hide();
		}else if(operation=="approving"){
			$("#viewOper").hide();
			$("#approveOper").show();
		}else{
			$("#viewOper").hide();
			$("#approveOper").hide();
		}
		//撤销
		$("#dischargeBut").click(function(){
			//设置页面参数
			var mapParam=new Map();
			mapParam.put("instanceId",instanceId);
			mapParam.put("type",2);
			setPageParam("flow_operate",mapParam);
			window.location.href="operate.html";
		});
		//不同意
		$("#noagree").click(function(){
			//设置页面参数
			var mapParam=new Map();
			mapParam.put("instanceId",instanceId);
			mapParam.put("type",1);
			setPageParam("flow_operate",mapParam);
			window.location.href="operate.html";
		});
		//同意
		$("#agree").click(function(){
			//设置页面参数
			var mapParam=new Map();
			mapParam.put("instanceId",instanceId);
			mapParam.put("type",0);
			setPageParam("flow_operate",mapParam);
			window.location.href="operate.html";
		});
		
		//转交
		$("#turn").click(function() {
			//单选人员
			plus.qytxplugin.selectUsers("", 1, function(data) {
				if (data) {
					checkTurner(instanceId,data);
				}
			});
					
//			var data = [{
//				"userId": "29223213",
//				"userName": "任鹏辉"
//			}];
//			checkTurner(instanceId, data);
		});
});
//转交人验证
function checkTurner(instanceId,data) {
	var suid = data[0].userId;
	$.ajax({
		type: "post",
		url: window.windowCommon.basePath + "baseworkflow/checkTurnerIsRepeat.c",
		data: {
			"instanceId": instanceId,
			"turnUserId": suid
		},
		success: function(msg) {
			if (msg.indexOf("100||") == 0) {
				msg = msg.substring(5);
				msg = eval('(' + msg + ')');
				if (msg.result == true) { //重复
					mui.toast("该审批人已在列表中");
				} else {
					var turn = JSON.stringify(data[0]);
					//设置页面参数
					var mapParam=new Map();
					mapParam.put("instanceId",instanceId);
					mapParam.put("type",3);
					mapParam.put("turn",turn);
					setPageParam("flow_operate",mapParam);
					window.location.href="operate.html";
				}
			}
		}
	});
}
