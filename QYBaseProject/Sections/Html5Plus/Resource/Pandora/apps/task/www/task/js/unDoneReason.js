
//页面加载完毕方法
mui.plusReady(function() {

	// 转交任务操作
	document.querySelector(".undertaker_button").addEventListener('tap', function() {
		taskUnComplete();
	});
});


/**
 * 任务未完成方法
 */
var taskUnComplete= function(){
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
	var param={
		"_clientType": "wap",
 		"taskId":plus.storage.getItem("taskId"), 
 		"userId":window.windowCommon.approveLoginId,
 		"reason":unCompleteReason
 	};

	_taskApi._taskUnComplete(param, function(response){

		if(response.code == 0){
			mui.toast('保存失败！');
		}else{
			mui.toast('保存成功！');
			//设置不使用tabList页面缓存
    		setCacheEnd();
			plus.nativeUI.closeWaiting();
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