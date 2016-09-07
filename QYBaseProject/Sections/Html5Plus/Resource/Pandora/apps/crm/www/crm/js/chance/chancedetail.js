/**
 * 销售机会详情js
 */
var customerId = 0;
var chanceId;

var currentPage = 1;
var totalPage = 999;


var viewId; //来源页面id
var callbackFun; //来源页面回调函数
var isNeedRefresh = 0; //是否需要刷新来源页面



//页面加载完毕方法
mui.plusReady(function() {
	plus.nativeUI.showWaiting("等待中...");
	//得到跳转前页面的参数
	var self = plus.webview.currentWebview();
	chanceId = self.chanceId;
	customerId = self.customerId;

	viewId = self.viewId;
	callbackFun = self.callbackFun;


	mui.init({
		//页面关闭前执行父页面的刷新回调函数
		beforeback: function() {
			if (viewId && callbackFun && isNeedRefresh) {
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun + "();");
			}
		}
	});

	$(window).scroll(function() {
		if ($(window).scrollTop() == $(document).height() - $(window).height()) {
			//获得拜访记录列表
			getVisitList();
		}
	});

	//初始化销售机会信息
	initChanceInfo();

	//绑订销售阶段的方法
	mui("#sellStageA")[0].addEventListener('tap', function() {
		mui("#popover1").popover('toggle');
	});

	mui("#popover1").on('tap', "li", function() {
		mui("#popover1").popover('toggle');
	});

	//添加联系记录
	$("#addRecord").click(function() {
		mui("#addpopover").popover("toggle");
	});

	//关闭添加联系记录弹框
	/*$("#addpopover").on("click","li",function(){
		mui("#addpopover").popover("toggle");
	});*/

	document.getElementById("addpopoverXCBF").addEventListener('tap', function() {
		mui("#addpopover").popover("toggle");
		toAddRecord(1);
	});

	document.getElementById("addpopoverOTHER").addEventListener('tap', function() {
		mui("#addpopover").popover("toggle");
		toAddRecord(2);
	});

	//绑定进入详情事件
	$("#recordList").on("tap", "ul.content-list", function() {
		mui.openWindow({
			url: '../visit/visitdetail.html',
			id: 'visitdetail',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshChildData",
				visitdetailId: $(this).parents("ul.log").attr("val")
			}
		});
	});

	//绑订跟进人的方法（进入跟进人页面）
	document.getElementById("followUserIdsA").addEventListener('tap', function() {
		mui.openWindow({
			url: 'followUserIds.html',
			id: 'followUserIds',
			extras: {
				cid: chanceId,
				viewId: plus.webview.currentWebview().id,
				callbackFun: "initChanceInfo",
			}
		});
	});

	//绑订进入修改页面
	document.getElementById("toupdate").addEventListener('tap', function() {
		mui.openWindow({
			url: 'chanceadd.html',
			id: 'chanceadd',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshDetail",
				cid: chanceId
			}
		});
	});

	/*-------------拜访记录绑定事件-------------------*/
	//绑定删除事件
	$("#recordList").on("tap", ".sale-new-del", function() {
		var visitdetailId = $(this).attr("visitdetailId");
		del(visitdetailId);
	});

	//绑定点赞事件
	$("#recordList").on("tap", ".good", function() {
		delPraise(this);
	});

	//绑定取消点赞事件
	$("#recordList").on("tap", ".nogood", function() {
		praise(this);
	});

	//绑定展开评论区域div事件
	$("#recordList").on("tap", ".comment", function() {
		if ($(this).parent().siblings(".shi-comment")) {
			$(this).parent().siblings(".shi-comment").toggle();
		}
	});
});

/**
 * 初始化销售机会信息
 */
var initChanceInfo = function() {

	var data = {
		"_clientType": "wap",
		"id": chanceId,
		userId: window.windowCommon.approveLoginId
	};
	_chanceApi._findChance(data, function(response) {
		//展示机会信息
		initChance(response.chance);
		//初始化销售阶段并选中
		initSellStage(response.dict);
		//关闭太阳花loading
		plus.nativeUI.closeWaiting();
		//得到联系记录列表
		getVisitList();
	});
}

/**
 * 展示机会信息
 * @param {Object} response
 */
var initChance = function(response) {
	document.getElementById("chanceName").innerHTML = response.chanceName;
	document.getElementById("customerName").innerHTML = response.customerName;
	document.getElementById("chanceMoney").innerHTML = response.chanceMoneyCF;
	document.getElementById("expectedTime").innerHTML = response.expectedTime;
	document.getElementById("sellStageSPAN").innerHTML = response.sellStageName;
	document.getElementById("sellStage").value = response.sellStage;
	document.getElementById("remark").innerHTML = response.remark;
	if (trim(response.remark) != undefined) {
		document.getElementById("remarkLI").setAttribute("style", "display: block;");
	}

	var followUserNames = response.usermap.owner.name + ',';
	var followers = response.usermap.followers;
	for (var i = 0; i < followers.length; i++) {
		if (i < 3) {
			followUserNames += followers[i].name + ',';
		} else {
			followUserNames = trim(followUserNames);
			followUserNames += ' ...';
			break;
		}
	}
	document.getElementById("followUserIds").innerHTML = trim(followUserNames) == undefined ? '' : trim(followUserNames);
}

/**
 * 初始化销售阶段的响应
 * @param {Object} response
 */
var initSellStage = function(response) {
	var sellStageULObj = document.getElementById("sellStageUL");
	sellStageULObj.innerHTML = '';

	/*var subli01 = document.createElement("li");
	subli01.setAttribute("class", "mui-table-view-cell month-active");
	subli01.innerHTML = '不限';
	sellStageULObj.appendChild(subli01);*/

	mui.each(response, function(i, n) {
		var subli02 = document.createElement("li");
		if (document.getElementById("sellStage").value == n.value) {
			subli02.setAttribute("class", "mui-table-view-cell month-active");
		} else {
			subli02.setAttribute("class", "mui-table-view-cell");
		}
		subli02.setAttribute("name", n.value);
		subli02.innerHTML = n.name;
		sellStageULObj.appendChild(subli02);
	});

	var lis = mui("#sellStageUL li");
	mui.each(lis, function(i, n) {
		lis[i].addEventListener("tap", function() {
			selectSellStage(lis[i]);
		});
	});
}

/**
 * 选择一个销售阶段
 * @param {Object} obj
 */
var selectSellStage = function(obj) {
	//修改样式
	var lis = mui("#sellStageUL li");
	mui.each(lis, function(i, n) {
		lis[i].setAttribute("class", "mui-table-view-cell");
	});
	obj.setAttribute("class", "mui-table-view-cell month-active");

	//赋值
	document.getElementById("sellStage").value = obj.getAttribute("name");
	document.getElementById("sellStageSPAN").innerHTML = obj.innerHTML;

	//修改操作
	modifyOne(1);

	//返回时刷新销售机会列表
	refreshchancelist = true;
}


//这个tapnum用来控制 modifyOne 方法的重复点击
var tapnum = 0;

/**
 * 修改销售机会
 * @param {Object} which 1表示修改销售阶段， 2 表示修改跟进人
 */
var modifyOne = function(which) {
	if (tapnum++ > 0) {
		console.log('无操作');
		return;
	}

	//销售阶段
	var sellStage = document.getElementById("sellStage").value;
	if (!verifyEmpty(sellStage)) {
		mui.toast('请选择销售阶段!');
		tapnum = 0
		return;
	}

	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"cid": chanceId,
		"sellStage": sellStage,
		"followUserIds": '',
		"which": which
	};

	_chanceApi._modifyChancePart(data, modifyOnesuccess);
}

/**
 * 修改销售机会的响应
 * @param {Object} response
 */
var modifyOnesuccess = function(response) {
	//response = eval( '(' + response + ')' );
	if (response.code == 1) {
		mui.toast('保存成功！');
	} else {
		mui.toast('保存失败！');
	}
	tapnum = 0;
	/*console.log(plus.webview.currentWebview().viewid);
	console.log(plus.webview.currentWebview().updatefunction);*/
	plus.webview.getWebviewById(plus.webview.currentWebview().viewid)
		.evalJS(plus.webview.currentWebview().updatefunction + "();");

}

/**
 * 验证空值
 * @param {Object} val
 * @param {Object} defval
 */
var verifyEmpty = function(val, defval) {
	if (val == null || val == undefined) {
		return false;
	}
	if (defval == null || defval == undefined) {
		if (val == '') {
			return false;
		}
	} else {
		if (val == defval) {
			return false;
		}
	}
	return true;
}


/**
 * 添加联系记录
 */
function toAddRecord(visitType) {
	mui.openWindow({
		url: '../visit/addvisit.html',
		id: 'addvisit',
		extras: {
			'fromType': 3, ////页面来源（1 [来自列表]   2 [来自往来单位详情]    3[来自机会详情]）
			'visitType': visitType, ////拜访类型 (1现场拜访 2沟通联系)
			'customerId': customerId, //单位ID
			'chanceId': chanceId, //机会ID
			"webViewId": "chancedetail", //新增成功后调用那个页面
			"webViewFunction": "refreshChildData" //新增成功后调用那个页面的那个方法
		}
	});
}
/**
 * 刷新机会详情
 */
function refreshDetail() {
	isNeedRefresh = 1;
	initChanceInfo();
}

/**
 * 刷新联系记录
 */
function refreshChildData() {
	currentPage = 1;
	totalPage = 999;
	$("#recordList").html('');
	getVisitList();
}

/**
 * 获得联系记录列表数据
 */
function getVisitList() {
	var param = {
		"_clientType": "wap",
		"pageNo": currentPage,
		"pageSize": 2,
		"chanceId": chanceId,
		"customerId": customerId,
		"userId": window.windowCommon.approveLoginId
	}
	if (currentPage > totalPage) {
		return false;
	}

	_customerApi._visitList(param, function(jsonData) {
		//console.log('page='+currentPage);

		var jsonDataList = jsonData.list;
		totalPage = jsonData.totalPage;
		if (jsonDataList && jsonDataList.length > 0) {
			if (currentPage == 1) {
				$("#recordList").html('');
			}

			//console.log('length='+jsonDataList.length);
			for (var i = 0; i <= jsonDataList.length - 1; i++) {
				var visitdetailId = jsonDataList[i].visitdetailId;
				var html = '<ul class="mui-table-view log" val="' + visitdetailId + '">';

				html += '<li class="mui-table-view-cell shi-time unit-ps">';
				html += '<em class="time-ico"></em>';
				html += '<span>' + jsonDataList[i].visitTime + '</span>';
				html += '</li>';
				html += '<li class="mui-table-view-cell mui-media log-user">';
				html += '<img class="mui-pull-left shi-ppic" src="' + window.windowCommon.photoUrl + jsonDataList[i].createUserPhoto + '" title="' + jsonDataList[i].createUserName + '" onerror="headError(this);">';
				html += '<div class="mui-media-body">';
				html += '' + jsonDataList[i].createUserName + '';
				html += '</div>';
				html += '</li>';
				html += '<div class="content">';
				html += '<ul class="content-list" >';
				html += '<li class="mui-ellipsis-2">';
				if (jsonDataList[i].visitType == 1) {
					html += '<span class="shi-tit">现场拜访：</span><p class="shi-txt">' + jsonDataList[i].visitPoistion + '</p>';
				} else if (jsonDataList[i].visitType == 2) {
					html += '<span class="shi-tit">沟通对象：</span><p class="shi-txt"><span class="public-span1 w40 cttext">' + jsonDataList[i].communicationUserName + '</span><span class="centre-text">（' + jsonDataList[i].communicationModeName + '沟通）</span>' + '</p>';
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
						html += '<ul class="shi-comment" id="pinglun" style="display:none">';
						html += '<li>';
						html += '<div class="shi-visit-reply">';
						html += '<a href="javascript:void(0);" class="shi-nm">' + visitRecordCommentList[k].userName + '</a><a class="shi-data">' + visitRecordCommentList[k].createTime + '</a>';
						html += '</div>';
						html += '<a href="javascript:void(0);" class="shi-ly">' + visitRecordCommentList[k].content + '</a>';
						html += '</li>';
						html += '</ul>';
					}
				}
				html += '</div>';
				html += '</ul>';
				$("#recordList").append(html);
			}
		} else if (currentPage == 1) {
			$("#recordList").html('<div class="no_visit">您还没有添加联系记录</div>');
		}
		currentPage++;
	});
}