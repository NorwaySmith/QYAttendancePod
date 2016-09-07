mui.plusReady(function(){
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
