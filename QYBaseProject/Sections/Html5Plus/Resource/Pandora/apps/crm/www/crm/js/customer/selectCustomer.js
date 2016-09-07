/**
 * 往来单位选择页面js
 */
var currentPage = 1;
var totalPage = 999;
var keyword = "";

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
	//--------end

	//输入条件动态刷新列表
	document.getElementById("keyword").addEventListener("input", function() {
		//去除前后空格
		keyword = $.trim($("#keyword").val());
		currentPage = 1;
		totalPage = 999;
		$("#list").html('');
		_enablePullUp();
		mui('#pullrefresh').pullRefresh().refresh(true);
		mui('#pullrefresh').pullRefresh().pullupLoading();
	}, false);
	//--------end

	$("#list").on("tap", "li", function() {
		$("#keyword").blur();
		var id = $(this).attr('val');
		var name = $(this).attr('vName');
		plus.webview.getWebviewById(plus.webview.currentWebview().viewid)
			.evalJS(plus.webview.currentWebview().tapone + "(['" + id + "', '" + name + "']);");
	});
	//新增往来单位
	//新增按钮 绑定方法
	mui("#toAdd")[0].addEventListener('tap', function() {
		mui('#popover1').popover('hide');
		mui('#popover2').popover('hide');
		mui.openWindow({
			url: '../customer/addCustomer.html',
			id: 'addCustomer',
			extras: {
			viewId: plus.webview.currentWebview().id,
			callbackFun: "refreshChildData"
		}
		});
	});
}


if (window.plus) {
	plusReady();
} else {
	document.addEventListener('plusready', plusReady, false);
}

/**
 * 上拉刷新
 */
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
			_customerApi._getSelectCustomerList(param, function(data) {

				totalPage = data.totalPage;
				$.each(data.list, function(i, item) {
					//console.log(JSON.stringify(item));
					//console.log(item.customerId);
					var html = '<li class="mui-table-view-cell" vName="' + item.customerName + '" val="' + item.customerId + '">';
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
	mui('#pullrefresh').pullRefresh().refresh(true);
	mui('#pullrefresh').pullRefresh().pullupLoading();
}