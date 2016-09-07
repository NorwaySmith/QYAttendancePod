
//页面加载完毕方法
mui.plusReady(function() {
	
	// "选择转交人"的点击事件
	document.getElementById("transferToUser").addEventListener("tap",function(){
		/*document.getElementById("transferToUserName").innerHTML = '李立泼';
		document.getElementById("transferToUserId").value = 29220437;*/
		var param = {
			"userIds": null,
			"toastMsg": '请选择转交人！'
		};
		_taskApi._selectUsers(param, function(response){
			console.log('选择的人员ID：'+response[0].userId+'选择的人员姓名：'+response[0].userName);
			document.getElementById("transferToUserName").innerHTML = '<em class="arrow_right"></em>'+response[0].userName;
			document.getElementById("transferToUserId").value = response[0].userId;
		});
	});
	
	// 转交任务操作
	document.querySelector(".undertaker_button").addEventListener('tap', function() {
		taskTransfer();
	});
	/*document.getElementById("saveTask").addEventListener('tap', function() {
		
	});*/
});


/**
 * 任务转交方法
 */
var taskTransfer= function(){
	plus.nativeUI.showWaiting('等待中...');
	var userId = window.windowCommon.approveLoginId;
	
	var transferReason = document.getElementById("transferReason").value;
	transferReason = $.trim(transferReason);
	if(!verifyEmpty(transferReason)){
		mui.toast('请输入转交原因!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if(transferReason.length>500){
		mui.toast('内容不能大于500个字!');
		plus.nativeUI.closeWaiting();
		return;
	}
	var transferToUserId = document.getElementById("transferToUserId").value;
	if(!verifyEmpty(transferToUserId)){
		mui.toast('请选择转交人!');
		plus.nativeUI.closeWaiting();
		return;
	}
	var param = {
		"_clientType": "wap",
		"reason": transferReason,
		"transferToUserId":transferToUserId,
		"taskId": plus.storage.getItem("taskId"),
		"userId": userId
	};

	_taskApi._taskTransfer(param, function(response){

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