/**
 * 订单jsAPI层接口
 */
var orderAPI =
    {
    	/**
    	 * 获得订单列表
    	 * @param {Object} param
    	 * @param {Object} successCallback
    	 */
    	getOrderList : function (param, successCallback)
		{
			var url = window.windowCommon.basePath+ 'crm/order/findOrderPage.c';
			var data = {
				"_clientType": "wap",
				"customerId": param.customerId==null?0:param.customerId,//客户id
				"userId": window.windowCommon.approveLoginId,//当前用户id
				"keyword":param.keyword==null?"":param.keyword,
				"state":param.state==null?-1:param.state,//订单状态
				"subordinate":param.subordinate==null?0:param.subordinate,//是否全部下级
				"follower":param.followerId==null?0:param.followerId,//下属id
				"currentPage": param.currentPage,
				"pageSize": 20
			};
			
			mui.ajax(url, {  
				data: data,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: false,
				success: function(result){
					if(successCallback){
						successCallback(result);
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
		 * 保存/修改订单
		 * @param {Object} param
		 * @param {Object} successCallback
		 * @param {Object} errorCallback
		 */
		saveOrUpdate : function(param,successCallback,errorCallback){
			var url = window.windowCommon.basePath + 'crm/order/saveOrUpdateOrder.c';
			mui.ajax(url, {
				data: param,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
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
		 * 获得订单的数据字典
		 * @param {Object} param
		 * @param {Object} callback
		 */
		getOrderDict:function(param,callback){
			mui.ajax(window.windowCommon.basePath+"crm/order/getOrderDict.c", {
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
		 * 获得订单详情
		 * @param {Object} param
		 * @param {Object} successCallback
		 */
		_orderDetail : function(param,successCallback){
			var url = window.windowCommon.basePath + 'crm/order/orderDetail.c';
			mui.ajax(url, {
				data: param,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
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
		 * 变更订单状态
		 * @param {Object} param
		 * @param {Object} successCallback
		 */
		_updateOrderState : function(param,successCallback){
			var url = window.windowCommon.basePath + 'crm/order/updateOrderState.c';
			mui.ajax(url, {
				data: param,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
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
		 * 加载回款列表
		 * @param {Object} param
		 * @param {Object} successCallback
		 */
		_paymentList : function(param,successCallback){
			var url = window.windowCommon.basePath + 'crm/payment/paymentList.c';
			mui.ajax(url, {
				data: param,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
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
		 * 删除回款记录
		 * @param {Object} param
		 * @param {Object} successCallback
		 */
		_delPayment : function(param,successCallback){
			var url = window.windowCommon.basePath + 'crm/payment/delPayment.c';
			mui.ajax(url, {
				data: param,
				dataType: 'text',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
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
		 * 修改回款记录是否开票状态
		 * @param {Object} param
		 * @param {Object} successCallback
		 */
		_updatePaymentState : function(param,successCallback){
			var url = window.windowCommon.basePath + 'crm/payment/updatePaymentState.c';
			mui.ajax(url, {
				data: param,
				dataType: 'text',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
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
		 * 订单回款金额统计
		 * @param {Object} param
		 * @param {Object} successCallback
		 */
		_payMoneyStatistics : function(param,successCallback){
			var url = window.windowCommon.basePath + 'crm/paymentStatistics/payMoneyStatistics.c';
			mui.ajax(url, {
				data: param,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
					}
				}
			});
		},
		/**
		 * 销售龙虎榜
		 * @param {Object} param
		 * @param {Object} successCallback
		 */
		saleBillboard : function(param,successCallback){
			var url = window.windowCommon.basePath + 'crm/orderStatistics/saleBillboard.c';
			mui.ajax(url, {
				data: param,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
					}
				}
			});
		}
    };