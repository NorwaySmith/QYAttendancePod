//页面返回
var old_back = mui.back;
mui.back = function() {
	//首页推出清理缓存
	if ($("#indexCache").val() == 1) {
		clearCacheData("log_myPublish_data");
		clearCacheData("log_myReceive_data");
	};
	var backUrl = plus.storage.getItem("logBackUrl");
	if (backUrl) {
		window.location.href = backUrl;
	} else {
		old_back();
	}
	return false;
}

mui.plusReady(function() {
	function initParams() {
		window.windowCommon = {
			baseUrl: plus.storage.getItem("baseUrl"),
			basePath: plus.storage.getItem("basePath"),
			photoUrl: plus.storage.getItem("photoUrl"),
			approveLoginId: plus.storage.getItem("approveLoginId"),
			approveLoginName: plus.storage.getItem("approveLoginName"),
			approveLoginGroupId: plus.storage.getItem("approveLoginGroupId"),
		};
	}
	initParams();
	//初始化无网络页面
	initNoNetHTML();
	//监听网络状态变化
	document.addEventListener("netchange", function() {
		if (getNetConnection()) {
			plus.webview.currentWebview().reload();
		} else {
			$(".mui-content").hide();
			$(".noNet").show();
		}
	});
	//	plus.key.addEventListener("backbutton", function(){
	//		mui.back();
	//		return false;
	//	}, false);
});
//初始化无网络页面
function initNoNetHTML() {
	var html = '<div class="noNet" style="width:100%;overflow: hidden;margin-top: 10%;display:none;">';
	html += '<img src="../images/noNetworkBackground@2x.png" alt="" style="display: block;width: 100%;" />';
	html += '</div>';
	$("body").append(html);
}
//判断当前网络状态
function getNetConnection() {
	var type = plus.networkinfo.getCurrentType();
	if (type == plus.networkinfo.CONNECTION_NONE) {
		return false;
	}
	return true;
}
//显示提交等待
function showWaiting(title) {
	plus.nativeUI.showWaiting('',{padding:"10px"});
}
//关闭提交等待
function closeWaiting() {
	plus.nativeUI.closeWaiting();
}
//封装页面传递参数
//pageId 指页面的唯一标识
//mapParam map类型的参数集合
function setPageParam(pageId, mapParam) {
	if (mapParam) {
		plus.storage.setItem(pageId, JSON.stringify(mapParam));
	}
}

//获取页面传递参数,以map的数据格式
//pageId 指页面的唯一标识
function getPageParam(pageId) {
	var param = plus.storage.getItem(pageId);
	var mapParam = new Map();
	if (param) {
		param = JSON.parse(param);
		for (var i = 0; i < param.arr.length; i++) {
			var key = param.arr[i].key;
			var value = param.arr[i].value;
			mapParam.put(key, value);
		}
	}
	return mapParam;
}
//设置返回路径
function setBackUrl(backUrl) {
	plus.storage.setItem("logBackUrl", backUrl);
}
//保存缓存数据
function saveCacheData(item, data) {
	plus.storage.setItem(item, data);
}
//获取缓存数据
function getCacheData(item) {
	return plus.storage.getItem(item);
}
//清理缓存数据
function clearCacheData(item) {
	plus.storage.removeItem(item);
}