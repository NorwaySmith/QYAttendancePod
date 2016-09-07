
//页面加载完毕方法
mui.plusReady(function() {

	document.querySelector(".undertaker_button").addEventListener('tap', function() {
		unComplete();
	});
});


/**
 * 任务未完成方法
 */
var unComplete= function(){
	plus.nativeUI.showWaiting('等待中...');
	
	var unCompleteReason = document.getElementById("unCompleteReason").value;
	unCompleteReason = $.trim(unCompleteReason);
	if(!verifyEmpty(unCompleteReason)){
		mui.toast('请输入未完成原因!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if(unCompleteReason.length>500){
		mui.toast('内容不能大于500个字!');
		plus.nativeUI.closeWaiting();
		return;
	}
	
 	var param = {
			"_clientType": "wap",
			"userId": window.windowCommon.approveLoginId,
			"scheduleId":plus.storage.getItem("scheduleId"),
			"status":2,
			"undoneReason":unCompleteReason
		};
	_scheduleApi._updateScheduleStatus(param,function(data){
		plus.nativeUI.closeWaiting();
		if(data==1){
			mui.toast("操作成功");
			plus.storage.removeItem("scheduleId");
			//不使用缓存
			setCacheEnd();
			window.location.href='scheduleList.html';
		}else{
			mui.toast("操作失败");
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