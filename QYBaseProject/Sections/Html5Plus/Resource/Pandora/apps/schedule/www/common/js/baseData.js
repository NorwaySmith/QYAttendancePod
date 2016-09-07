mui.plusReady(function(){
	/* 测试 环境 */
	var basePath="http://101.200.31.143/txzlbmc/";
	var photoUrl="http://218.206.244.202:38080/ydzjMobile/headPictureView.action?_clientType=wap&filePath=";

	var approveLoginId="29220397";
	var approveLoginName="超级管理员";
	var approveLoginGroupId="";
	//approveLoginId="29220437";//用户登录id

	//var basePath=window.plus.qytxplugin.getBaseUrl();
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
	
	plus.storage.setItem("basePath",basePath);
	plus.storage.setItem("photoUrl",photoUrl);
	plus.storage.setItem("approveLoginId",approveLoginId+"");
	plus.storage.setItem("approveLoginName",approveLoginName);
	plus.storage.setItem("approveLoginGroupId",approveLoginGroupId);
});
