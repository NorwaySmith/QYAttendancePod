/**
 * 订单查询页面js
 */
var currentPage = 1;
var totalPage = 999;
var keyword = "";
var followerId = 0;
var subordinate = 0;

var viewId; //来源页面id
var callbackFun; //来源页面回调函数
var isNeedRefresh = 0; //是否需要刷新来源页面

function plusReady() {
	var self = plus.webview.currentWebview();
	if (self.userName) {
		$(".mui-title").html(self.userName + "的订单");
	}
	if (self.followerId) {
		followerId = self.followerId;
	}
	if (self.subordinate && self.subordinate == 1) {
		subordinate = 1;
		$(".mui-title").html("全部下属的订单");
	}
	viewId = self.viewId;
	callbackFun = self.callbackFun;

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
			if (viewId && callbackFun && isNeedRefresh) {
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun + "();");
			}
		}
	});
	//--------end

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

	//输入条件动态刷新列表
	document.getElementById("keyword").addEventListener("input", function() {
		keyword = $("#keyword").val();
		currentPage = 1;
		totalPage = 999;
		$("#list").html('');
		_enablePullUp();
		mui('#pullrefresh').pullRefresh().refresh(true);
		mui('#pullrefresh').pullRefresh().pullupLoading();
	}, false);
	//--------end

	//单击跳转到详情
	mui("#list").on('tap', "li", function() {
		mui.openWindow({
			url: 'orderDetail.html',
			id: 'orderDetail',
			extras: {
				orderId: $(this).attr("val"),
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshData"
			} //额外扩展参数
		});
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
			param.userId = window.windowCommon.approveLoginId;
			param.keyword = $.trim(keyword);
			param.subordinate = subordinate;
			param.currentPage = currentPage;
			param.followerId = followerId;
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

/**
 * 刷新子页面数据
 */
function refreshChildData() {
	currentPage = 1;
	totalPage = 999;
	$("#list").html('');
	_enablePullUp();
	mui('#pullrefresh').pullRefresh().pullupLoading();
}

/**
 * 刷新数据并标记父页面刷新状态
 */
function refreshData() {
	isNeedRefresh = 1;
	refreshChildData();
}