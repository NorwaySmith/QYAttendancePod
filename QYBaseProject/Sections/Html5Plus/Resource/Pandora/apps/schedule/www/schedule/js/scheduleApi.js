var _scheduleApi={
	/**
	 * 添加日程
	 */
	_addSchedule:function(param,callback){
		console.log(window.windowCommon.basePath);
		mui.ajax(window.windowCommon.basePath+"schedule/saveScheduleList.c",{
			data: param,
			dataType: 'json',
			type: 'post',
			timeout :100000,
			crossDomain: true,
			success: function(result){
				console.log(333);
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
	},
	//获得当前月份日历
	_getCalendar:function(param,callback){
		mui.ajax(window.windowCommon.basePath+"schedule/getCalendar.c",{
			data: param,
			dataType: 'json',
			type: 'post',
			timeout :45000,
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
		})
	},
	_getScheduleList:function(param, callback){
		mui.ajax(window.windowCommon.basePath+"schedule/getScheduleList.c",{
			data: param,
			dataType: 'json',
			type: 'post',
			timeout :45000,
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
		})
	},
	_updateScheduleStatus:function(param, callback){
		mui.ajax(window.windowCommon.basePath+"schedule/updateScheduleStatus.c",{
			data: param,
			dataType: 'json',
			type: 'post',
			timeout :45000,
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
		})
	},
	 //获得日程月报
    _getScheduleListes: function(param,callback){
    	mui.ajax(window.windowCommon.basePath+"schedule/getScheduleListByDay.c",{
			data: param,
			dataType: 'json',
			type: 'post',
			timeout :45000,
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
		})
    }

}

