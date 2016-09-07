/**
 * 联系记录js接口API
 */
var visitApi = {
	/**
	 * 获取服务器当前时间
	 * @param {Object} param
	 * @param {Object} callback
	 */
	getTime:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/visitrecord/getTime.c", {
			data: param, 
			dataType: 'text',
			type:'get',//HTTP请求类型
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
	 * 保存拜访记录
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	saveVisit:function(param,callback,errorCallback){
		mui.ajax(window.windowCommon.basePath+"crm/visitrecord/save.c", {
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
	 * 修改拜访记录
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	updateVisit:function(param,callback,errorCallback){
		mui.ajax(window.windowCommon.basePath+"crm/visitrecord/update.c", {
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
	 * 获取拜访记录列表
	 * @param {Object} param
	 * @param {Object} callback
	 */
	visitList:function(param,callback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecord/getVisitRecordList.c?r=" + Math.random(), {
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
	 * 初始化数据字典字段
	 * @param {Object} param
	 * @param {Object} callback
	 */
	getDictType:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/chance/getDictType.c', {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result,param.communicationMode);
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
	 * 获取单位联系人
	 * @param {Object} param
	 * @param {Object} callback
	 */
	getContact:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/contact/getContact.c', {
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
	 * 获取拜访记录信息
	 * @param {Object} param
	 * @param {Object} callback
	 */
	getVisitInfo:function(param,callback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecord/visitDetail.c?r=" + Math.random(), {
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
	 * 删除拜访记录
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	_delRecord:function(param, callback,errorCallback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecord/deleteVisit.c?r=" + Math.random(), {
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
	 * 评论
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	saveComment:function(param, callback,errorCallback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecordComment/savevisitrecordComment.c?r=" + Math.random(), {
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
	 * 删除点赞
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	delvisitPraise:function(param, callback,errorCallback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecordPraise/deletevisitrecordPraise.c?r=" + Math.random(), {
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
	 * 点赞
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	savevisitPraise:function(param, callback,errorCallback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecordPraise/savevisitrecordPraise.c?r=" + Math.random(), {
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
	 * 初始化年月日条件筛选 
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	initListVisit:function(param, callback,errorCallback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecord/initListVisit.c?r=" + Math.random(), {
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
	 * 统计 
	 * @param {Object} param
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	saleBehavior:function(param, callback,errorCallback){
		mui.ajax(window.windowCommon.basePath + "crm/visitrecordStatistics/saleBehavior.c?r=" + Math.random(), {
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
			error:function(e){
				if(errorCallback){
					errorCallback();
				}
			}
		});	
	}
}

