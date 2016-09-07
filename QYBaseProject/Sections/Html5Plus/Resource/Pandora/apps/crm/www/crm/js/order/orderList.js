/**
 * 订单列表js
 */
var keyword = "";
var state;
var subordinate = 0;
var customerId;
var currentPage = 1;
var totalPage = 999;

var addOrder = function() {
		mui.openWindow({
			url: 'orderAdd.html',
			id: 'orderAdd'
		});
	}
	/**
	 * 刷新子页面数据
	 */

function refreshChildData() {
		currentPage = 1;
		totalPage = 999;
		$("#list").html('');
		mui('#pullrefresh').pullRefresh().pullupLoading();
	}
	//页面加载完毕方法

function plusReady() {
	//显示当前登录用户姓名
	$("#toPopover2").find("font").html(window.windowCommon.approveLoginName);
	$("#myName").html(window.windowCommon.approveLoginName);
	//初始化
	mui.init({
		pullRefresh: {
			container: "#pullrefresh", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
			up: {
				contentrefresh: "正在加载...", //可选，正在加载状态时，上拉加载控件上显示的标题内容
				contentnomore: '没有更多数据了', //可选，请求完毕若没有更多数据时显示的提醒内容；
				callback: pullupRefresh //必选，刷新函数，根据具体业务来编写，比如通过ajax从服务器获取新数据；
			}
		},
		beforeback: function() {
			plus.webview.getWebviewById(plus.webview.currentWebview().indexId).evalJS(plus.webview.currentWebview().callbackFun);
		}
	});
	//绑订新增方法
	document.getElementById("addOrder").addEventListener('tap', function() {
		mui('#popover1').popover('hide');
		mui('#popover2').popover('hide');
		addOrder();
	});

	//点击订单状态
	mui("#orderState")[0].addEventListener('tap', function() {
		mui("#popover1").popover('toggle');
	});
	//点击我
	mui("#toPopover2")[0].addEventListener('tap', function() {
		mui("#popover2").popover('toggle');
	});
	//点击搜索
	document.getElementById("search").addEventListener('tap', function() {
		mui('#popover1').popover('hide');
		mui('#popover2').popover('hide');
		mui.openWindow({
			url: 'orderSearch.html',
			id: 'orderSearch',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData",
				subordinate: $("#searchFollow").val()
			}
		});
	});

	//单击跳转到详情
	mui("#list").on('tap', "li", function() {
		mui.openWindow({
			url: 'orderDetail.html',
			id: 'orderDetail',
			extras: {
				orderId: $(this).attr("val"),
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData"
			} //额外扩展参数
		});
	});

	//选中订单状态
	$("#popover1 li").click(function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		mui("#popover1").popover('toggle');
		state = $(this).attr("val");
		$("#orderState").html($(this).text() + '<em class="unit-filter-rt1"></em>');
		refreshChildData();
	});
	//点击姓名
	$("#myName").click(function() {
		$(this).siblings("li").removeClass("month-active");
		$(this).addClass("month-active");
		$("#toPopover2").find("font").html(window.windowCommon.approveLoginName);
		mui("#popover2").popover('toggle');
		subordinate = 0;
		$("#searchFollow").val(0);
		refreshChildData();
	});
	//点击全部下属
	$("#myDown").click(function() {
		$(this).siblings("li").removeClass("month-active");
		$(this).addClass("month-active");
		$("#toPopover2").find("font").html("全部下属");
		mui("#popover2").popover('toggle');
		subordinate = 1;
		$("#searchFollow").val(1)
		refreshChildData();
	});
	//点击单个下属
	$("#simpleChild").click(function() {
		mui("#popover2").popover('toggle');
		mui.openWindow({
			url: '../user/selectFollower.html',
			id: 'chooseFollowerForOrderList',
			extras: {
				tourl: "../order/orderSearch.html",
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData"
			}
		});
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
}
if (window.plus) {
	plusReady();
} else {
	document.addEventListener('plusready', plusReady, false);
}

function pullupRefresh() {
		if (currentPage > totalPage) {
			mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
		} else {
			//业务逻辑代码，比如通过ajax从服务器获取新数据；
			setTimeout(function() {
				var param = {};
				param.customerId = customerId;
				param.userId = window.windowCommon.approveLoginId;
				param.keyword = keyword;
				param.state = state;
				param.subordinate = subordinate;
				param.currentPage = currentPage;
				orderAPI.getOrderList(param, function(data) {
					totalPage = data.totalPage;
					$.each(data.aaData, function(i, item) {
						var html = '<li class="mui-table-view-cell" val="' + item.orderId + '">';
						html += '<span class="public-span w60 bgtext beblock fl">';
						html += item.orderName;
						html += '</span>';
						switch (item.state) {
							case 0:
								html += '<span class="shi-rt">执行前';
								break;
							case 1:
								html += '<span class="shi-rt1">执行中';
								break;
							case 2:
								html += '<span class="shi-rt2">结束';
								break;
							case 3:
								html += '<span class="shi-rt3">意外中止';
								break;
						}
						html += '</span>';
						html += ' </li>';
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
			}, 500);
		}
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