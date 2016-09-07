/**
 *  0当天之前，1当天，2当天之后
 */
var isAfterToday = 0;
/**
 *  当前年
 */
var year = 0;
/**
 *  当前月份 
 */
var month = 0;
/**
 * 当前天
 */
var day = 0;

/**
 * 日历选中对象ID
 */
var focusId = "";
/**
 * 缓存数组 cacheAry
 * cacheAry[0] 存放是否使用缓存 
 * cacheAry[1] 存放页面滚动条位置
 * cacheAry[2] 存放日历数据源
 * cacheAry[3] 存放列表数据源
 * cacheAry[4] 存放年
 * cacheAry[5] 存放月
 * cacheAry[6] 存放日
 * cacheAry[7] 存放日历选中对象ID
 * cacheAry[8] 存放日程列表的时间
 */
mui.plusReady(function(){
	
	//使用缓存数据
	var scheduleListCache = plus.storage.getItem("scheduleListCache");
	if(scheduleListCache){
		//转换成数组对象
		var cacheAry = JSON.parse(scheduleListCache);
		if(cacheAry[0]){
			//初始化年月日
			year = cacheAry[4];
			month = cacheAry[5];
			day = cacheAry[6];
			$(".data_select").html('<em class="be_back"></em>'+year+'年'+month+'月<em class="be_go"></em>');
			//加载日历
			showCalendarWithData(cacheAry[2]);
			//日历选中
			focusId = cacheAry[7];
			$("#"+focusId).find("span").eq(0).addClass("focus");
			//加载列表
			showListWithData(cacheAry[3],cacheAry[8]);
			cacheAry[0] = false;
			plus.storage.setItem("scheduleListCache",JSON.stringify(cacheAry));
			//定位滚动条
			if (plus.os.name == "iOS") {
				document.scrollY = cacheAry[1];
			} else {
				document.body.scrollTop = cacheAry[1];
			}
		}else{
			var param = {
				"_clientType": "wap",
				"userId": window.windowCommon.approveLoginId
			}
			getCalendar(param);
		}
	}else{
		var param = {
			"_clientType": "wap",
			"userId": window.windowCommon.approveLoginId
		}
		getCalendar(param);
	}
	
	
	$(".month_area ul li span").live("tap",function(){
		$(".month_area ul li span").removeClass("focus");
		$(this).addClass("focus");
		day = $(this).text();
		focusId = $(".focus").parent().attr("id");
		getList(addDateZero(year+'-'+month+'-'+day));
	})
	//上个月
	$(".data_select .be_back").live("tap",function(){
		if(month==1){
			month = 12;
			year = parseInt(year)-1;
		}else{
			month = parseInt(month)-1;
		}
		$(".data_select").html('<em class="be_back"></em>'+year+'年'+month+'月<em class="be_go"></em>');
		var yearMonth = year+'-'+month;
		if(month<10){
			yearMonth = year+'-0'+month;
		}
		param = {
			"_clientType": "wap",
			"userId": window.windowCommon.approveLoginId,
			"month":yearMonth
		}
		getCalendar(param);
	})
	//下个月
	$(".data_select .be_go").live("tap",function(){
		if(month==12){
			month = 1;
			year = parseInt(year)+1;
		}else{
			month = parseInt(month)+1;
		}
		$(".data_select").html('<em class="be_back"></em>'+year+'年'+month+'月<em class="be_go"></em>');
		var yearMonth = year+'-'+month;
		if(month<10){
			yearMonth = year+'-0'+month;
		}
		param = {
			"_clientType": "wap",
			"userId": window.windowCommon.approveLoginId,
			"month":yearMonth
		}
		getCalendar(param);
	})
	
	//删除
	$(".del").live("tap",function(){
		var obj = $(this);
		mui.confirm('确认删除此日程吗？', null, null, function(e) {
			if (e.index == 0) {
				console.log('确认');
				var scheduleId = obj.parent().parent().attr("scheduleId");
				var param = {
					"_clientType": "wap",
					"userId": window.windowCommon.approveLoginId,
					"scheduleId":scheduleId,
					"status":-1
				};
				updateScheduleStatus(param);
			} else if (e.index == 1) {
				console.log('取消');
			}
		});
		
	})
	//完成
	$(".fin").live("tap",function(){
		var obj = $(this);
		mui.confirm('确认完成此日程吗？', null, null, function(e) {
			if (e.index == 0) {
				console.log('确认');
				var scheduleId = obj.parent().parent().attr("scheduleId");
				var param = {
					"_clientType": "wap",
					"userId": window.windowCommon.approveLoginId,
					"scheduleId":scheduleId,
					"status":1
				};
				updateScheduleStatus(param);
			} else if (e.index == 1) {
				console.log('取消');
			}
		});
		
	})
	//撤销
	$(".cancel").live("tap",function(){
		var obj = $(this);
		mui.confirm('确认撤销此日程吗？', null, null, function(e) {
			if (e.index == 0) {
				console.log('确认');
				var scheduleId = obj.parent().parent().attr("scheduleId");
				var param = {
					"_clientType": "wap",
					"userId": window.windowCommon.approveLoginId,
					"scheduleId":scheduleId,
					"status":0
				};
				updateScheduleStatus(param);
			} else if (e.index == 1) {
				console.log('取消');
			}
		});
		
	})
	//未完成
	$(".unfin").live("tap",function(){
		var scheduleId = $(this).parent().parent().attr("scheduleId");
		plus.storage.setItem("scheduleId",scheduleId+"");
		//开启页面缓存
		setDataToCache();
		window.location.href = 'unDoneReason.html';
	})
	//编辑
	$(".edit").live("tap",function(){
		var scheduleId = $(this).parent().parent().attr("scheduleId");
		plus.storage.setItem("scheduleId",scheduleId+"");
		plus.storage.setItem("content",$(this).parent().parent().find("span").eq(0).text().split("、")[1]);
		plus.storage.setItem("completeTime",addDateZero(year+'-'+month+'-'+day));
		//开启页面缓存
		setDataToCache();
		window.location.href = 'addSchedule.html';
	})
	//新增
	mui("#add")[0].addEventListener('tap', function() {
		//开启页面缓存
		setDataToCache();
		window.location.href='addSchedule.html';
	});
	//月报
	mui(".month_btn")[0].addEventListener('tap', function() {
		//开启页面缓存
		setDataToCache();
		window.location.href='monthReport.html';
	});
})

/**
 * 获得当月日历
 * @param {Object} param
 */
function getCalendar(param){
	_scheduleApi._getCalendar(param,function(data){
		if(year==0 && month==0){
			var today = delDateZero(data.today).split("-");
			year = today[0];
			month = today[1];
			day = today[2];
			$(".data_select").html('<em class="be_back"></em>'+today[0]+'年'+today[1]+'月<em class="be_go"></em>');
			getList(data.today);
		}
		showCalendarWithData(data);
	
		//保存缓存数据
		var scheduleListCache = plus.storage.getItem("scheduleListCache");
		var cacheAry;
		if(scheduleListCache){
			cacheAry = JSON.parse(scheduleListCache);
			cacheAry[2] = data;
		}else{
			cacheAry = new Array();
			cacheAry[0] = false;
			cacheAry[2] = data;
		}
		plus.storage.setItem("scheduleListCache",JSON.stringify(cacheAry));
	})
}

/**
 * 展示日历
 * @param {Object} data
 */
function showCalendarWithData(data){
	var html = '';
	$.each(data.list,function(i,time){
		//判断是否为当天之前的日期
		if(parseInt(data.today.replace('-','').replace('-','')) < parseInt(time.date.replace('-','').replace('-',''))){
			isAfterToday = 2;
		}
		if(parseInt(data.today.replace('-','').replace('-','')) == parseInt(time.date.replace('-','').replace('-',''))){
			isAfterToday = 1;
		}
		if(parseInt(data.today.replace('-','').replace('-','')) > parseInt(time.date.replace('-','').replace('-',''))){
			isAfterToday = 0;
		}
		
		if(i%7==0){
			html+='<ul>';
		}
		var yearMonth = year+'-'+month;
		if(month<10){
			yearMonth = year+'-0'+month;
		}
		//是否为选择的月  	
		if(yearMonth==time.date.substring(0,7)){
			html+='<li id="li'+yearMonth+i+'">';
			html+='<span class="pr';
			//如果是当天之前或者是周末
			if(isAfterToday==0 || i%7==0 || i%7==6){
				html+=' overdue';
			}
			//当天
			if(isAfterToday==1){
				html+=' the_day';
			}
			html+='">';
			html+=delDateZero(time.date).split("-")[2];
			html+='<em class="dian';
			if(isAfterToday==0 && time.point==1){
				html+=' bygone_dian';
			}
			if(isAfterToday==1 && time.point==1){
				html+=' now_dian';
			}
			if(isAfterToday==2 && time.point==1){
				html+=' future_dian';
			}
			html+='"></em>';
			html+='</span>';
			html+='</li>';
		}else{
			html+='<li></li>';
		}
		
		if(i%7==6){
			html+='</ul>';
		}
	})
	$(".month_area").html(html);
	//选中
	$("#"+focusId).find("span").eq(0).addClass("focus");
}



/**
 * 日程列表
 */
function getList(completeTime){
	param = {
			"_clientType": "wap",
			"userId": window.windowCommon.approveLoginId,
			"completeTime":completeTime
		}
	_scheduleApi._getScheduleList(param,function(data){
		showListWithData(data,year+"年"+month+"月"+day+"日");
		//保存缓存数据
		var scheduleListCache = plus.storage.getItem("scheduleListCache");
		var cacheAry;
		if(scheduleListCache){
			cacheAry = JSON.parse(scheduleListCache);
			cacheAry[3] = data;
			cacheAry[8] = year+"年"+month+"月"+day+"日";
		}else{
			cacheAry = new Array();
			cacheAry[0] = false;
			cacheAry[3] = data;
			cacheAry[8] = year+"年"+month+"月"+day+"日";
		}
		plus.storage.setItem("scheduleListCache",JSON.stringify(cacheAry));
	})
}

/**
 * 展示列表数据
 * @param {Object} data
 * @param {Object} day_data 列表时间
 */
function showListWithData(data,day_data){
	$(".program_list").empty();
	var sum = 0;
	var finish = 0;
	//如果没有数据，去除当天的圆点
	if(data.length==0){
		$(".focus").find("em").removeClass("bygone_dian").removeClass("now_dian").removeClass("future_dian");
	}
	$.each(data,function(i,schedule){
		sum ++;
		if(schedule.status==1){
			finish ++;
		}
		var html = '';
		html += '<li class="pr b_bor" scheduleId="'+schedule.id+'">';
		html += '<span class="program_infor pr">';
		if(schedule.status==0){//进行中
			html += (i+1)+'、'+schedule.content;
			html += '<em class="show_hide"></em>';
		}else if(schedule.status==1){//完成
			html += (i+1)+'、<span class="doing_text">[已完成]</span>'+schedule.content;
			html += '<em class="cancel"></em>';
		}else if(schedule.status==2){//未完成
			html += (i+1)+'、<span class="not_text">[未完成]</span>'+schedule.content;
			html += '<em class="cancel"></em>';
		}
		
		html += '</span>';
		if(schedule.status==0){
			html += '<div class="program_set">';
			html += '<div class="active set_option del">';
			html += '<span class="dele_btn">删除</span>';
			html += '</div>';
			html += '<div class="active set_option edit">';
			html += '<span class="edit_btn">编辑</span>';
			html += '</div>';
			html += '<div class="active set_option unfin">';
			html += '<span class="dont_btn">未完成</span>';
			html += '</div>';
			html += '<div class="active set_option fin">';
			html += '<span class="well_btn">完成</span>';
			html += '</div>';
			html += '</div>';
		}
		html += '</li>';
		$(".program_list").append(html);
	})
	$(".day_data").html(day_data);
	$(".number_time").html("已完成："+finish+"/"+sum);
}

/**
 * 修改日程状态
 * param.status -1删除 0撤销 1完成 2未完成
 * @param {Object} param
 */
function updateScheduleStatus(param){
	_scheduleApi._updateScheduleStatus(param,function(data){
		if(data==1){
			mui.toast("操作成功");
			//重新查询列表
			getList(addDateZero(year+'-'+month+'-'+day));
		}else{
			mui.toast("操作失败");
		}
	});
}


/**
 * 删除日期的0
 * @param {Object} date
 */
function delDateZero(date){
	var temp = date.split("-");
	if(temp[1].substring(0,1)=='0'){
		temp[1] = temp[1].substring(1,2);
	}
	if(temp[2].substring(0,1)=='0'){
		temp[2] = temp[2].substring(1,2);
	}
	return temp[0]+'-'+temp[1]+'-'+temp[2];
}

/**
 * 补全日期的0
 * @param {Object} date
 */
function addDateZero(date){
	var temp = date.split("-");
	if(temp[1] < 10){
		temp[1] = '0' + temp[1];
	}
	if(temp[2] < 10){
		temp[2] = '0' +temp[2];
	}
	return temp[0]+'-'+temp[1]+'-'+temp[2];
}


/**
 * 离开页面前,记录滚动轴位置等信息,并开启缓存
 * 不使用缓存调用common.js 中的setCacheEnd()方法
 */
function setDataToCache() {
	var scheduleListCache = plus.storage.getItem("scheduleListCache");
	if (scheduleListCache) {
		var cacheAry = JSON.parse(scheduleListCache);
		//开启缓存
		cacheAry[0] = true;
		if (plus.os.name == "iOS") {
			cacheAry[1] = document.scrollY + '';
		} else {
			cacheAry[1] = document.body.scrollTop + '';
		}
		cacheAry[4] = year;
		cacheAry[5] = month;
		cacheAry[6] = day;
		cacheAry[7] = focusId;
		plus.storage.setItem("scheduleListCache",JSON.stringify(cacheAry));
	}
	//设置返回页面
	plus.storage.setItem("scheduleBackUrl","scheduleList.html");
	
}