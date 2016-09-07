/**
 * 往来单位列表页面js
 */
var currentPage = 1;
var totalPage = 999;
var searchFollower = 0; //是否是查询所有下属 0否 1是
var customerOwner = 0; //客户归属
var customerLevel = 0; //客户等级
var customerState = 0; //客户状态


//页面加载完毕方法
function plusReady() {
	//默认当前登录人选中
	$("#toPopover2").find("font").html(window.windowCommon.approveLoginName);
	$("#myName").html(window.windowCommon.approveLoginName);

	//初始化客户数据字典
	initCustomerDict();

	mui.init({
		swipeBack: true, //启用右滑关闭功能
		pullRefresh: {
			container: "#pullrefresh", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
			up: {
				contentrefresh: "正在加载...", //可选，正在加载状态时，上拉加载控件上显示的标题内容
				contentnomore: '没有更多数据了', //可选，请求完毕若没有更多数据时显示的提醒内容；
				callback: pullupRefresh //必选，刷新函数，根据具体业务来编写，比如通过ajax从服务器获取新数据；
			}
		},
		beforeback: function() {
			mui('#popover1').popover('hide');
			mui('#popover2').popover('hide');
			plus.webview.getWebviewById(plus.webview.currentWebview().indexId).evalJS(plus.webview.currentWebview().callbackFun);
		}
	});

	// 隐藏滚动条
	//plus.webview.currentWebview().setStyle({scrollIndicator:'none'});
	var contentWebview = null;
	document.querySelector('header').addEventListener('doubletap', function() {
		if (contentWebview == null) {
			contentWebview = plus.webview.currentWebview().children()[0];
		}
		if (mui.os.ios) {
			contentWebview.evalJS("mui('#pullrefresh').pullRefresh().scrollTo(0,0,100)");
		} else {
			contentWebview.evalJS('mui.scrollTo(0, 100)');
		}
	});

	$(".unit-pop-left").on("tap", "span", function() {
		$(this).siblings().removeClass("unit-focus");
		$(this).addClass("unit-focus");
		var index = $(this).index();
		$(".unit-pop-right").eq(index).show();
		$(".unit-pop-right").eq(index).siblings('.unit-pop-right').hide();
	})

	//新增按钮 绑定方法
	mui("#toAdd")[0].addEventListener('tap', function() {
		mui('#popover1').popover('hide');
		mui('#popover2').popover('hide');
		mui.openWindow({
			url: 'addCustomer.html',
			id: 'addCustomer',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData"
		}
		});
	});

	//新增按钮 绑定方法
	mui("#toSearch")[0].addEventListener('tap', function() {
		mui('#popover1').popover('hide');
		mui('#popover2').popover('hide');
		mui.openWindow({
			url: 'searchCustomer.html',
			id: 'searchCustomer',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData",
				userName: window.windowCommon.approveLoginName,
				searchFollower: searchFollower
			}
		});
	});

	//单击跳转到详情
	mui("#list").on('tap', "li", function() {
		mui.openWindow({
			url: 'customerDetail.html',
			id: 'customerDetail',
			extras: {
				customerId: $(this).attr("val"),
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData"
			} //额外扩展参数
		});
	});


	//单击条件筛选
	mui("#toPopover1")[0].addEventListener('tap', function() {
		mui("#popover1").popover('toggle');
	});

	//单击名字筛选
	mui("#toPopover2")[0].addEventListener('tap', function() {
		mui("#popover2").popover('toggle');
	});

	//单击人员选择条件自动关闭选择框
	mui("#popover2").on('tap', "li", function() {
		mui("#popover2").popover('toggle');
	});

	//单击筛选条件子项
	mui("#popover1 .unit-pop-right").on('tap', "span", function() {
		$(this).siblings().removeClass("unit-focus unit-focusright");
		$(this).addClass("unit-focus unit-focusright");
	});

	//单击重置
	mui("#resetType")[0].addEventListener('tap', function() {
		resetType();
	});

	//单击确定
	mui("#confirmType")[0].addEventListener('tap', function() {
		mui("#popover1").popover('toggle'); //关闭条件框
		applyType();
	});

	//选中当前登录人
	mui("#myName")[0].addEventListener('tap', function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		searchFollower = 0; //选中当前登录人
		$("#toPopover2").find("font").html(window.windowCommon.approveLoginName);
		refreshChildData(); //刷新子页面数据
	});

	//选中全部下属
	mui("#allFollower")[0].addEventListener('tap', function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		searchFollower = 1; //选择全部下属
		$("#toPopover2").find("font").html('全部下属');
		refreshChildData(); //刷新子页面数据
	});

	//单击选择单个成员
	mui("#chooseFollower")[0].addEventListener('tap', function() {
		mui.openWindow({
			url: '../user/selectFollower.html',
			id: 'chooseFollowerForCustomer',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData",
				tourl: "../customer/searchCustomer.html"
			}
		});
	});

}

//初始化新增页面数据字典
function initCustomerDict() {
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId
	};
	_customerApi._getCustomerDict(param, function(data) {
		printDict(data.customerLevel, 'selectCustomerLevel');
		printDict(data.customerState, 'selectCustomerState');
	});
}

/**
 * 绘制条件筛选
 * @param {Object} list
 * @param {Object} id
 */
function printDict(list, id) {
	$.each(list, function(i, item) {
		var html = '';
		html += '<span val="' + item.value + '">' + item.name + '</span>';
		$("#" + id).find("div.mui-scroll").append(html);
	});
}

/**
 * 重置状态
 */
function resetType() {
	$("#selectCustomerOwner").find("span").removeClass("unit-focus unit-focusright");
	$("#selectCustomerLevel").find("span").removeClass("unit-focus unit-focusright");
	$("#selectCustomerState").find("span").removeClass("unit-focus unit-focusright");

	$("#selectCustomerOwner").find("span").eq(0).addClass("unit-focus unit-focusright");
	$("#selectCustomerLevel").find("span").eq(0).addClass("unit-focus unit-focusright");
	$("#selectCustomerState").find("span").eq(0).addClass("unit-focus unit-focusright");
}

/**
 * 将用户选中的内容转换为条件进行查询
 */
function applyType() {
	customerOwner = $("#selectCustomerOwner").find("span.unit-focus").attr("val"); //客户归属
	customerLevel = $("#selectCustomerLevel").find("span.unit-focus").attr("val"); //客户等级
	customerState = $("#selectCustomerState").find("span.unit-focus").attr("val"); //客户状态
	refreshChildData();
}

/**
 * 刷新子页面数据
 */
function refreshChildData() {
	currentPage = 1;
	totalPage = 999;
	$("#list").html('');
	_enablePullUp();
	mui('#pullrefresh').pullRefresh().refresh(true);
	mui('#pullrefresh').pullRefresh().pullupLoading();
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


function pullupRefresh() {
	if (currentPage > totalPage) {
		mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
	} else {
		//业务逻辑代码，比如通过ajax从服务器获取新数据；
		setTimeout(function() {
			var param = {
				"_clientType": "wap",
				"pageNo": currentPage,
				"pageSize": 10,
				"searchFollower": searchFollower,
				"customerOwner": customerOwner,
				"level": customerLevel,
				"state": customerState,
				"userId": window.windowCommon.approveLoginId
			};
			_customerApi._getCustomerList(param, function(data) {

				totalPage = data.totalPage;
				$.each(data.list, function(i, item) {
					var html = '<li class="mui-table-view-cell" val="' + item.customerId + '">';
					html += '<a class="">';
					html += '<div class="top_text">';
					if (item.isFollow == '1') {
						html += '<span class="qb"></span>';
					}
					html += '<span class="pn">' + item.customerName + '</span>';
					html += '</div>';
					html += '<span class="cn">' + item.customerLocation + '</span>';
					html += '<span class="hb">' + item.customerState + '</span>';
					if (item.customerLevel != '') {
						html += '<span class="hb1">' + item.customerLevel + '</span>';
					}
					html += '</a>';
					html += '</li>';
					$("#list").append(html);
				});

				currentPage++;
				if (currentPage > totalPage) {
					mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
				} else {
					mui('#pullrefresh').pullRefresh().endPullupToRefresh(false); //参数为true代表没有更多数据了。
				}

				if (totalPage <= 1) {
					if (totalPage == 0) {
						$(".listNoData").show();
					}
					mui('#pullrefresh').pullRefresh().disablePullupToRefresh();
				}

			});
		}, 200);
	}
}