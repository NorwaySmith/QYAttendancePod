/**
 * 联系人搜索页面js
 */
var currentPage = 0;
var totalPage = 999;
var keyword = "";
var isEnd = false;
var followerId = '';
var searchFollower = 0; //是否是查询所有下属 0否 1是

var viewId; //来源页面id
var callbackFun; //来源页面回调函数
var isNeedRefresh = 0; //是否需要刷新来源页面

function plusReady() {
	var self = plus.webview.currentWebview();
	followerId = self.followerId;
	viewId = self.viewId;
	callbackFun = self.callbackFun;

	if (self.userName) {
		$(".mui-title").html(self.userName + "的联系人");
	}
	if (self.searchFollower) {
		searchFollower = 1; //搜索全部下属
		$(".mui-title").html("全部下属的联系人");
	}

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
		keyword = $.trim($("#keyword").val());
		refreshChildData();
	}, false);

}

if (window.plus) {
	plusReady();
} else {
	document.addEventListener('plusready', plusReady, false);
}

/**
 * 刷新子页面数据
 */
function refreshChildData() {
	currentPage = 0;
	totalPage = 999;
	setTimeout(function() {
		$("#aa").html('');
		_enablePullUp();
		mui('#pullrefresh').pullRefresh().refresh(true);
		mui('#pullrefresh').pullRefresh().pullupLoading();
	}, 200);
}

//刷新列表数据并修改父页面更新状态
function refreshData() {
	isNeedRefresh = 1;
	refreshChildData();
}
/**
 * 下拉刷新列表
 */
function pulldownRefresh() {
	currentPage = 0;
	//业务逻辑代码，比如通过ajax从服务器获取新数据；
	setTimeout(function() {
		var param = {
			"_clientType": "wap",
			"pageNo": currentPage,
			"pageSize": 10,
			"userName": keyword,
			"followerId": followerId,
			"subordinate": searchFollower,
			"userId": window.windowCommon.approveLoginId
		}
		contactApi.getList(param, function(data) {

			currentPage++;
			var table = document.body.querySelector('#aa');
			$("#aa").html('');
			var jsonData = JSON.parse(data);
			totalPage = jsonData.totalPage;
			var jsonList = jsonData.list;
			for (var i = 0; i < jsonList.length; i++) {
				var custom = "";
				if (jsonList[i].custom == undefined) {

				} else {
					custom = jsonList[i].custom;
				}
				//	alert(jsonList[i].contactName);
				var html = "";
				var li = document.createElement('li');
				li.className = 'mui-table-view-cell';
				var lia = document.createElement('a');
				lia.className = 'mui-navigate-right';
				lia.href = "javascript:void(0);";
				var contactId = jsonList[i].contactId;
				lia.setAttribute("contactId", contactId);
				lia.addEventListener("tap", function() {
					//打开详情
					mui.openWindow({
						url: 'detailsContact.html',
						id: 'detailsContact',
						extras: {
							viewId: plus.webview.currentWebview().id,
							callbackFun: "refreshData",
							contactId: this.getAttribute("contactId")
						}
					});
				});
				html += "	<img class='ml12' src=\"../../images/touxiang_07.png\" alt=\"图像不见了\" />";
				html += "	<div class=\"top_text\">";
				var bumenjiazhiwu = jsonList[i].groupName;
				if (bumenjiazhiwu == "") {
					bumenjiazhiwu += jsonList[i].jobName;
				} else {
					if (jsonList[i].jobName != "") {
						bumenjiazhiwu += "/" + jsonList[i].jobName;
					}
				}
				html += "	<span class=\"pn2\">" + jsonList[i].contactName + "</span><span class=\"zw1\">" + bumenjiazhiwu + "</span>";
				html += "	</div>";
				html += "	<span class=\"cn2\">" + custom + "</span>";
				lia.innerHTML = html;
				li.appendChild(lia);
				table.appendChild(li);
			}
			if (currentPage >= totalPage) {
				mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
			} else {
				mui('#pullrefresh').pullRefresh().endPullupToRefresh(false); //参数为true代表没有更多数据了。
			}
			mui('#pullrefresh').pullRefresh().endPulldownToRefresh(); //refresh completed

			if (totalPage <= 1) {
				if (totalPage == 0) {
					$(".listNoData").show();
				}
				mui('#pullrefresh').pullRefresh().disablePullupToRefresh();
			}
		})



	}, 500);
}
/**
 * 上拉加载列表
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
				"userName": keyword,
				"followerId": followerId,
				"subordinate": searchFollower,
				"userId": window.windowCommon.approveLoginId
			}
			contactApi.getList(param, function(data) {

				currentPage++;
				var table = document.body.querySelector('#aa');
				var jsonData = JSON.parse(data);
				totalPage = jsonData.totalPage;
				var jsonList = jsonData.list;
				for (var i = 0; i < jsonList.length; i++) {
					var custom = "";
					if (jsonList[i].custom == undefined) {

					} else {
						custom = jsonList[i].custom;
					}
					//	alert(jsonList[i].contactName);
					var html = "";
					var li = document.createElement('li');
					li.className = 'mui-table-view-cell';
					var lia = document.createElement('a');
					lia.className = 'mui-navigate-right';
					var contactId = jsonList[i].contactId;
					lia.setAttribute("contactId", contactId);
					lia.addEventListener("tap", function() {
						//打开详情
						mui.openWindow({
							url: 'detailsContact.html',
							id: 'detailsContact',
							extras: {
								viewId: plus.webview.currentWebview().id,
								callbackFun: "refreshData",
								contactId: this.getAttribute("contactId")
							}
						});
					});
					html += "	<img class='ml12' src=\"" + window.windowCommon.photoUrl + jsonList[i].photo + "\" title=\"" + jsonList[i].contactName + "\" onerror=\"headError(this);\" />";
					html += "	<div class=\"top_text\">";
					var bumenjiazhiwu = jsonList[i].groupName;
					if (bumenjiazhiwu == "") {
						bumenjiazhiwu += jsonList[i].jobName;
					} else {
						if (jsonList[i].jobName != "") {
							bumenjiazhiwu += "/" + jsonList[i].jobName;
						}
					}
					html += "	<span class=\"pn2\">" + jsonList[i].contactName + "</span><span class=\"zw1\">" + bumenjiazhiwu + "</span>";
					html += "	</div>";
					html += "	<span class=\"cn2\">" + custom + "</span>";
					lia.innerHTML = html;
					li.appendChild(lia);
					table.appendChild(li);
				}
				if (currentPage >= totalPage) {
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
			})


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