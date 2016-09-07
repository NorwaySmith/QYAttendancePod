/**
 * 联系记录页面js
 */
var currentPage = 0;
var totalPage = 999;
var searchFollower = "0"; //是否搜索全部下属
var yearmo = ""; //年月（2015-09）
var tian = ""; //天(30)

/**
 * 页面加载完毕初始化数据
 */
function plusReady() {
	//绑定页面上拉加载数据
	mui.init({
		swipeBack: true, //启用右滑关闭功能
		pullRefresh: {
			container: "#pullrefresh", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
			up: {
				contentrefresh: "正在加载...", //可选，正在加载状态时，上拉加载控件上显示的标题内容
				contentnomore: '没有更多数据了', //可选，请求完毕若没有更多数据时显示的提醒内容；
				callback: pullupRefresh //必选，刷新函数，根据具体业务来编写，比如通过ajax从服务器获取新数据；
			}
		}
	});

	mui('.mui-scroll-wrapper1').scroll();

	$("#toPopover2").find("font").html(window.windowCommon.approveLoginName);
	$("#myName").html(window.windowCommon.approveLoginName);

	//绑定新增拜访记录事件
	mui("#addvisit")[0].addEventListener('tap', function() {
		mui('#popover1').popover('hide');
		mui('#popover2').popover('hide');
		mui('#popover3').popover('hide');
		mui.openWindow({
			url: 'addvisit.html',
			id: 'addvisit',
			extras: {
				'fromType': 1, ////页面来源（1 [来自列表]   2 [来自往来单位详情]    3[来自机会详情]）
				'visitType': 1, ////拜访类型 (1现场拜访 2沟通联系)
				'customerId': '', //单位ID
				'chanceId': '', //机会ID
				"webViewId": "visitrecordList", //新增成功后调用那个页面
				"webViewFunction": "refreshChildData" //新增成功后调用那个页面的那个方法
			}
		});
	});

	//初始化年月日条件筛选
	initDateFilter();

	//绑定年月份点击事件
	$("#fullYear").click(function() {
		mui("#popover3").popover("toggle");
	});

	//绑定日点击事件
	$("#fullMouth").click(function() {
		mui("#popover1").popover("toggle");
	});

	//绑定选择下属点击事件
	$("#toPopover2").click(function() {
		mui("#popover2").popover("toggle");
	});

	//绑定删除事件
	$("#list").on("tap",".sale-new-del",function(){
		var visitdetailId = $(this).attr("visitdetailId");
		del(visitdetailId);
	});

	//绑定点赞事件
	$("#list").on("tap",".good",function(){
		delPraise(this);
	});
	
	//绑定取消点赞事件
	$("#list").on("tap",".nogood",function(){
		praise(this);
	});
	
	//绑定展开评论区域div事件
	$("#list").on("tap",".comment",function(){
		if($(this).parent().siblings(".shi-comment")){
			$(this).parent().siblings(".shi-comment").toggle();
		}
	});

	//选中当前登录人
	mui("#myName")[0].addEventListener('click', function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		searchFollower = 0; //选中当前登录人
		$("#toPopover2").find("font").html(window.windowCommon.approveLoginName);
		mui('#popover2').popover('toggle');
		refreshChildData(); //刷新子页面数据
	});

	//选中全部下属
	mui("#allFollower")[0].addEventListener('click', function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		searchFollower = 1; //选择全部下属
		$("#toPopover2").find("font").html('全部下属');
		mui('#popover2').popover('toggle');
		refreshChildData(); //刷新子页面数据
	});

	//单击选择单个成员
	mui("#chooseFollower")[0].addEventListener('tap', function() {
		mui("#popover2").popover("toggle");
		mui.openWindow({
			url: '../user/selectFollower.html',
			id: 'chooseFollowerForCustomer',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData",
				tourl: "../visit/searchVisitRecord.html"
			}
		});
	});
	
	//绑定选择月份事件
	$("#expectedTimeUL").on("click", "li", function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		mui("#popover3").popover("toggle");
		$("#fullYear").find("font").html($(this).html());
		var y = $(this).attr("name");
		var a = y.split("-");
		var datesize = getDaysInMonth(a[1], a[0]);

		//重绘日期选择
		$("#expectedDataUL").html('');
		$("#expectedDataUL").append('<li class="mui-table-view-cell month-active">全月</li>');
		for (var q = 1; q <= datesize; q++) {
			$("#expectedDataUL").append('<li class="mui-table-view-cell" name="' + q + '">' + q + '日</li>');
		}
		if ($(this).attr("name")) {
			yearmo = $(this).attr("name");
		} else {
			yearmo = "";
		}

		//重置天
		$("#fullMouth").find("font").html("全月");
		tian = "";
		refreshChildData(); //刷新子页面数据
	});

	//绑定选择日期事件
	$("#expectedDataUL").on("click", "li", function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		mui('#popover1').popover('toggle');
		$("#fullMouth").find("font").html($(this).html());
		if ($(this).attr("name")) {
			if ($(this).attr("name") < 10) {
				tian = yearmo + "-" + "0" + $(this).attr("name");
			} else {
				tian = yearmo + "-" + $(this).attr("name");
			}
		}
		refreshChildData(); //刷新子页面数据
	});

	//绑定进入详情事件
	$("#list").on("tap", "ul.content-list", function() {
		mui.openWindow({
			url: 'visitdetail.html',
			id: 'visitdetail',
			extras: {
				visitdetailId: $(this).parents("ul.log").attr("val"),
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData"
			}
		});
	});
}

/**
 * 刷新子页面数据
 */
function refreshChildData() {
	currentPage = 0;
	totalPage = 999;
	$("#list").html('');
	_enablePullUp();
	mui('#pullrefresh').pullRefresh().refresh(true);
	mui('#pullrefresh').pullRefresh().pullupLoading();
}


/**
 * 上拉刷新
 */
function pullupRefresh() {
	if (currentPage > totalPage) {
		mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
	} else {
		//业务逻辑代码，比如通过ajax从服务器获取新数据；
		var param = {
			"_clientType": "wap",
			"pageNo": currentPage,
			"pageSize": 5,
			"visitDate": "",
			"searchFollower": searchFollower,
			"userId": window.windowCommon.approveLoginId
		}

		if (yearmo && !tian) {
			param.visitDate = yearmo;
		}

		if (tian) {
			param.visitDate = tian;
		}
		visitApi.visitList(param, function(data) {
			currentPage++;
			var jsonData = JSON.parse(data);
			var jsonDataList = jsonData.list;
			totalPage = jsonData.totalPage;
			if (jsonDataList && jsonDataList.length > 0) {
				for (var i = 0; i <= jsonDataList.length - 1; i++) {
					var visitdetailId = jsonDataList[i].visitdetailId;
					var html = '<ul class="mui-table-view log" val="' + visitdetailId + '">';
					html += '	<li class="mui-table-view-cell shi-time unit-ps">';
					html += '		<em class="time-ico"></em>';
					html += '		<span>' + jsonDataList[i].visitTime + '</span>';
					html += '	</li>';
					html += '<li class="mui-table-view-cell mui-media log-user">';
					html += '<img class="mui-pull-left shi-ppic" src="' + window.windowCommon.photoUrl + jsonDataList[i].createUserPhoto + '" title="' + jsonDataList[i].createUserName + '" onerror="headError(this);">';
					html += '<div class="mui-media-body">';
					html += '' + jsonDataList[i].createUserName + '';
					html += '</div>';
					html += '</li>';
					html += '<div class="content" id="xq">';
					html += '<ul class="content-list" id="list1">';
					html += '<li class="mui-ellipsis-2">';
					if (jsonDataList[i].visitType == 1) {
						html += '<span class="shi-tit">现场拜访：</span><p class="shi-txt">' + jsonDataList[i].visitPoistion + '</p>';
					} else if (jsonDataList[i].visitType == 2) {
						html += '<span class="shi-tit">沟通对象：</span><p class="shi-txt"><span class="public-span1 w40 cttext">' + jsonDataList[i].communicationUserName + '</span><span class="centre-text">（' + jsonDataList[i].communicationModeName + '沟通）</span>' + '</p>';
					}
					html += '</li>';
					
					html += '<li class="mui-ellipsis-2">';
					if (jsonDataList[i].visitType == 1) {
						html += '<span class="shi-tit">拜访单位：</span><p class="shi-txt">' + jsonDataList[i].customerName + '</p>';
					} else if (jsonDataList[i].visitType == 2) {
						html += '<span class="shi-tit">联系单位：</span><p class="shi-txt">' + jsonDataList[i].customerName + '</p>';
					}
					html += '</li>';
					
					html += '<li class="mui-ellipsis-2">';
					html += '<span class="shi-tit">沟通内容：</span><p class="shi-txt">' + jsonDataList[i].visitContent + '</p> ';
					html += '</li>';
					html += '<li class="mui-ellipsis-2">';
					html += '<span class="shi-tit">双方异议：</span><p class="shi-txt">' + jsonDataList[i].visitDiffence + '</p> ';
					html += '</li>';
					html += '<li class="mui-ellipsis-2">';
					html += '<span class="shi-tit shi-txt-active">下次沟通：</span><p class="shi-txt shi-txt-active">' + jsonDataList[i].nextVisitTime + '</p> ';
					html += '</li>';
					html += '<li class="mui-ellipsis-2">';
					html += '<span class="shi-tit shi-txt-active">跟进要点：</span><p class="shi-txt shi-txt-active">' + jsonDataList[i].nextVisitMaincontent + '</p> ';
					html += '</li>';
					html += '</ul>';

					//绑定按钮域
					html += '<div class="operate">';
					html += '<a class="sale-new-del unit-ps" visitdetailId="' + visitdetailId + '" ><em class="sale-del"></em>删除</a>';
					var visitRecord = jsonDataList[i].visitRecordCommentList;
					if (visitRecord.length > 0) {
						html += '<a href="javascript:void(0);" class="comment mui-pull-right"><em>' + visitRecord.length + '</em></a>';
					} else {
						html += '<a href="javascript:void(0);" class="comment mui-pull-right"><em></em></a>';
					}
					
					if (jsonDataList[i].isPraise == 1) {
						html += '<a href="javascript:void(0);" class="good mui-pull-right" visitdetailId="' + visitdetailId + '">';
					} else {
						html += '<a href="javascript:void(0);" class="nogood mui-pull-right" visitdetailId="' + visitdetailId + '">';
					}
					if (jsonDataList[i].praiseCount > 0) {
						html += '<em>' + jsonDataList[i].praiseCount + '</em></a>';
					} else {
						html += '<em class="remind"></em></a>';
					}
					html += '</div>';


					var visitRecordCommentList = jsonDataList[i].visitRecordCommentList;
					if (visitRecordCommentList.length > 0) {
						for (var k = 0; k <= visitRecordCommentList.length - 1; k++) {
							html += '<ul class="shi-comment" style="display:none">';
							html += '<li>';
							html += '<div class="shi-visit-reply">';
							html += '<a class="shi-nm">' + visitRecordCommentList[k].userName + '</a><a class="shi-data">' + visitRecordCommentList[k].createTime + '</a>';
							html += '</div>';
							html += '<a class="shi-ly">' + visitRecordCommentList[k].content + '</a>';
							html += '</li>';
							html += '</ul>';
						}
					}
					html += '</div>';
					html += '</ul>';
					$("#list").append(html);
				}
				if (currentPage >= totalPage) {
					mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
				} else {
					mui('#pullrefresh').pullRefresh().endPullupToRefresh(false); //参数为true代表没有更多数据了。
				}
				
			} else {
				mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
			}
			
			if (totalPage <= 1) {
				if (totalPage == 0) {
					$(".listNoData").show();
				}
				mui('#pullrefresh').pullRefresh().disablePullupToRefresh();
			}

		})


	}
}


/**
 * 获取每个月的天数
 * @param {Object} month
 * @param {Object} year
 */
function getDaysInMonth(month, year) {
	var days;
	if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) days = 31;
	else if (month == 4 || month == 6 || month == 9 || month == 11) days = 30;
	else if (month == 2) {
		days = 28;
	}
	return (days);
}

/**
 * 初始化年月日条件筛选
 */
function initDateFilter() {
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId
	}
	visitApi.initListVisit(param, function(data) {
		var data1 = JSON.parse(data);
		var sellStageULObj = document.getElementById("expectedTimeUL");
		sellStageULObj.innerHTML = '';
		var subli01 = document.createElement("li");
		subli01.setAttribute("class", "mui-table-view-cell month-active");
		subli01.setAttribute("name", '');
		subli01.innerHTML = "全部";
		sellStageULObj.appendChild(subli01);
		mui.each(data1.systemtime.moremonth, function(i, n) {
			var subli02 = document.createElement("li");
			subli02.setAttribute("class", "mui-table-view-cell");
			subli02.setAttribute("name", data1.systemtime.moremonth[i].value);
			subli02.innerHTML = data1.systemtime.moremonth[i].name;
			sellStageULObj.appendChild(subli02);
		});
	}, function() {

	});

}



if (window.plus) {
	plusReady();
} else {
	document.addEventListener('plusready', plusReady, false);
}

//进入页面加载第一页
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