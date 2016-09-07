mui.plusReady(function(){
	var baseUrl=window.plus.qytxplugin.getBaseUrlPath("h5baseUrl","workflowUrl");
	/** 测试 环境*/
//	var basePath="http://218.206.244.202:38080/txzlbmc/";
//	var photoUrl="http://218.206.244.202:38080/ydzjMobile/headPictureView.action?_clientType=wap&filePath=";
	/**正式环境*/
//  var baseUrl="http://101.200.31.143/";
	var basePath=baseUrl+"zq-kxh/";
	
	plus.storage.setItem("basePath",basePath);
	plus.storage.setItem("baseUrl",baseUrl);
});
