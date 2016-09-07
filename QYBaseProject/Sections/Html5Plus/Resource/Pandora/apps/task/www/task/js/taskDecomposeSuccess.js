mui.plusReady(function(){
	
	//查看日程
	mui("#goSchedule")[0].addEventListener('tap', function() {
		window.location.href = 'file:///android_asset/apps/cbb-schedule/schedule/html/scheduleList.html';
	});
	
	//返回任务列表
	mui("#goBack")[0].addEventListener('tap', function() {
		window.location.href = 'tabList.html';
	});
});

