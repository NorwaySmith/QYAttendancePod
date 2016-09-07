mui.plusReady(function() {
	$("#finshDate").on("tap","#date",function(){
                       plus.qytxplugin.closeKeyboard();
                       
		//$("#date").html("2016-05-30 00:00:00");
		var param = {
			"timeL": null
		};
		_taskApi._selectDateTime(param, function(response){
			bTime = response.date;
			$("#date").html(bTime.split(" ")[0]);
		});
	});
	
	$("#person").on("tap","#name",function(){
                    plus.qytxplugin.closeKeyboard();
                    
		var param = {
			"userIds": '',
			"toastMsg": '请选择承办人！'
		};
		_taskApi._selectUsers(param, function(response){
			$("#name").html(response[0].userName);
			$("#personId").val(response[0].userId);
		});
	});
	/**
	 * 增加任务
	 */
	document.getElementById("saveTask").addEventListener('tap', function() {
		addTask();
	});
	
    
});
   
   var addTask= function(){
     plus.nativeUI.showWaiting('等待中...');
   	 var userId=window.windowCommon.approveLoginId;
	 var content=$("#content").val().trim();
	 if(!verifyEmpty(content)){
	 	mui.toast('请输入任务内容!');
		plus.nativeUI.closeWaiting();
		return;
	 }
	 if(content.length>500){
	 	mui.toast('内容不能大于500个字!');
		plus.nativeUI.closeWaiting();
		return;
	 }
	 var time=$("#date").html();
	 if(!verifyEmpty(time,'请选择')){
	 	mui.toast('请选择完成日期!');
		plus.nativeUI.closeWaiting();
		return;
	 }
	 var personId=$("#personId").val();
	 if(!verifyEmpty(personId,0)){
	 	mui.toast('请选择承办人员!');
		plus.nativeUI.closeWaiting();
		return;
	 }
	 var param = {
		"_clientType": "wap",
		"taskContent": content,
		"completeTime":time+' 00:00:00',
		"undertaker": personId,
		"createUserId": userId,
	};
    _taskApi._addTask(param,function(response){
    	plus.nativeUI.closeWaiting();
    	if(response.num==1){
    		mui.toast('保存失败！');
    	}else{
    		mui.toast('保存成功！');
    		//设置不使用tabList页面缓存
    		setCacheEnd();
    		//跳转到我发起的页面
    		plus.storage.setItem("type",'2');
    		window.location.href='tabList.html';
    	}
    })
	 
   }
   /**
	 * 验证空值
	 * @param {Object} val
	 * @param {Object} defval
	 */
	var verifyEmpty = function(val, defval) {
		if (val == null || val == undefined) {
			return false;
		}
		if (defval == null || defval == undefined) {
			if (val == '') {
				return false;
			}
		} else {
			if (val == defval) {
				return false;
			}
		}
		return true;
	}