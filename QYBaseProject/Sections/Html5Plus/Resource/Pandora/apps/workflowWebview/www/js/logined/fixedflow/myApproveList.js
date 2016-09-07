//当前页数
var currentPage1 = 0;
var currentPage2 = 0;
var isEndItem1 = false;
var isEndItem2 = false;
//带我审批列表上啦加载
function pullupRefresh_approving(currObj) {
	//使用缓存数据
	var cacheData = getCacheData("flow_myWait_data");
	if (cacheData) {
		var cacheAry = JSON.parse(cacheData);
		if (cacheAry[0]) {
			for (var i = 2; i < cacheAry.length; i++) {
				showApprovingDataWithHTML(cacheAry[i], currObj);
			}
			cacheAry[0] = false;
			saveCacheData("flow_myWait_data", JSON.stringify(cacheAry));
			if (plus.os.name == "iOS") {
				document.scrollY = cacheAry[1];
			} else {
				document.body.scrollTop = cacheAry[1];
			}
			return false;
		}
	}
	mui.ajax(window.windowCommon.basePath + "baseworkflow/myWaitProcess.c?time=" + (new Date()).getTime(), {
		data: {
			"_clientType": "wap",
			"iDisplayStart": currentPage1 * 10,
			"iDisplayLength": 10,
			"userId": window.windowCommon.approveLoginId
		},
		dataType: 'text', //服务器返回json格式数据
		type: 'post', //HTTP请求类型
		timeout: 60000, //超时时间设置为60秒；
		crossDomain: true,
		success: function(data) {
			if (currentPage1 == 0) {
				clearCacheData("flow_myWait_data");
			}
			showApprovingDataWithHTML(data, currObj);
			//保存缓存数据
			var cacheData = getCacheData("flow_myWait_data");
			if (cacheData) {
				cacheAry = JSON.parse(cacheData);
				var len = cacheAry.length;
				cacheAry[len] = data;
			} else {
				var cacheAry = new Array();
				cacheAry[0] = false;
				cacheAry[2] = data;
			}
			saveCacheData("flow_myWait_data", JSON.stringify(cacheAry));
		},
		error: function(xhr, type, errorThrown) {
			//异常处理；
			if(type=="timeout"){
				mui.toast("请求数据超时");
			}else{
				mui.toast("请求数据异常");
			}
		}
	});
};
//显示待审批列表数据
function showApprovingDataWithHTML(data, currObj) {
	currentPage1++;
	var table = document.body.querySelector('#item1mobile ul.mui-table-view');
	var replaceData = data.replace("100||", "");
	var jsonData = JSON.parse(replaceData);
	var approveData = jsonData.aaData;
	var iTotalRecords = jsonData.iTotalRecords;
	$("#item1A").html("待审批(" + iTotalRecords + ")");
	if ((currentPage1 - 1) * 10 + approveData.length >= iTotalRecords) {
		isEndItem1 = true;
	}
	for (var i = 0; i < approveData.length; i++) {
		var photoUrl = approveData[i].photoUrl;
		var title = approveData[i].title;
		var state = approveData[i].state;
		var arriveTime = approveData[i].arriveTime;
		var instanceId = approveData[i].instanceId;
		var currentUserId = approveData[i].currentUserId;
		var createrName = approveData[i].createrName;
		var moduleCode = approveData[i].moduleCode;
		var code = "";
		if (instanceId != null && instanceId != undefined) {
			code = instanceId.substring(0, instanceId.indexOf("."));
		}
		var showTitle = title;
		var viewUrl = '';
		var viewId = '';
		if (code == 'qingjia') { //请假
			viewUrl = '../freeflow/qingjia_detail.html';
			viewId = 'qingjia_detail';
			title = title + "申请";
		} else if (code == 'baoxiao') { //报销
			viewUrl = '../freeflow/baoxiao_detail.html';
			viewId = 'baoxiao_detail';
			title = title + "申请";
		} else if (code == 'chuchai') { //出差
			viewUrl = '../freeflow/chuchai_detail.html';
			viewId = 'chuchai_detail';
			title = title + "申请";
		} else if (code == 'waichu') { //外出
			viewUrl = '../freeflow/waichu_detail.html';
			viewId = 'waichu_detail';
			title = title + "申请";
		} else if (code == 'lingyong') { //物品领用
			viewUrl = '../freeflow/lingyong_detail.html';
			viewId = 'lingyong_detail';
			title = title + "申请";
		} else if (code == 'tongyong') { //通用
			viewUrl = '../freeflow/tongyong_detail.html';
			viewId = 'tongyong_detail';
			title = title + "申请";
		} else {
			viewUrl = 'detail.html';
			viewId = 'detail';
			showTitle = createrName + "的" + title;
		}

		if (createrName != null && createrName.length > 2) {
			createrName = createrName.substring(createrName.length - 2, createrName.length);
		}
		var col = letterCode(createrName);
		var li = document.createElement('li');
		li.className = 'mui-table-view-cell mui-media mui-approve';
		var lia = document.createElement('a');
		lia.href = "javascript:void(0);";
		lia.setAttribute("instanceId", instanceId);
		lia.setAttribute("title", showTitle);
		lia.setAttribute("viewUrl", viewUrl);
		lia.setAttribute("viewId", viewId);
		lia.addEventListener("tap", function() {
			//打开详情
			var viewId = this.getAttribute("viewId");
			var viewUrl = this.getAttribute("viewUrl");
			var instanceId = this.getAttribute("instanceId");
			var title = this.getAttribute("title");
			//设置页面参数
			var mapParam = new Map();
			mapParam.put("instanceId", instanceId);
			mapParam.put("title", title);
			mapParam.put("operation", "approving");
			setPageParam("flow_detail", mapParam);
			//设置页面的返回路径
			setBackUrl("myApproveListLeft.html");
			setTimeout(function() {
				//打开详情
				window.location.href = viewUrl;
			}, 300);
			//启用缓存数据
			setCacheStarting();

		});
		var html = ""
		if (photoUrl == null || photoUrl == undefined || photoUrl == "") {
			html += '<div class="textround mui-pull-left head-img head-bg-' + col + '">' + createrName + '</div>';
		} else {
			html += '<img class="mui-media-object mui-pull-left head-img" src="' + photoUrl + '" >';
		}
		html += '<div class="mui-media-body mui-ellipsis">' + showTitle;
		html += '<p class="state">' + state + '<span class="time mui-pull-right">' + arriveTime + '</span></p>';
		html += '</div>';
		lia.innerHTML = html;
		li.appendChild(lia);
		//下拉刷新，新纪录插到最前面；
		table.appendChild(li);
	}
	currObj.endPullUpToRefresh(isEndItem1);

	if (currentPage1 == 1 && approveData.length == 0) {
		$("#item1mobile .mui-pull-loading").text("暂无数据");
		$("#item1mobile .mui-pull-bottom-tips").css("margin-top", "100px");
	} else if (currentPage1 == 1 && approveData.length == iTotalRecords && iTotalRecords != 0) {
		$("#item1mobile .mui-pull-loading").text("");
	}
}
//我已审批列表上啦加载
function pullupRefresh_approved(currObj) {
	//使用缓存数据
	var cacheData = getCacheData("flow_myProcessed_data");
	if (cacheData) {
		var cacheAry = JSON.parse(cacheData);
		if (cacheAry[0]) {
			for (var i = 2; i < cacheAry.length; i++) {
				showApprovedDataWithHTML(cacheAry[i], currObj);
			}
			cacheAry[0] = false;
			saveCacheData("flow_myProcessed_data", JSON.stringify(cacheAry));
			if (plus.os.name == "iOS") {
				document.scrollY = cacheAry[1];
			} else {
				document.body.scrollTop = cacheAry[1];
			}
			return false;
		}
	}
	mui.ajax(window.windowCommon.basePath + "baseworkflow/myProcessed.c?time=" + (new Date()).getTime(), {
		data: {
			"_clientType": "wap",
			"iDisplayStart": currentPage2 * 10,
			"iDisplayLength": 10,
			"userId": window.windowCommon.approveLoginId
		},
		dataType: 'text', //服务器返回json格式数据
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(data) {
			if (currentPage1 == 0) {
				clearCacheData("flow_myProcessed_data");
			}
			showApprovedDataWithHTML(data, currObj);
			//保存缓存数据
			var cacheData = getCacheData("flow_myProcessed_data");
			if (cacheData) {
				cacheAry = JSON.parse(cacheData);
				var len = cacheAry.length;
				cacheAry[len] = data;
			} else {
				var cacheAry = new Array();
				cacheAry[0] = false;
				cacheAry[2] = data;
			}
			saveCacheData("flow_myProcessed_data", JSON.stringify(cacheAry));
		},
		error: function(xhr, type, errorThrown) {
			//异常处理；
			if(type=="timeout"){
				mui.toast("请求数据超时");
			}else{
				mui.toast("请求数据异常");
			}
		}
	});
}

//显示待审批列表数据
function showApprovedDataWithHTML(data, currObj) {
	currentPage2++;
	var table = document.body.querySelector('#item2mobile ul.mui-table-view');
	var replaceData = data.replace("100||", "");
	var jsonData = JSON.parse(replaceData);
	var approveData = jsonData.aaData;
	var iTotalRecords = jsonData.iTotalRecords;
	if ((currentPage2 - 1) * 10 + approveData.length >= iTotalRecords) {
		isEndItem2 = true;
	}
	for (var i = 0; i < approveData.length; i++) {
		var photoUrl = approveData[i].photoUrl;
		var title = approveData[i].title;
		var state = approveData[i].state;
		var approveTime = approveData[i].approveTime;
		var instanceId = approveData[i].instanceId;
		var currentUserId = approveData[i].currentUserId;
		var createrName = approveData[i].createrName;
		var moduleCode = approveData[i].moduleCode;
		var code = "";
		if (instanceId != null && instanceId != undefined) {
			code = instanceId.substring(0, instanceId.indexOf("."));
		}
		var showTitle = title;
		var viewUrl = '';
		var viewId = '';
		if (code == 'qingjia') { //请假
			viewUrl = '../freeflow/qingjia_detail.html';
			viewId = 'qingjia_detail';
			title = title + "申请";
		} else if (code == 'baoxiao') { //报销
			viewUrl = '../freeflow/baoxiao_detail.html';
			viewId = 'baoxiao_detail';
			title = title + "申请";
		} else if (code == 'chuchai') { //出差
			viewUrl = '../freeflow/chuchai_detail.html';
			viewId = 'chuchai_detail';
			title = title + "申请";
		} else if (code == 'waichu') { //外出
			viewUrl = '../freeflow/waichu_detail.html';
			viewId = 'waichu_detail';
			title = title + "申请";
		} else if (code == 'lingyong') { //物品领用
			viewUrl = '../freeflow/lingyong_detail.html';
			viewId = 'lingyong_detail';
			title = title + "申请";
		} else if (code == 'tongyong') { //通用
			viewUrl = '../freeflow/tongyong_detail.html';
			viewId = 'tongyong_detail';
			title = title + "申请";
		} else {
			viewUrl = 'detail.html';
			viewId = 'detail';
			showTitle = createrName + "的" + title;
		}
		if (createrName != null && createrName.length > 2) {
			createrName = createrName.substring(createrName.length - 2, createrName.length);
		}
		var col = letterCode(createrName);
		var li = document.createElement('li');
		li.className = 'mui-table-view-cell mui-media mui-approve';
		var lia = document.createElement('a');
		lia.href = "javascript:void(0);";
		lia.setAttribute("instanceId", instanceId);
		lia.setAttribute("title", showTitle);
		lia.setAttribute("viewUrl", viewUrl);
		lia.setAttribute("viewId", viewId);
		lia.addEventListener("tap", function() {
			//打开详情
			var viewId = this.getAttribute("viewId");
			var viewUrl = this.getAttribute("viewUrl");
			var instanceId = this.getAttribute("instanceId");
			var title = this.getAttribute("title");
			//设置页面参数
			var mapParam = new Map();
			mapParam.put("instanceId", instanceId);
			mapParam.put("title", title);
			mapParam.put("operation", "approved");
			setPageParam("flow_detail", mapParam);
			//设置页面的返回路径
			setBackUrl("myApproveListRight.html");
			setTimeout(function() {
				//打开详情
				window.location.href = viewUrl;
			}, 300);
			//启用缓存数据
			setCacheStarting();
		});
		var html = ""
		if (photoUrl == null || photoUrl == undefined || photoUrl == "") {
			html += '<div class="mui-media-object mui-pull-left head-img head-bg-' + col + '">' + createrName + '</div>';
		} else {
			html += '<img class="mui-media-object mui-pull-left head-img" src="' + photoUrl + '" >';
		}
		html += '<div class="mui-media-body mui-ellipsis">' + showTitle;
		html += '<p class="state">' + state + '<span class="time mui-pull-right">' + approveTime + '</span></p>';
		html += '</div>';
		lia.innerHTML = html;
		li.appendChild(lia);
		//下拉刷新，新纪录插到最前面；
		table.appendChild(li);
	}
	currObj.endPullUpToRefresh(isEndItem2);
	if (currentPage2 == 1 && approveData.length == 0) {
		$("#item2mobile .mui-pull-loading").text("暂无数据");
		$("#item2mobile .mui-pull-bottom-tips").css("margin-top", "100px");
	} else if (currentPage2 == 1 && approveData.length == iTotalRecords && iTotalRecords != 0) {
		$("#item2mobile .mui-pull-loading").text("");
	}
}
//启用缓存数据
function setCacheStarting() {
	//待审批缓存
	var cacheData = getCacheData("flow_myWait_data");
	if (cacheData) {
		var cacheAry = JSON.parse(cacheData);
		cacheAry[0] = true;
		if (plus.os.name == "iOS") {
			cacheAry[1] = document.scrollY + '';
		} else {
			cacheAry[1] = document.body.scrollTop + '';
		}
		saveCacheData("flow_myWait_data", JSON.stringify(cacheAry));
	}
	//已审批缓存
	cacheData = getCacheData("flow_myProcessed_data");
	if (cacheData) {
		var cacheAry = JSON.parse(cacheData);
		cacheAry[0] = true;
		if (plus.os.name == "iOS") {
			cacheAry[1] = document.scrollY + '';
		} else {
			cacheAry[1] = document.body.scrollTop + '';
		}

		saveCacheData("flow_myProcessed_data", JSON.stringify(cacheAry));
	}
}
(function($) {
	mui.plusReady(function() {
		//设置页面的返回路径
		setBackUrl("index.html");
		//判断当前是否有网络
		if (!getNetConnection()) {
			$(".mui-content").hide();
			$(".noNet").show();
			return false;
		}
		//循环初始化所有下拉刷新，上拉加载。
		$.each(document.querySelectorAll('.mui-slider-group .mui-scroll'), function(index, pullRefreshEl) {
			$(pullRefreshEl).pullToRefresh({
				up: {
					auto: true,
					callback: function() {
						var self = this;
						setTimeout(function() {
							var ul = self.element.querySelector('.mui-table-view');
							var approve = ul.getAttribute("approve");
							if (approve == "approving") {
								pullupRefresh_approving(self);
							} else {
								pullupRefresh_approved(self);
							}
						}, 500);
					}
				}
			});
		});
	});
})(mui);