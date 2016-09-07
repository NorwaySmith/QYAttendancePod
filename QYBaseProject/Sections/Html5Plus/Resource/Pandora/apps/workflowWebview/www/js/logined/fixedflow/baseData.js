mui.plusReady(function(){
	var baseUrl=window.plus.qytxplugin.getBaseUrlPath("h5baseUrl","workflowUrl");
//	var baseUrl="http://218.206.244.202:38080/";
	var basePath=baseUrl+"txzlbmc/";
	var photoUrl=baseUrl+"ydzjMobile/headPictureView.action?_clientType=wap&filePath=";
	//文件上传路径
	var fileUploadPath=baseUrl+"fileServer/upload";
	//文件下载路径
    var fileDownPath=baseUrl+"fileServer/download";
	var approveLoginId="";
	var approveLoginName="王红军";
//	var approveLoginName="洪亚勤";
//	var approveLoginName="任鹏辉";
	var approveLoginGroupId="";   
	approveLoginId="29115650";
//    approveLoginId="10987506";
//	approveLoginId="11061125";  
//	approveLoginId="29219255";
	

	//获取登录人员信息
	var dataJson=plus.qytxplugin.getLoginUserInfo();
	if(dataJson){
		var data="";
		if(typeof(dataJson)=="string"){
			data=JSON.parse(dataJson);
		}else{
			data=dataJson;
		}
		approveLoginId=data.userId;
		approveLoginName=data.userName;
		approveLoginGroupId=data.groupId;
	}
	plus.storage.setItem("flowType","1");//1表示默认类型固定流程 2表示自由流程
	plus.storage.setItem("baseUrl",baseUrl);
	plus.storage.setItem("basePath",basePath);
	plus.storage.setItem("photoUrl",photoUrl);
	plus.storage.setItem("approveLoginId",approveLoginId+"");
	plus.storage.setItem("approveLoginName",approveLoginName);
	plus.storage.setItem("approveLoginGroupId",approveLoginGroupId);
	plus.storage.setItem("fileUploadPath",fileUploadPath);
	plus.storage.setItem("fileDownPath",fileDownPath);
});