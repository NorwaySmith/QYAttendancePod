mui.plusReady(function(){
	//页面返回
	var old_back = mui.back;
	mui.back=function(){
		//首页推出清理缓存
		if($("#indexCache").val()==1){
			clearCacheData("flow_index_data");
			clearCacheData("flow_myStart_data");
			clearCacheData("flow_myWait_data");
			clearCacheData("flow_myProcessed_data");
		};
		//如果有人员弹出层
        
		if($("#userList:visible").length>0){
            setTimeout(function(){
                mui("#userList").popover("toggle");
            },300);
			$("#userList ul").undelegate("li a","tap");
            return false;
		};
		//如果有单选弹出层
		if($(".radioDiv:visible").length>0){
            $(".radioDiv:visible").each(function(){
                var id=$(this).attr("id");
                mui("#"+id).popover("toggle");
            });
            $("body").undelegate("div.radioDiv ul li","tap");
            return false;
		};
		//如果有复选弹出层
		if($(".chkDiv:visible").length>0){
            $(".chkDiv:visible").each(function(){
                var id=$(this).attr("id");
                mui("#"+id).popover("toggle");
            });
			$("body").undelegate("div.chkDiv ul li","tap");
            return false;
		};
		var backUrl=plus.storage.getItem("flowBackUrl");
		//图片预览返回使用
//		console.log("$$"+$("#__MUI_PREVIEWIMAGE").html()+"&&");
//		if($("#__MUI_PREVIEWIMAGE span.mui-preview-indicator").html()){
//			backUrl="";
//		}
		if(backUrl){
			if(plus.storage.getItem("flowType")==2){
				backUrl='../fixedflow/'+backUrl;
			}
			window.location.href=backUrl;
		}else{
			old_back();
		};
		return false;
	}
	function initParams(){
		window.windowCommon={
			baseUrl:plus.storage.getItem("baseUrl"),
			basePath:plus.storage.getItem("basePath"),
			photoUrl:plus.storage.getItem("photoUrl"),
			approveLoginId:plus.storage.getItem("approveLoginId"),
			approveLoginName:plus.storage.getItem("approveLoginName"),
			approveLoginGroupId:plus.storage.getItem("approveLoginGroupId"),
			fileUploadPath:plus.storage.getItem("fileUploadPath"),
			fileDownPath:plus.storage.getItem("fileDownPath"),
		};
	};
	initParams();
	//初始化无网络页面
	initNoNetHTML();
	//监听网络状态变化
	document.addEventListener("netchange",function(){
		if(getNetConnection()){
			plus.webview.currentWebview().reload();
		}else{
			$(".mui-content").hide();
			$(".noNet").show();
		}
	});
});
function initNoNetHTML(){
	var html='<div class="noNet" style="width:100%;overflow: hidden;margin-top: 10%;display:none;">';
	html+='<img src="../../images/noNetworkBackground@2x.png" alt="" style="display: block;width: 100%;" />';		
	html+='</div>';
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
function showWaiting(title){
	plus.nativeUI.showWaiting('',{padding:"10px"});
}
//关闭提交等待
function closeWaiting(){
	plus.nativeUI.closeWaiting();
}
//封装页面传递参数
//pageId 指页面的唯一标识
//mapParam map类型的参数集合
function setPageParam(pageId,mapParam){
	if(mapParam){
		plus.storage.setItem(pageId,JSON.stringify(mapParam));
	}
}

//获取页面传递参数,以map的数据格式
//pageId 指页面的唯一标识
function getPageParam(pageId){
	var param=plus.storage.getItem(pageId);
	var mapParam=new Map();
	if(param){
		param=JSON.parse(param);
		for(var i=0;i<param.arr.length;i++){
			var key=param.arr[i].key;
			var value=param.arr[i].value;
			mapParam.put(key,value);
		}
	}
	return mapParam;
}
//设置返回路径
function setBackUrl(backUrl){
	plus.storage.setItem("flowBackUrl",backUrl);
}
//保存缓存数据
function saveCacheData(item,data){
	plus.storage.setItem(item+window.windowCommon.approveLoginId,data);
}
//获取缓存数据
function getCacheData(item){
	return plus.storage.getItem(item+window.windowCommon.approveLoginId);
}
//清理缓存数据
function clearCacheData(item){
	plus.storage.setItem(item+window.windowCommon.approveLoginId,"");
	plus.storage.removeItem(item+window.windowCommon.approveLoginId);
}
//关闭手机上的小键盘
function closeKeyborad() {
	if (plus.os.name == 'iOS') {
		plus.qytxplugin.closeKeyboard();
	} else {
		
	}
}

