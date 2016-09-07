var _taskApi={
	//获取列表
	_getList:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/getList.c",{
			data: param,
			dataType: 'json',
			type: 'post',
			timeout :100000,
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
			
		});
	},
	//获取任务内容
	_taskContent:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/taskContent.c",{
			data: param,
			dataType: 'text',
			type: 'post',
			timeout :100000,
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					//console.log(JSON.stringify(result));
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
			
		});
	},
	//任务分解
	_taskDecompose:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/taskDecompose.c",{
			data: param,
			dataType: 'text',
			type: 'post',
			timeout :100000,
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					console.log(result);
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
			
		});
	},
	/**
	 * 增加任务
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	_addTask:function(param ,callback,errorCallback){		
		mui.ajax(window.windowCommon.basePath + 'task/addTask.c',{
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					//console.log(JSON.stringify(result));
					callback(result);
				}
			},
			error:function(){
				if(errorCallback){
					errorCallback();
				}
			}
		});
	},
	/**
	 * 任务详情
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_getDetail:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/getDetail.c",{
			data: param,
			dataType: 'json',
			type: 'post',
			timeout :100000,
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					//console.log(JSON.stringify(result));
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
			
		});
	},
	/**
	 * 已结束任务列表
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_getOverTaskList:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/overTaskPage.c", {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
		});
	},
	/**
	 * 任务转交操作
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_taskTransfer:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/taskTransfer.c", {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
		});

	},
	/**
	 * 领取任务
	 */
	_updateTaskStatus:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/updateTaskStatus.c", {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
		});

	},
	/**
	 * 任务状态变更操作
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_taskStatusChange:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/taskStatusChange.c", {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
		});
	},
	_findTransfer:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/findTransfer.c", {
			data: param, 
			dataType: 'text',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
		});

	},
	/**
	 * 任务未完成操作
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_taskUnComplete:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"task/taskUnComplete.c", {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			},
			error:function(xhr, type, errorThrown){
				if(type=="timeout"){
					mui.toast("请求超时");
				}else{
					mui.toast("请求失败");
				}
			}
		});

	},
	/**
	 * 调用手机端的人员选择方法
	 * @param {Object} param {"userIds": 1, "toastMsg": '请选择人员！'} userIds 已经勾选的人员ID，有多个时，逗号分割(前后都有逗号)。toastMsg 没有选择人员时的提示语。传null时， 不提示。
	 * @param {Object} callback 回调方法。 单选时，获取选择的人员ID : data[0].userId
	 */
	_selectUsers:function (param, callback){
		var uid = (param ? param.userIds : '');
		var toastMsg = (param ? param.toastMsg : null);
		if(toastMsg == ''){
			toastMsg = '请选择人员！';
		}
		/*
		 * 第一个参数，已经勾选的人员ID，有多个时，逗号分割(前后都有逗号)。
		 * 第二个参数，0表示多选， 1表示单选
		 * 第三个参数，回调方法，响应：[{"userId"：123, "userName": "张三", "userPhoto": "xx/xx.jpg", "picType":"string"},{}, ... ...]
		 */
		plus.qytxplugin.selectUsers(uid, 1, function(data) {
			if (data != null && data != undefined && data.length > 0) {
				callback(data);
			}else {
				if(!toastMsg){
					mui.toast(toastMsg);
				}
			}
		});
	},
	/**
	 * 调用手机端的时间控件选择时间(yyyy-MM-dd)
	 * @param {Object} param {"timeL": 123456}, timeL是默认选中的时间的毫秒值
	 * @param {Object} callback 回调方法。 
	 */
	_selectDateTime:function(param, callback){
		//var that = this;
		var timeL = (param ? param.timeL : undefined);
		var dDate = undefined;
		if (!timeL) {
			dDate = new Date();
		} else {
			dDate = new Date(timeL);
		}
		var bTime = dDate.getFullYear() 
					+ "-" + ((dDate.getMonth() + 1) < 10 ? ("0" + (dDate.getMonth() + 1)) : (dDate.getMonth() + 1)) 
					+ "-" + (dDate.getDate() < 10 ? ("0" + dDate.getDate()) : dDate.getDate());
		var defaultAry=[bTime, "yyyy-MM-dd"];
		plus.qytxplugin.selectDateTime(defaultAry,function(data){
			callback(data);
			/*bTime = data.date;
			$(that).html(bTime.split(" ")[0]);*/
		});
	}
}
