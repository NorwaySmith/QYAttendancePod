/**
 * 单个下属的机会列表页面js
 */
var currentPage = 1;
var pageSize = 10;
var totalPage = 999;
//var clear = false;

var viewId; //来源页面id
var callbackFun; //来源页面回调函数
var isNeedRefresh = 0; //是否需要刷新来源页面

function plusReady() {
	mui('.mui-title')[0].innerHTML = plus.webview.currentWebview().userName + '的销售机会';
	//得到父页面的参数信息
	var self = plus.webview.currentWebview();
	viewId = self.viewId;
	callbackFun = self.callbackFun;

	mui.init({
		pullRefresh: {
			container: '#pullrefresh',
			up: {
				contentrefresh: '正在加载...',
				callback: pullupRefresh
			}
		},
		beforeback: function() {
			if(viewId && callbackFun && isNeedRefresh){
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun+"();");
			}
		}
	});

	//绑订输入框的键盘事件
	document.getElementById("keyword").addEventListener("input", function() {
		conditionsQuery();
	}, false);

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
				callbackFun: "refreshData"
			}
		});
	});
}


/**
 * 下拉刷新具体业务实现
 */
function pulldownRefresh() {
	setTimeout(function() {
		mui('#pullrefresh').pullRefresh().endPulldownToRefresh(); //refresh completed
	}, 1500);
}

var count = 0;
/**
 * 上拉加载具体业务实现
 */
function pullupRefresh() {
	//console.log('上拉操作');
	var keyword = document.getElementById("keyword").value;
	keyword = trim(keyword, ' ') == undefined ? '' : trim(keyword, ' ');
	//console.log('keyword=['+keyword+'], type='+typeof keyword);
	setTimeout(function() {
		//业务逻辑代码，比如通过ajax从服务器获取新数据；
		var param = {
			"_clientType": "wap",
			"pageNo": currentPage++,
			"pageSize": pageSize,
			"userId": window.windowCommon.approveLoginId,
			"subordinate": 0,
			"follower": plus.webview.currentWebview().followerId,
			"keyword": keyword
		};
		//var url = window.windowCommon.basePath+"crm/chance/getSelectChanceList.c";
		_chanceApi._getSelectChanceList(param, function(data) {
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
	}, 150);
}

if (mui.os.plus) {
	mui.plusReady(function() {
		plusReady();
		setTimeout(function() {
			mui('#pullrefresh').pullRefresh().pullupLoading();
		}, 100);
	});
} else {
	mui.ready(function() {
		plusReady();
		mui('#pullrefresh').pullRefresh().pullupLoading();
	});
}

/* ================================================================================================= */

/**
 * 条件查询
 */
var conditionsQuery = function() {
	currentPage = 1;
	totalPage = 999;
	mui("#pullrefresh ul")[0].innerHTML = '';
	_enablePullUp();
	mui('#pullrefresh').pullRefresh().refresh(true);
	mui('#pullrefresh').pullRefresh().pullupLoading();
}

//刷新列表并修改父页面更新
function refreshData(){
	isNeedRefresh=1;
	conditionsQuery();
}
