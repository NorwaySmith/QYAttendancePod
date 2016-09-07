/**
 * 销售绩效js
 */
var memberId;

//页面加载完毕方法
mui.plusReady(function() {
	var self = plus.webview.currentWebview();
	memberId = self.followerId;
	if(plus.webview.currentWebview().userName != undefined && plus.webview.currentWebview().userName != null){
		mui('.mui-title')[0].innerHTML = plus.webview.currentWebview().userName + '的销售绩效';
	}
	
	if(mui('.top-nav-three a')[0] != undefined && mui('.top-nav-three a')[0] != null){
		//填充当前人的姓名
		mui('.top-nav-three a')[0].innerHTML = window.windowCommon.approveLoginName+'<em class="unit-filter-r1"></em>';
	}
	
	mui.init({
		swipeBack: true, //启用右滑关闭功能
	});
	mui('.mui-scroll-wrapper1').scroll();
	
	initSearch(fullPerformanceInfo);
	
	/* 绑订 查询条件中浮动框的特效 start */
	mui(".top-nav-one")[0].addEventListener('tap', function() {
		mui("#popover3").popover('toggle');
	});
	
 	mui("#popover3").on('tap', "li",function() {
		mui("#popover3").popover('toggle');
	});
	
	mui(".top-nav-two")[0].addEventListener('tap', function() {
		mui("#popover1").popover('toggle');
	});
	
 	mui("#popover1").on('tap', "li",function() {
		mui("#popover1").popover('toggle');
	});
	
	if(mui('.top-nav-three')[0] != undefined && mui('.top-nav-three')[0] != null){
		mui(".top-nav-three")[0].addEventListener('tap', function() {
			mui("#popover2").popover('toggle');
		});
		
	 	mui("#popover2").on('tap', "li",function() {
			mui("#popover2").popover('toggle');
		});
	}
	/* 绑订 查询条件中浮动框的特效 end */

});



/**
 * 填充绩效信息
 */
function fullPerformanceInfo() {
	plus.nativeUI.showWaiting("等待中...");
	//console.log('填充绩效信息');
	var year = document.getElementById("year").value;
	var month = document.getElementById("month").value;
	var thismonth = year +'-' +month;
	var follower = window.windowCommon.approveLoginId;
	if(memberId != undefined && memberId != null){
		follower = memberId;
	}
	var subordinate = mui("#subordinate")[0].value;
	
	//业务逻辑代码，比如通过ajax从服务器获取新数据；
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"thismonth": thismonth,
		"follower": follower,
		"subordinate": subordinate
	};
	
	_chanceApi._getSalesPerformance(param, function(response) {
		//console.log(JSON.stringify(response));
		if (response.code == 1) {
			if(response.data.maxExpectedChanceMoney){
				document.getElementById("maxExpectedChanceMoney").innerHTML = response.data.maxExpectedChanceMoney;
			}else{
				document.getElementById("maxExpectedChanceMoney").innerHTML = "￥0.00";
			}
			document.getElementById("salesTarget").innerHTML = response.data.salesTarget;
			document.getElementById("orderCount").innerHTML = response.data.orderCount + '单';
			document.getElementById("orderMoney").innerHTML = response.data.orderMoney;
			document.getElementById("payMoney").innerHTML = response.data.payMoney;
		}
		plus.nativeUI.closeWaiting();
	});
}

if (mui.os.plus) {
} else {
}

/* ================================================================================================= */



/**
 * 条件查询
 */
var conditionsQuery = function(){
	//console.log('条件查询');
	fullPerformanceInfo();
}


/**
 * 初始化列表的查询条件
 */
var initSearch = function(callback){
	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId
	};
	_chanceApi._getSystemTime(data, function(response){
			//console.log(JSON.stringify(response));
			assignment(response);
			loadYear(response);
			loadMonth(response);
			loadMember();
			
			if (callback != undefined && callback != null) {
				callback();
			}
		});
}

/**
 * 赋初始化值
 */
var assignment = function(response){
	mui(".top-nav-one a")[0].innerHTML = response.year+'年<em class="unit-filter-r1"></em>';
	mui(".top-nav-two a")[0].innerHTML = (response.month+1)+'月<em class="unit-filter-r1"></em>';
	document.getElementById("year").value = response.year;
	document.getElementById("month").value = response.month+1;
}

/**
 * 加载成员
 */
var loadMember = function(){
	
	var subli01 = document.createElement("li");
	subli01.setAttribute("class", "mui-table-view-cell month-active");
	var name = window.windowCommon.approveLoginName;
	if(name == 'null'){
		name = '';
	}
	subli01.innerHTML = name;
	subli01.addEventListener('tap', function() {
		document.getElementById("subordinate").value = '';
		
		var lis = mui("#memberUL li");
		mui.each(lis, function(i, n) {
			lis[i].setAttribute("class", "mui-table-view-cell");
		});
		this.setAttribute("class", "mui-table-view-cell month-active");
		mui('.top-nav-three a')[0].innerHTML = window.windowCommon.approveLoginName+'<em class="unit-filter-r1"></em>';
		
		conditionsQuery();
	});
	
	var subli02 = document.createElement("li");
	subli02.setAttribute("class", "mui-table-view-cell");
	subli02.innerHTML = '全部下属';
	subli02.addEventListener('tap', function() {
		document.getElementById("subordinate").value = 1;
		
		var lis = mui("#memberUL li");
		mui.each(lis, function(i, n) {
			lis[i].setAttribute("class", "mui-table-view-cell");
		});
		this.setAttribute("class", "mui-table-view-cell month-active");
		mui('.top-nav-three a')[0].innerHTML = '全部下属<em class="unit-filter-r1"></em>';
		
		conditionsQuery();
	});
	
	var subli03 = document.createElement("li");
	subli03.setAttribute("class", "mui-table-view-cell");
	subli03.innerHTML = '<a class="mui-navigate-right">下属成员</a>';
	subli03.addEventListener('tap', function() {
		mui.openWindow({
		    url: '../user/selectFollower.html',
		    id: 'chooseFollowerForCustomer',
		    extras:{
		    	viewId:plus.webview.currentWebview().id,
	    		//callbackFun:"conditionsQuery",
		    	tourl:"../chance/memberPerformancelist.html",
		    	toviewid:'memberPerformancelist.html',
		    }
		});
	});
	
	var ul = mui("#popover2 ul")[0];
	ul.appendChild(subli01);
	ul.appendChild(subli02);
	ul.appendChild(subli03);
}

/**
 * 加载年
 * @param {Object} response
 */
var loadYear = function(response){
	var yearULObj = document.getElementById("yearUL");
	yearULObj.innerHTML = '';
	
	var subli01 = document.createElement("li");
	subli01.setAttribute("class", "mui-table-view-cell month-active");
	subli01.setAttribute("name", response.year);
	subli01.innerHTML = response.year+'年';
	yearULObj.appendChild(subli01);
	
	for(var i=0; i<4; i++) {
		var subli02 = document.createElement("li");
		subli02.setAttribute("class", "mui-table-view-cell");
		subli02.setAttribute("name", response.year-i-1);
		subli02.innerHTML = (response.year-i-1)+'年';
		yearULObj.appendChild(subli02);
	}
	
	var lis = mui("#yearUL li");
	mui.each(lis, function(i, n) {
		lis[i].addEventListener("tap", function() {
			selectYear(lis[i]);
		});
	});
}


/**
 * 选择一个年
 * @param {Object} obj
 */
var selectYear = function(obj){
	//修改样式
	var lis = mui("#yearUL li");
	mui.each(lis, function(i, n) {
		lis[i].setAttribute("class", "mui-table-view-cell");
	});
	obj.setAttribute("class", "mui-table-view-cell month-active");
	
	//赋值
	document.getElementById("year").value = obj.getAttribute("name");
	mui(".top-nav-one a")[0].innerHTML = obj.innerHTML + '<em class="unit-filter-r1"></em>';
	
	//消失(通过初始化方法中的绑订来完成)
	
	//查询
	conditionsQuery();
}


/**
 * 加载月
 * @param {Object} response
 */
var loadMonth = function(response){
	var monthULObj = document.getElementById("monthUL");
	monthULObj.innerHTML = '';
	
	/*var subli01 = document.createElement("li");
	subli01.setAttribute("class", "mui-table-view-cell");
	subli01.setAttribute("name", '');
	subli01.innerHTML = '全部';
	monthULObj.appendChild(subli01);*/
	
	for(var i=0; i<12; i++) {
		var subli02 = document.createElement("li");
		if(i == response.month){
			subli02.setAttribute("class", "mui-table-view-cell month-active");
		}else {
			subli02.setAttribute("class", "mui-table-view-cell");
		}
		
		subli02.setAttribute("name", i+1);
		subli02.innerHTML = (i+1)+'月';
		monthULObj.appendChild(subli02);
	}
	
	var lis = mui("#monthUL li");
	mui.each(lis, function(i, n) {
		lis[i].addEventListener("tap", function() {
			selectMonth(lis[i]);
		});
	});
}


/**
 * 选择一个月份
 * @param {Object} obj
 */
var selectMonth = function(obj){
	//修改样式
	var lis = mui("#monthUL li");
	mui.each(lis, function(i, n) {
		lis[i].setAttribute("class", "mui-table-view-cell");
	});
	obj.setAttribute("class", "mui-table-view-cell month-active");
	
	//赋值
	document.getElementById("month").value = obj.getAttribute("name");
	mui(".top-nav-two a")[0].innerHTML = obj.innerHTML + '<em class="unit-filter-r1"></em>';
	
	//消失(通过初始化方法中的绑订来完成)
	
	//查询
	conditionsQuery();
}
