/**
 * 销售机会js接口
 */
var _chanceApi={
	/**
	 * 获得机会列表
	 * @param {Object} param 参数
	 * "_clientType": "wap",
	 * "pageNo": 页码
	 * "pageSize": 每页的条数,
	 * "expectedTime": 预计成交日期
	 * "sellStage": 销售阶段,
	 * "customerId": 客户id,
	 * "subordinate": 是否是全部下属,
	 * "userId": 当前登录用户id
	 * @param {Object} callback 回调函数
	 */
	_getSelectChanceList:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/chance/getSelectChanceList.c", {
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
	 * 通过机会id获得机会详情
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": 当前登录用户id,
	 * "id": 机会id
	 * @param {Object} callback
	 */
	_findChance:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/chance/findChance.c', {
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
	 * 初始化销售阶段
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": window.windowCommon.approveLoginId,
	 * "infoType": 'sellStage' //sellStage表示销售阶段
	 * @param {Object} callback
	 */
	_getDictType:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/chance/getDictType.c', {
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
	 * 新增或修改销售机会
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "id": 销售机会id，新增时不传,
	 * "userId": 当前登录用户id,
	 * "chanceName": 机会名称,
	 * "chanceMoney": 机会金额,
	 * "customerId": 往来单位id,
	 * "sellStage": 销售阶段,
	 * "expectedTime": 期望成交时间,
	 * "remark": 备注
	 * @param {Object} callback
	 * @param {Object} errorCallback
	 */
	_saveOrUpdateChance:function(param,callback,errorCallback){
		mui.ajax(window.windowCommon.basePath + 'crm/chance/saveOrUpdateChance.c', {
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
			error:function(){
				if(errorCallback){
					errorCallback();
				}
			}
		});
	},
	/**
	 * 修改销售机会
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": 当前登录用户,
	 * "cid": 机会id,
	 * "sellStage": 销售阶段,
	 * "followUserIds": 跟进人id,
	 * "which": which 1表示修改销售阶段， 2 表示修改跟进人 3修改负责人
	 * @param {Object} callback
	 */
	_modifyChancePart:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/chance/modifyChancePart.c', {
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
	 * 初始化销售机会列表的查询条件
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": 当前登录用户id
	 * @param {Object} callback
	 */
	_initListSearch:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/chance/initListSearch.c', {
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
	 * 销售绩效页面的日期搜索初始化
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": window.windowCommon.approveLoginId
	 * @param {Object} callback
	 */
	_getSystemTime:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/chance/getSystemTime.c', {
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
	 * 根据搜索条件查询销售绩效信息
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": window.windowCommon.approveLoginId,
	 * "thismonth": 日期,
	 * "follower": 跟进人id,
	 * "subordinate": 是否全部下属
	 * @param {Object} callback
	 */
	_getSalesPerformance:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/chance/getSalesPerformance.c', {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			}
		});
	},
	/**
	 * 查询销售漏斗信息
	 * @param {Object} param
	 * "_clientType": "wap",
	 * "userId": window.windowCommon.approveLoginId,
	 * "yearMonth": 日期,
	 * "follower": 跟进人id,
	 * "subordinate": 是否全部下属  0否1是
	 * @param {Object} callback
	 */
	_salefunnel:function(param,callback){
		mui.ajax(window.windowCommon.basePath + 'crm/saleFunel/salefunnel.c', {
			data: param, 
			dataType: 'json',
			type:'post',//HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(result){
				if(callback!=null && callback!=undefined){
					callback(result);
				}
			}
		});
	}
}

