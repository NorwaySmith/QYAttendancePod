mui.plusReady(function(){
//	var basePath="http://10.100.6.135:6667/txzlbmc/";
//	var basePath="http://192.168.1.120:8080/txzlbmc/";
	/** 测试 环境*/
//	var basePath="http://218.206.244.202:38080/txzlbmc/";
//	var photoUrl="http://218.206.244.202:38080/ydzjMobile/headPictureView.action?_clientType=wap&filePath=";
	/**正式环境*/
	var baseUrl="http://101.200.31.143/";
	var basePath="http://101.200.31.143/txzlbmc/";
	var photoUrl="http://101.200.31.143/ydzjMobile/headPictureView.action?_clientType=wap&filePath=";
	var approveLoginId="";
	var approveLoginName="";
	var approveLoginGroupId="";
//	approveLoginId="29219013";//用户登录id
	approveLoginId="10987542";

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
	plus.storage.setItem("baseUrl",baseUrl);
	plus.storage.setItem("basePath",basePath);
	plus.storage.setItem("photoUrl",photoUrl);
	plus.storage.setItem("approveLoginId",approveLoginId+"");
	plus.storage.setItem("approveLoginName",approveLoginName);
	plus.storage.setItem("approveLoginGroupId",approveLoginGroupId);
});
