/**
 * 机会列表js
 */
var currentPage = 1;
var pageSize = 10;
var totalPage = 0;
//var clear = false;

//页面加载完毕方法
mui.plusReady(function() {
	mui('.top-nav-three a')[0].innerHTML = window.windowCommon.approveLoginName + '<em class="unit-filter-r1"></em>';
	mui.init({
		swipeBack: true, //启用右滑关闭功能
		pullRefresh: {
			container: '#pullrefresh',
			up: {
				contentrefresh: '正在加载...',
				callback: pullupRefresh
			}
		}
	});
	mui('.mui-scroll-wrapper1').scroll();

	initSearch();
	/* 绑订 查询条件中浮动框的特效 start */
	mui(".top-nav-one")[0].addEventListener('tap', function() {
		mui("#popover3").popover('toggle');
	});

	mui("#popover3").on('tap', "li", function() {
		mui("#popover3").popover('toggle');
	});

	mui(".top-nav-two")[0].addEventListener('tap', function() {
		mui("#popover1").popover('toggle');
	});

	mui("#popover1").on('tap', "li", function() {
		mui("#popover1").popover('toggle');
	});

	mui(".top-nav-three")[0].addEventListener('tap', function() {
		mui("#popover2").popover('toggle');
	});

	mui("#popover2").on('tap', "li", function() {
		mui("#popover2").popover('toggle');
	});
	/* 绑订 查询条件中浮动框的特效 end */

	//绑订添加方法
	document.getElementById("addchance").addEventListener('tap', function() {
		mui('#popover1').popover('hide');
		mui('#popover2').popover('hide');
		mui('#popover3').popover('hide');
		addchance();
	});


	$("#pullrefresh").on("tap", "li", function() {
		var chanceId = $(this).attr("chanceId");
		var customerId = $(this).attr("customerId");
		mui.openWindow({
			url: 'chancedetail.html',
			id: 'chancedetail',
			extras: {
				chanceId: chanceId,
				customerId: customerId,
				viewId: plus.webview.currentWebview().id,
				callbackFun: "conditionsQuery"
			}
		});
	});
});



/**
 * 上拉加载具体业务实现
 */
function pullupRefresh() {
	//console.log('上拉操作');
	setTimeout(function() {
		//业务逻辑代码，比如通过ajax从服务器获取新数据；
		var param = {
			"_clientType": "wap",
			"pageNo": currentPage++,
			"pageSize": pageSize,
			"expectedTime": mui("#expectedTime")[0].value,
			"sellStage": mui("#sellStage")[0].value,
			"customerId": mui("#customerId")[0].value,
			"subordinate": mui("#subordinate")[0].value,
			"userId": window.windowCommon.approveLoginId
		};
		//var url = window.windowCommon.basePath+"crm/chance/getSelectChanceList.c";
		_chanceApi._getSelectChanceList(param, function(data) {
			//上拉加载不清空
			/*if(clear){
				mui("#pullrefresh ul")[0].innerHTML = '';
				clear = false;
			}*/

			totalPage = data.totalPage;
			//console.log(JSON.stringify(data.list));
			mui.each(data.list, function(i, n) {
				var html = '<div class="shi-floor1">';
				html += '<span class="shi-ls">' + n.chanceName + '</span>';
				html += '<span class="shi-rsp">' + n.expectedTime + '</span>';
				html += '</div>';
				html += '<div class="shi-floor2 unit-ps">';
				html += '<em class="shi-two-img1"></em>';
				html += '<span class="shi-cn">' + n.customerName + '</span>';
				html += '</div>';
				html += '<div class="shi-floor3 unit-ps">';
				html += '<em class="shi-two-img"></em>';
				html += '<span class="shi-cn">' + n.chanceMoney + '</span>';
				html += '<span class="shi-rsp" style="color:#29b7ed !important;">' + n.sellStageName + '</span>';
				html += '</div>';

				var subli = document.createElement("li");
				subli.setAttribute("class", "mui-table-view-cell");
				subli.setAttribute("chanceId", n.chanceId);
				subli.setAttribute("customerId", n.customerId);
				subli.innerHTML = html;
				mui("#pullrefresh ul")[0].appendChild(subli);
			});
			//console.log('currentPage='+currentPage +', totalPage='+ totalPage);
			//currentPage在上面传参时，已经执行过++了。所以这里用>比较。
			if (currentPage > totalPage) {
				mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
			} else {
				mui('#pullrefresh').pullRefresh().endPullupToRefresh(false); //参数为true代表没有更多数据了。
			}
			
			if (totalPage <= 1) {
				if(totalPage==0){
					$(".listNoData").show();
				}
				mui('#pullrefresh').pullRefresh().disablePullupToRefresh();
			} 
		});
	}, 1500);
}

if (mui.os.plus) {
	mui.plusReady(function() {
		setTimeout(function() {
			mui('#pullrefresh').pullRefresh().pullupLoading();
		}, 100);
	});
} else {
	mui.ready(function() {
		mui('#pullrefresh').pullRefresh().pullupLoading();
	});
}

/* ================================================================================================= */



/**
 * 条件查询
 */
var conditionsQuery = function() {
	//console.log('条件查询');
	totalPage = 0;
	currentPage = 1;
	mui("#pullrefresh ul")[0].innerHTML = '';
	_enablePullUp();
	mui('#pullrefresh').pullRefresh().refresh(true);
	//clear = true;
	//pullupRefresh();
	//$("#list").html('');
	//mui('#pullrefresh').pullRefresh().refresh(true);
	mui('#pullrefresh').pullRefresh().pullupLoading();
}




/**
 * 添加销售机会的方法(打开添加销售机会的页面)
 */
var addchance = function() {
	mui.openWindow({
		url: 'chanceadd.html',
		id: 'chanceadd',
		extras: {
			viewId: plus.webview.currentWebview().id,
			callbackFun: "conditionsQuery"
		}
	});
}


/**
 * 初始化销售机会列表的查询条件
 */
var initSearch = function(callback) {
	//var url = window.windowCommon.basePath + 'crm/chance/initListSearch.c';

	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId
	};
	_chanceApi._initListSearch(data, function(response) {
		if (response.code == 1) {
			//console.log(JSON.stringify(response));
			loadMember();
			loadSellStage(response);
			loadExpectedTime(response);
			assignment();
		}
		if (callback != undefined && callback != null) {
			callback();
		}
	});
}

/**
 * 赋值
 */
var assignment = function() {
	mui.each(mui("#sellStageUL li"), function(i, n) {
		if (n.getAttribute("class").indexOf('month-active') != -1) {
			var name = n.getAttribute("name");
			if (name == 'null') {
				name = '';
			}
			document.getElementById("sellStage").value = name;
		}
	})

	mui.each(mui("#expectedTimeUL li"), function(i, n) {
		if (n.getAttribute("class").indexOf('month-active') != -1) {
			var name = n.getAttribute("name");
			if (name == 'null') {
				name = '';
			}
			document.getElementById("expectedTime").value = name;
		}
	})
}

/**
 * 加载成员
 */
var loadMember = function() {

	var subli01 = document.createElement("li");
	subli01.setAttribute("class", "mui-table-view-cell month-active");
	var name = window.windowCommon.approveLoginName;
	if (name == 'null') {
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
		mui('.top-nav-three a')[0].innerHTML = window.windowCommon.approveLoginName + '<em class="unit-filter-r1"></em>';
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
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "conditionsQuery",
				tourl: "../chance/mychance.html",
				toviewid: 'mychance'
			}
		});
	});

	var ul = mui("#popover2 ul")[0];
	ul.appendChild(subli01);
	ul.appendChild(subli02);
	ul.appendChild(subli03);
}

/**
 * 加载销售阶段
 * @param {Object} response
 */
var loadSellStage = function(response) {
	var sellStageULObj = document.getElementById("sellStageUL");
	sellStageULObj.innerHTML = '';

	var subli01 = document.createElement("li");
	subli01.setAttribute("class", "mui-table-view-cell month-active");
	subli01.setAttribute("name", '');
	subli01.innerHTML = '不限';
	sellStageULObj.appendChild(subli01);

	mui.each(response.dict, function(i, n) {
		var subli02 = document.createElement("li");
		subli02.setAttribute("class", "mui-table-view-cell");
		subli02.setAttribute("name", response.dict[i].value);
		subli02.innerHTML = response.dict[i].name;
		sellStageULObj.appendChild(subli02);
	});

	var lis = mui("#sellStageUL li");
	mui.each(lis, function(i, n) {
		lis[i].addEventListener("tap", function() {
			selectSellStage(lis[i]);
		});
	});
}


/**
 * 选择一个销售阶段
 * @param {Object} obj
 */
var selectSellStage = function(obj) {
	//修改样式
	var lis = mui("#sellStageUL li");
	mui.each(lis, function(i, n) {
		lis[i].setAttribute("class", "mui-table-view-cell");
	});
	obj.setAttribute("class", "mui-table-view-cell month-active");

	//赋值
	document.getElementById("sellStage").value = obj.getAttribute("name");

	//消失(通过初始化方法中的绑订来完成)
	//mui('#popover1').popover('toggle');

	//查询
	conditionsQuery();
}


/**
 * 加载成交时间
 * @param {Object} response
 */
var loadExpectedTime = function(response) {
	var sellStageULObj = document.getElementById("expectedTimeUL");
	sellStageULObj.innerHTML = '';

	var subli01 = document.createElement("li");
	subli01.setAttribute("class", "mui-table-view-cell month-active");
	subli01.setAttribute("name", '');
	subli01.innerHTML = '全部';
	sellStageULObj.appendChild(subli01);

	mui.each(response.systemtime.moremonth, function(i, n) {
		var subli02 = document.createElement("li");
		subli02.setAttribute("class", "mui-table-view-cell");
		subli02.setAttribute("name", response.systemtime.moremonth[i].value);
		subli02.innerHTML = response.systemtime.moremonth[i].name;
		sellStageULObj.appendChild(subli02);
	});

	var lis = mui("#expectedTimeUL li");
	mui.each(lis, function(i, n) {
		lis[i].addEventListener("tap", function() {
			selectExpectedTime(lis[i]);
		});
	});
}


/**
 * 选择一个成交时间
 * @param {Object} obj
 */
var selectExpectedTime = function(obj) {
	//修改样式
	var lis = mui("#expectedTimeUL li");
	mui.each(lis, function(i, n) {
		lis[i].setAttribute("class", "mui-table-view-cell");
	});
	obj.setAttribute("class", "mui-table-view-cell month-active");

	//赋值
	document.getElementById("expectedTime").value = obj.getAttribute("name");

	//消失(通过初始化方法中的绑订来完成)
	//mui('#popover1').popover('toggle');

	//查询
	conditionsQuery();
}