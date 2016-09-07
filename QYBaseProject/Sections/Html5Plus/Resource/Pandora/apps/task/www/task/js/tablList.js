var type = 1;// 1 我承办的   2 我发起的	  3 我转交的
/**
 * 缓存数组 cacheAry
 * cacheAry[0] 存放是否使用缓存 
 * cacheAry[1] 存放页面滚动条位置
 * cacheAry[2] 存放页面数据源
 */
mui.plusReady(function() {
	//定位tab
	if(plus.storage.getItem("type")){
		type = plus.storage.getItem("type");
		$(".top_tap span").removeClass("active");
		$(".top_tap span").eq(type-1).addClass("active");
		plus.storage.removeItem("type");
	}
	
	//使用缓存数据
	var tabListCache = plus.storage.getItem("tabListCache");
	if(tabListCache){
		//转换成数组对象
		var cacheAry = JSON.parse(tabListCache);
		if(cacheAry[0]){
			showDataWithHTML(cacheAry[2]);
			cacheAry[0] = false;
			plus.storage.setItem("tabListCache",JSON.stringify(cacheAry));
			//定位滚动条
			if (plus.os.name == "iOS") {
				//document.scrollY = cacheAry[1];
				$("#mui-scroll").attr("style",cacheAry[1]);
			} else {
				//document.body.scrollTop = cacheAry[1];
				$("#mui-scroll").attr("style",cacheAry[1]);
			}
		}else{
			getList();
		}
	}else{
		getList();
	}
	
	//头部tab标签点击事件
	$(".top_tap span").click(function(){
		console.log($("#mui-scroll").attr("style"));
		$(".top_tap span").removeClass("active");
		$(this).addClass("active");
	    spanIndex = $(".top_tap span").index($(this));
	    type = spanIndex+1;
	    //scroll区域定位到顶部
	    $("#mui-scroll").attr("style","-webkit-transform: translate3d(0px, 0px, 0px) translateZ(0px);");
		getList();
	});
	
	//新增
	mui(".add_order")[0].addEventListener('tap', function() {
		setDataToCache();
		window.location.href='addTask.html';
	});
	
	// 绑定"查看已结束任务"的点击操作
	$("#toOverTask").live('tap', function() {
		setDataToCache();
		window.location.href = 'OverTask.html';
	});
	
});

/**
 * 点击详情
 * @param {Object} obj
 */
function detailclick(obj){
	setDataToCache();
	var taskId = $(obj).attr("taskId");
	plus.storage.setItem("taskId",taskId);
	window.location.href="TaskDetail.html";
}


/**
 * 查询列表
 */
function getList(){
	var param = {
		"_clientType": "wap",
		"type": type,
		"userId": window.windowCommon.approveLoginId
	};
	_taskApi._getList(param,function(data){ 
		showDataWithHTML(data);
		//保存缓存数据
		var tabListCache = plus.storage.getItem("tabListCache");
		var cacheAry;
		if(tabListCache){
			cacheAry = JSON.parse(tabListCache);
			cacheAry[2] = data;
		}else{
			cacheAry = new Array();
			cacheAry[0] = false;
			cacheAry[2] = data;
		}
		plus.storage.setItem("tabListCache",JSON.stringify(cacheAry));
	});
}

/**
 * 根据数据源，拼装页面
 * @param {Object} data
 */
function showDataWithHTML(data){
	$(".list ul").html('<div class="div_two" id="toOverTask"><span class="list_font ">查看已结束任务 </span><em class="zhishi_ico"></em></div>');
	
	$.each(data.list,function(i,task){
		var html = '<li taskId='+task.taskId+' onclick="detailclick(this)">';
		html += '<div class="list_li">';
		if(task.taskStatus==0){//待领取
			html += '<span class="list_title text_hide">(待领取)'+task.taskContent+'</span>';
		}else{
			html += '<span class="list_title text_hide">'+task.taskContent+'</span>';
		}
		html += '<span class="list_one pr"><em class="time_ico"></em>完成日期：'+task.completeTime+'</span>';
		if(type==1){
			html += '<span class="list_one pr"><em class="renwu_ico"></em>任务来源：'+task.createUserName+'</span>';
		}else if(type==2){
			html += '<span class="list_one pr"><em class="jieshou_ico"></em>承办人员：'+task.undertakerName+'</span>';
		}else if(type==3){
			html += '<span class="list_one pr"><em class="renwu_ico"></em>任务来源：'+task.createUserName+'</span>';
			html += '<span class="list_one pr"><em class="jieshou_ico"></em>接收人员：'+task.undertakerName+'</span>';
		}
		
		html += '</div>';
		if(task.decompose==1){
			html += '<div class="div_one pr t_bor"><p class="finish">已完成：'+task.finish+'</p></div>';
		}
		html += '</li>';
		
		$(".div_two").before(html);
	});
}


/**
 * 离开页面前,记录滚动轴位置等信息,并开启缓存
 * 不使用缓存调用common.js 中的setCacheEnd()方法
 */
function setDataToCache() {
	var tabListCache = plus.storage.getItem("tabListCache");
	if (tabListCache) {
		var cacheAry = JSON.parse(tabListCache);
		//开启缓存
		cacheAry[0] = true;
		if (plus.os.name == "iOS") {
			//cacheAry[1] = document.scrollY + '';
			cacheAry[1] = $("#mui-scroll").attr("style");
		} else {
			//cacheAry[1] = document.body.scrollTop + '';
			cacheAry[1] = $("#mui-scroll").attr("style");
		}
		plus.storage.setItem("tabListCache",JSON.stringify(cacheAry));
	}
	plus.storage.setItem("type",type+'');
}