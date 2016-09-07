var scheduleId;
mui.plusReady(function() {
	
	scheduleId = plus.storage.getItem("scheduleId");
	if(scheduleId){
		plus.storage.removeItem("scheduleId");
		$("#content").val(plus.storage.getItem("content"));
		$("#Time").html(plus.storage.getItem("completeTime"));
	}
	
	$("#finshTime").click(function(){
		var param = {
			    "timeL": null
		    };
		_scheduleApi._selectDateTime(param, function(response){
			bTime = response.date;
			$("#Time").html(bTime.split(" ")[0]);
		});
		//$("#Time").html("2016-06-03");
	});
	/**
	 * 增加任务
	 */
	document.getElementById("saveSchedule").addEventListener('tap', function() {
		saveSchedule();
	});
});

   var saveSchedule=function(){
   	    plus.nativeUI.showWaiting('等待中...');
   	    console.log(123);
   	    var userId=window.windowCommon.approveLoginId;
   	    console.log(userId);
   	    var content=$("#content").val().trim();
   	    console.log(content);
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
   	   var time=$("#Time").html();
	   if(!verifyEmpty(time,'请选择')){
		 	mui.toast('请选择完成日期!');
			plus.nativeUI.closeWaiting();
			return;
	   }
	   var param = {
		"_clientType": "wap",
		"content": content,
		"completeTime":time+' 00:00:00',
		"createUserId": userId
	   };
		if(scheduleId){
			param.id=scheduleId;
		}
	   console.log(JSON.stringify(param))
	   _scheduleApi._addSchedule(param,function(response){
	   	
	   	    plus.nativeUI.closeWaiting();
	   	    
	   	    if(response.num==1){
    		   mui.toast('保存失败！');
    	    }else{
    	    	//不使用缓存
				setCacheEnd();
    			mui.toast('保存成功！');
    			window.location.href='scheduleList.html';
    	    }
	   });
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