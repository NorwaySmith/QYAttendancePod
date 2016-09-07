/**
 * 往来单位js API接口
 */
var _customerApi={
	/**
	 * 往来客户选择列表
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_getSelectCustomerList:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/getSelectCustomerList.c", {
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
	 * 初始化往来客户的数据字典
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_getCustomerDict:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/getCustomerDict.c", {
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
	 * 获得往来客户列表
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_getCustomerList:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/getCustomerList.c", {
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
	 * 获得往来单位详情
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_getCustomerDetail:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/getCustomerDetail.c",{
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 20000, //超时时间设置为10秒；
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
	 * 保存来往单位详情
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	_saveCustomer:function(param,callback,errorCallback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/saveCustomer.c",{
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
				if(errorCallback!=null && errorCallback!=undefined){
					errorCallback(xhr, type, errorThrown);
				}
			}
		});
	},
	/**
	 * 获得往来单位的机会列表，订单列表，联系人列表，跟进人
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_findChanceOrderUserList:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/findChanceOrderUserList.c",{
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
	 * 获得往来单位的负责人，跟进人
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_findOwnerFollowUsers:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/findOwnerFollowUsers.c",{
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
	 * 变跟负责人
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_changeOwner:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/changeOwner.c",{
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
	 * 变更跟进人
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_changeFollowUser:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/changeFollowUser.c",{
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
	 * 获得详情（修改页）
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_getCustomerDetailForEdit:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/getCustomerDetailForEdit.c",{
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
	 * 保存修改
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	_saveEdit:function(param,callback,errorCallback){
		mui.ajax(window.windowCommon.basePath+"crm/customer/saveEdit.c",{
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
				if(errorCallback!=null && errorCallback!=undefined){
					errorCallback(xhr, type, errorThrown);
				}
			}
		});
	},
	/**
	 * 获得联系记录列表
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_visitList:function(param,callback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecord/getVisitListByCustomer.c?r=" + Math.random(), {
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
	 * 变更往来单位状态
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_changeCustomerState:function(param,callback){
		mui.ajax(window.windowCommon.basePath + "crm/customer/changeCustomerState.c?r=" + Math.random(), {
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
	}
}

