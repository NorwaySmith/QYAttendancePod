/**
 * 联系人列表页面js
 */
var currentPage = 0;
var totalPage = 999;
var keyword = "";
var isEnd = false;
var searchFollower = 0; //是否是查询所有下属 0否 1是


function plusReady() {
	//默认当前登录人选中
	$("#toPopover2").find("a").html(window.windowCommon.approveLoginName);
	$("#myName").html(window.windowCommon.approveLoginName);

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


	mui("#search")[0].addEventListener('tap', function() {
		mui('#popover2').popover('hide');
		mui.openWindow({
			url: 'searchContact.html',
			id: 'searchContact',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData",
				searchFollower: searchFollower,
				userName: window.windowCommon.approveLoginName,
				followerId: ''
			}
		});
	});
	document.querySelector("#add").addEventListener("tap", function() {
		mui('#popover2').popover('hide');
		mui.openWindow({
			url: "addcontact.html",
			id: "addcontact"
		})
	});

	//单击名字筛选
	mui("#toPopover2")[0].addEventListener('tap', function() {
		mui("#popover2").popover('toggle');
	});
	//单击人员选择条件自动关闭选择框
	mui("#popover2").on('tap', "li", function() {
		mui("#popover2").popover('toggle');
	});

	//选中当前登录人
	mui("#myName")[0].addEventListener('tap', function() {
		//$("#myName").html(window.windowCommon.approveLoginName+'<img src="../../images/yes_10.png"/>');
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		searchFollower = 0; //选中当前登录人
		$("#toPopover2").find("a").html(window.windowCommon.approveLoginName);
		refreshChildData(); //刷新子页面数据
	});

	//选中全部下属
	mui("#allFollower")[0].addEventListener('tap', function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		searchFollower = 1; //选择全部下属
		$("#toPopover2").find("a").html('全部下属');
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
				tourl: "../contact/searchContact.html",
				toviewid: "searchContact"
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
 * 刷新子页面数据
 */
function refreshChildData() {
	currentPage = 0;
	totalPage = 999;
	$("#aa").html('');
	_enablePullUp();
	mui('#pullrefresh').pullRefresh().refresh(true);
	mui('#pullrefresh').pullRefresh().pullupLoading();
}

/**
 * 加载列表
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
								callbackFun: "refreshChildData",
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
			});

		}, 200);
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