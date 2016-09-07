/**
 * 跟进人页面js
 */
var currentPage = 1;
var totalPage = 999;
var keyword = "";
var tourl = '';
var viewid = 'toChoosedUser';

var viewId; //来源页面id
var callbackFun; //来源页面回调函数

function plusReady() {

	mui.init({
		pullRefresh: {
			container: "#pullrefresh", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
			up: {
				contentrefresh: "正在加载...", //可选，正在加载状态时，上拉加载控件上显示的标题内容
				contentnomore: '没有更多数据了', //可选，请求完毕若没有更多数据时显示的提醒内容；
				callback: pullupRefresh //必选，刷新函数，根据具体业务来编写，比如通过ajax从服务器获取新数据；
			}
		}
	});
	tourl = plus.webview.currentWebview().tourl;
	viewId = plus.webview.currentWebview().viewId;
	callbackFun = plus.webview.currentWebview().callbackFun;
	if (plus.webview.currentWebview().toviewid != undefined && plus.webview.currentWebview().toviewid != null && plus.webview.currentWebview().toviewid != '') {
		viewid = plus.webview.currentWebview().toviewid;
	}

	//单击人员跳转到相关页面
	mui("#list").on('tap', "li", function() {
		mui.openWindow({
			url: tourl,
			id: viewid,
			extras: {
				viewId: viewId,
				callbackFun: callbackFun,
				followerId: $(this).attr("val1"),
				userName: $(this).attr("val2")
			}
		});
	});

	document.getElementById("keyword").addEventListener("input", function() {
		//关键字搜索去除前后空格。
		keyword = $.trim($("#keyword").val());
		currentPage = 1;
		totalPage = 999;
		$("#list").html('');
		_enablePullUp();
		mui('#pullrefresh').pullRefresh().refresh(true);
		mui('#pullrefresh').pullRefresh().pullupLoading();
	}, false);
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
			var param = {
				"_clientType": "wap",
				"pageNo": currentPage,
				"pageSize": 10,
				"keyword": keyword,
				"userId": window.windowCommon.approveLoginId
			};
			_crmUserApi._getSelectFollowerList(param, function(data) {

				totalPage = data.totalPage;

				$.each(data.list, function(i, item) {
					var html = '<li class="mui-table-view-cell" val1="' + item.userId + '" val2="' + item.userName + '">';
					html += '<a class="mui-navigate-right">';
					html += '	<img src="' + window.windowCommon.photoUrl + item.photo + '" title="' + item.userName + '" onerror="headError(this);" />';
					html += '	<div class="top_text">';
					html += '		<span class="pn2">' + item.userName + '</span>';
					html += '	</div>';
					html += '	<span class="cn2">' + item.telphone + '</span>';
					html += '</a>';
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