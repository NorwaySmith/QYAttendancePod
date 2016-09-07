mui.plusReady(function(){
	//页面返回
	var old_back = mui.back;
	mui.back=function(){
		console.log('返回...')
		//首页退出清理缓存
		if($("#indexCache").val()==1){
			plus.storage.removeItem("scheduleBackUrl");
			plus.storage.removeItem("scheduleId");
			plus.storage.removeItem("scheduleListCache");
			plus.storage.removeItem("basePath");
			plus.storage.removeItem("photoUrl");
			plus.storage.removeItem("approveLoginId");
			plus.storage.removeItem("approveLoginName");
			plus.storage.removeItem("approveLoginGroupId");
			
			if(plus.os.name=='iOS'){
				//调用手机端IOSd的关闭方法
				plus.qytxplugin.goBackDesk();
			}else{
				plus.runtime.quit();
			}
			return false;
		};
		
		var backUrl=plus.storage.getItem("scheduleBackUrl");
		console.log(backUrl)
		if(backUrl){
			plus.storage.removeItem("scheduleBackUrl");
			window.location.href=backUrl;
		}else{
			old_back();
		};
		return false;
	}
	
	function initParams(){
		window.windowCommon={
			basePath:plus.storage.getItem("basePath"),
			photoUrl:plus.storage.getItem("photoUrl"),
			approveLoginId:plus.storage.getItem("approveLoginId"),
			approveLoginName:plus.storage.getItem("approveLoginName"),
			approveLoginGroupId:plus.storage.getItem("approveLoginGroupId"),
		};
	}
	initParams();
	
});
//重新启用pullUp事件
function _enablePullUp(){
	$(".listNoData").hide();
	mui('#pullrefresh').pullRefresh().enablePullupToRefresh();
}


/**
 * 关闭scheduleList页面缓存
 */
function setCacheEnd() {
	var scheduleListCache = plus.storage.getItem("scheduleListCache");
	if (scheduleListCache) {
		var cacheAry = JSON.parse(scheduleListCache);
		cacheAry[0] = false;
		plus.storage.setItem("scheduleListCache",JSON.stringify(cacheAry));
	}
}