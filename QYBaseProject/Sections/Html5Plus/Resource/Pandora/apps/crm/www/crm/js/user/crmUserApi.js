/**
 * 上下级js接口
 */
var _crmUserApi={
	/**
	 * 获得所有下属
	 * @param {Object} param
	 * @param {Object} callback
	 */
	_getSelectFollowerList:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"crm/userpath/getAllFollowers.c", {
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

