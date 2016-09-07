/**
 * 联系人模块jsAPI层接口
 */
var contactApi = {
	/**
	 * 得到联系人详情
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": window.windowCommon.approveLoginId,
	 * "contactId": 联系人id
	 * @param {Object} callback
	 */
	getPerDetail:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"contact/contactDetail.c", {
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
	 * 保存联系人
	 * @param {Object} param
	 * "userId":window.windowCommon.approveLoginId,
	 * "contactName":contactName,
	 * "customerId":customerId,
	 * "customerName":customerName,
	 * "groupName":groupName,
	 * "jobName":jobName,
	 * "telphone":telphone,
	 * "phone":phone,
	 * "qq":qq,
	 * "email":email,
	 * "sex":sex,
	 * "birthday":birthday,
	 * "address":address,
	 * "favorite":favorite,
	 * "type":'add',
	 * "remark":remark
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	saveContact:function(param,callback,errorCallback){
		mui.ajax(window.windowCommon.basePath+"contact/saveContact.c?r=" + Math.random(), {
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
			error:function(){
				if(errorCallback){
					errorCallback();
				}
			}
		});
		
	},
	/**
	 * 获得联系人列表
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "pageNo": currentPage,
	 * "pageSize": 10,
	 * "userName": keyword,
	 * "subordinate": searchFollower,
	 * "userId": window.windowCommon.approveLoginId
	 * @param {Object} callback
	 */
	getList:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"contact/contactList.c?r=" + Math.random(), {
			data: param, 
			dataType: 'text',
			type:'post',//HTTP请求类型
			timeout: 100000, //超时时间设置为10秒；
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
	 * 删除联系人
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": window.windowCommon.approveLoginId,
	 * "contactId": self.contactId
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	deleteContact:function(param,callback,errorCallback){
		mui.ajax(window.windowCommon.basePath+"contact/deleteContact.c?r=" + Math.random(), {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 100000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			},
			error:function(){
				if(errorCallback){
					errorCallback();
				}
			}
		});
		
	}
}
