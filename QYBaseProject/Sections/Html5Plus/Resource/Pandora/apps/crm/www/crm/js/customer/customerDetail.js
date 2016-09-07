/**
 * 往来单位详情页面js 
 */
var chanceId;
var userId;
var customerId;

var viewId; //来源页面id
var callbackFun; //来源页面回调函数
var isNeedRefresh = 0; //是否需要刷新来源页面

var currentPage = 1;
var totalPage = 999;

mui.plusReady(function() {
		mui.init({
			swipeBack: true, //启用右滑关闭功能
			beforeback: function() {
				if (viewId && callbackFun && isNeedRefresh) {
					var parent = plus.webview.getWebviewById(viewId);
					parent.evalJS(callbackFun + "();");
				}
			}
		});
		mui('.mui-scroll-wrapper').scroll();

		var self = plus.webview.currentWebview();
		customerId = self.customerId;
		userId = window.windowCommon.approveLoginId;
		viewId = self.viewId;
		callbackFun = self.callbackFun;

		getCustomerDetail();

		getVisitList();
		$(window).scroll(function() {
			if ($(window).scrollTop() == $(document).height() - $(window).height()) {
				getVisitList();
			}
		});
		//点击客户状态
		$("#customerState").click(function(){
			mui("#statePopover").popover("toggle");
		});
		
		//点击客户状态类型触发事件
		$("#statePopover").delegate("li","tap",function(){
			changeCustomerState(this);
		});	
		//点击销售机会的状态
		$("#chanceList").delegate(".unit-two-one-right", "tap", function() {
			mui('#popover1').popover('toggle');
			chanceId = $(this).parent("a").attr("chanceId");
			var sellStage = $(this).parent("a").attr("sellStage");
			$("#sellStageUL").find("li").removeClass("month-active");
			var lis = $("#sellStageUL li");
			mui.each(lis, function(i, n) {
				var state = $(lis[i]).attr("name");
				if (state == sellStage) {
					$(lis[i]).addClass("month-active");
				}
			});
		});
		//点击销售机会的名称，进入详情页面
		$("#chanceList").delegate(".unit-two-one", "tap", function() {
			chanceId = $(this).parent("a").attr("chanceId");
			mui.openWindow({
				url: '../chance/chancedetail.html',
				id: 'chancedetail',
				extras: {
					chanceId: chanceId,
					customerId: customerId,
					viewId: plus.webview.currentWebview().id,
					callbackFun: "refreshDetailAndList"
				}
			});
		});
		//点击订单的名称，进入详情页面
		$("#orderList").delegate("li", "tap", function() {
			var orderId = $(this).attr("orderId");
			mui.openWindow({
				url: '../order/orderDetail.html',
				id: 'orderDetail',
				extras: {
					orderId: orderId,
					viewId: plus.webview.currentWebview().id,
					callbackFun: "refreshDetailAndList"
				}
			});
		});
		//加载销售机会阶段
		initSellStage();
		//绑定添加跟进人事件
		$("#chooseFollower").click(function() {
			var followUserIds = $("#followUserId").val(); //获得跟进人ids
			plus.qytxplugin.selectUsers(followUserIds, 0, function(data) {
				var ids = ",";
				$.each(data, function(i, item) {
					ids += item.userId + ",";
				});
				var ownerId = $("#ownerId").val(); //获得负责人
				var ownerIdStr = "," + ownerId + ",";
				if (ids.indexOf(ownerIdStr) > -1) { //过滤负责人
					ids = ids.replace(ownerIdStr, ",");
				}
				if (ids == ",") {
					ids = "";
				}
				changeFollowUsers(ids);
			});
		});
		//绑定添加负责人事件
		$("#chooseOwner").click(function() {
			var ownerId = $("#ownerId").val(); //获得负责人
			plus.qytxplugin.selectUsers(ownerId, 1, function(data) {
				var infoId;
				$.each(data, function(i, item) {
					infoId = item.userId;
				});
				var btnArray = ['确认', '取消'];
				if(infoId){
					mui.confirm('确认要变更负责人吗？', '变更负责人', btnArray, function(e) {
						if (e.index == 0) { //点击确认
							changeOwner(infoId);
							isNeedRefresh = 1;
						} else { //点击取消
		
						}
					});
				}
			});
		});

		$("#detailhead").click(function() {
			mui.openWindow({
				url: 'editCustomer.html',
				id: 'editCustomer',
				extras: {
					customerId: customerId
				}
			});
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
	})
	/**
	 * 初始化销销售机会阶段
	 * @param {Object} response
	 */

function initSellStage() {
		var url = window.windowCommon.basePath + 'crm/chance/getDictType.c';

		var data = {
			"_clientType": "wap",
			"infoType": 'sellStage' //sellStage表示销售阶段
		};

		mui.ajax(url, {
			data: data,
			dataType: 'json',
			type: 'post', //HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: initSellStageSuccess
		});
	}
	/**
	 * 初始化销售阶段的响应
	 * @param {Object} response
	 */
var initSellStageSuccess = function(response) {
		if (response.code == 1) {
			var sellStageULObj = document.getElementById("sellStageUL");
			sellStageULObj.innerHTML = '';


			mui.each(response.data, function(i, n) {
				var subli02 = document.createElement("li");
				subli02.setAttribute("class", "mui-table-view-cell");
				subli02.setAttribute("name", response.data[i].value);
				subli02.innerHTML = response.data[i].name;
				sellStageULObj.appendChild(subli02);
			});

			var lis = mui("#sellStageUL li");
			mui.each(lis, function(i, n) {
				lis[i].addEventListener("tap", function() {
					selectSellStage(lis[i]);
				});
			});
		}
	}
	/**
	 * 选择一个销售阶段
	 * @param {Object} obj
	 */
var selectSellStage = function(obj) {
	//修改样式
	$(obj).siblings("li").removeClass("month-active");
	$(obj).addClass("month-active");
	//消失
	mui('#popover1').popover('toggle');
	//变更机会状态
	changeChanceState($(obj).attr("name"));

	//列表中状态变更
	$("#chanceList").find("a[chanceId='" + chanceId + "']").find(".unit-two-one-right").html($(obj).html());
	$("#chanceList").find("a[chanceId='" + chanceId + "']").attr("sellStage", $(obj).attr("name"));
}

/**
 * 获得来往单位详情
 * @param {Object} customerId
 * @param {Object} userId
 */
function getCustomerDetail() {
	var param = {
		"_clientType": "wap",
		"customerId": customerId,
		"t": Math.random(),
		"userId": userId
	};
	_customerApi._getCustomerDetail(param, function(data) {

		$("#customerName").html(data.customerName);
		$("#address").html(data.customerLocation);
		$("#customerState").html(data.customerStateStr);
		$("#followCount").html(data.comFollowUserCount);
		$("#relateCount").html(data.contactCount);
		$("#orderCount").html(data.orderCount);
		$("#chanceCount").html(data.chanceCount);
		$("#followUserId").val(data.followUserId);
		$("#ownerId").val(data.ownerId);
		$("#cState").val(data.customerState);
		findChanceOrderUserList();
		//加载客户状态
		$.each(data.customerStateDict,function(i,item){
			var html='';
			if(data.customerState==item.value){
				html+='<li class="mui-table-view-cell month-active" val="'+item.value+'">';
			}else{
				html+='<li class="mui-table-view-cell" val="'+item.value+'">';
			}
			html+=item.name;
			html+='	</li>';
			$("#statePopoverUl").append(html);
		});
	});

}

function findChanceOrderUserList() {
		var param = {
			"_clientType": "wap",
			"customerId": customerId,
			"userId": userId
		};
		_customerApi._findChanceOrderUserList(param, function(data) {
			if (data && data.chanceList && data.chanceList.length > 0) { //销售机会
				var html = '';
				$("#chanceList").html(html);
				mui.each(data.chanceList, function(index, item) {
					html += '<li class="mui-table-view-cell unit-will-hide">';
					html += '	 <a class="mui-navigate-right" chanceId="' + item.id + '" sellStage="' + item.sellStage + '">';
					html += '	 	<span class="unit-two-one public-span w50">' + item.chanceName + '</span>';
					html += '  	<span class="unit-two-one-right">' + item.crmExtend + '</span>';
					html += '  </a>';
					html += '</li>';
				})
				$("#chanceList").html(html);
			}
			if (data && data.orderList && data.orderList.length) { //销售订单
				var html = '';
				$("#orderList").html(html);
				mui.each(data.orderList, function(index, item) {
					html += '<li class="mui-table-view-cell" orderId="'+item.id+'">';
					html += '	 <span class="shi-order-text">' + item.orderName + '</span>';
					if (item.state == 3) {
						html += '<span class="shi-rt3">意外中止</span>';
					} else if (item.state == 2) {
						html += '<span class="shi-rt2">结束</span>';
					} else if (item.state == 1) {
						html += '<span class="shi-rt1">执行中</span>';
					} else {
						html += '<span class="shi-rt">执行前</span>';
					}
					html += '</li>';
				})
				$("#orderList").html(html);
			}
			if (data && data.contactList && data.contactList.length) { //联系人
				var html = '';
				$("#contactList").html(html);
				mui.each(data.contactList, function(index, item) {
					html += '<li class="mui-table-view-cell unit-ps">';
					html += '	 <a class="special-active">';
					html += '  	<img class="unit-contacts-img" src="' + window.windowCommon.photoUrl + '' + item.photo + '" onerror="headError(this);" title="' + item.contactName + '" />';
					html += '	 	<div class="top_text1">';
					var groupJob = "";
					if (!item.groupName || !item.jobName) {
						if (item.groupName) {
							groupJob = item.groupName;
						}
						if (item.jobName) {
							groupJob = item.jobName;
						}
					} else {
						groupJob = item.groupName + "/" + item.jobName;
					}
					html += '  		<span class="pn2">' + item.contactName + '</span><span class="zw">' + groupJob + '</span>';
					html += '	 	</div>';
					var phone = item.telphone;
					if (phone) {
						if (phone.indexOf(",") == 0) {
							phone = phone.substr(1);
						}
						if (phone.lastIndexOf(",") == (phone.length - 1)) {
							phone = phone.substr(0, phone.length - 1);
						}
						phone = phone.split(",")[0];
					}
					if (phone) {
						html += '	<span class="cn2 cnspan">' + phone + '</span>';
						html += '  	<a class="unit-phone-ico" href="tel:' + phone + '"></a>';
					} else {
						html += '	<span class="cn2 cnspan">无</span>';
						//				    html += '  	<a class="unit-phone-ico"></a>';
					}
					html += '  </a>';
					html += '</li>';
				})
				$("#contactList").html(html);
			}
			if (data && data.owner) { //负责人
				var html = '';
				$("#ownerDiv").html(html);
				html += '<img class="ml10" src="' + window.windowCommon.photoUrl + '' + data.owner.photo + '" onerror="headError(this);" title="' + data.owner.userName + '"/>';
				html += '<a>' + data.owner.userName + '</a>';
				$("#ownerDiv").html(html);
			}
			if (data && data.follow) { //跟进人
				$("#followUserDiv").find(".unit-ps").remove();
				mui.each(data.follow, function(index, item) {
					var html = '';
					html += '<div class="unit-img-box unit-ps" userId="'+item.userId+'">';
					html += '  <img class="ml10" src="' + window.windowCommon.photoUrl + '' + item.photo + '" onerror="headError(this);" title="' + item.userName + '" />';
					html += '	 <a>' + item.userName + '</a>';
					html += '  <em class="unit-follow-del" style="display:none;" onclick="deleteFollowUser(' + item.userId + ');"></em>';
					html += '</div>';
					$("#chooseFollower").before(html);
				});
			}
		});
	}
	/**
	 * 删除跟进人
	 * @param {Object} userId
	 */

function deleteFollowUser(userId) {
		var followUserId = $("#followUserId").val();
		var deleteUserId = "," + userId + ",";
		if (!followUserId) {
			mui.toast("数据错误！");
		} else {
			if (followUserId.indexOf(deleteUserId) < 0) {
				mui.toast("数据错误！");
			} else {
				followUserId = followUserId.replace(deleteUserId, ",");
				if (followUserId == ",") {
					followUserId = "";
				}
				changeFollowUsers(followUserId);
			}
		}
	}
	/**
	 * 变更跟进人数量
	 */

function userCount(followIds) {
		if (!followIds || followIds == ",") {
			$("#followCount").html(1);
		} else {
			if (followIds.indexOf(",") == 0) {
				followIds = followIds.substring(1);
			}
			if (followIds.lastIndexOf(",") == (followIds.length - 1)) {
				followIds = followIds.substring(0, followIds.length - 1);
			}
			var userCount = followIds.split(",").length + 1;
			$("#followCount").html(userCount);
		}
	}
	/**
	 * 变更跟进人
	 * @param {Object} followUserId
	 */

function changeFollowUsers(followUserId) {
		var param = {
			"_clientType": "wap",
			"customerId": customerId,
			"userId": userId,
			"followUserId": followUserId
		};
		_customerApi._changeFollowUser(param, function(data) {
			if (data == 1) {
				mui.toast("修改成功！");
				$("#followUserId").val(followUserId);
				userCount(followUserId);
			} else if (data == 2) {
				mui.toast("没有权限！");
				userCount($("#followUserId").val());
			} else {
				mui.toast("操作失败！");
				userCount($("#followUserId").val());
			}
			_customerApi._findOwnerFollowUsers(param, function(data) {
				$("#followUserDiv").find(".unit-ps").remove();
				if (data && data.follow) {
					mui.each(data.follow, function(index, item) {
						var html = '';
						html += '<div class="unit-img-box unit-ps" userId="'+item.userId+'">';
						html += '  <img class="ml10" src="' + window.windowCommon.photoUrl + '' + item.photo + '" onerror="headError(this);" title="' + item.userName + '" />';
						html += '	 <a>' + item.userName + '</a>';
						html += '  <em class="unit-follow-del" style="display:none;" onclick="deleteFollowUser(' + item.userId + ');"></em>';
						html += '</div>';
						$("#chooseFollower").before(html);
					})
				}
				isNeedRefresh = 1;
			});
		});
	}
	/**
	 * 变更负责人
	 * @param {Object} followUserId
	 */

function changeOwner(ownerId) {
	var param = {
		"_clientType": "wap",
		"customerId": customerId,
		"userId": userId,
		"ownerId": ownerId
	};
	_customerApi._changeOwner(param, function(data) {
		if (data == 1) {
			mui.toast("修改成功！");
			$("#ownerId").val(ownerId);
		} else if (data == 2) {
			mui.toast("没有权限！");
		} else {
			mui.toast("操作失败！");
		}
		_customerApi._findOwnerFollowUsers(param, function(data) {
			if (data && data.owner) { //负责人
				var html = '';
				$("#ownerDiv").html(html);
				html += '<img class="ml10" src="' + window.windowCommon.photoUrl + '' + data.owner.photo + '" onerror="headError(this);" title="' + data.owner.userName + '"/>';
				html += '<a>' + data.owner.userName + '</a>';
				$("#ownerDiv").html(html);
				
				if($("div[userId='"+ownerId+"']")){
					$("div[userId='"+ownerId+"']").remove();
					var followerUserIds = $("#followUserId").val();
					followerUserIds = followerUserIds.replace(","+ownerId+",",",");
					if(followerUserIds == ','){
						followerUserIds = '';
					}
					$("#followUserId").val(followerUserIds)
				}
			}
		});
	});
}

/**
 * 修改销售阶段
 * @param {Object} which 1表示修改销售阶段， 2 表示修改跟进人
 */
function changeChanceState(state) {
		var data = {
			"_clientType": "wap",
			"userId": window.windowCommon.approveLoginId,
			"cid": chanceId,
			"sellStage": state,
			"followUserIds": '',
			"which": 1
		};

		var url = window.windowCommon.basePath + 'crm/chance/modifyChancePart.c';
		mui.ajax(url, {
			data: data,
			dataType: 'json',
			type: 'post', //HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(data) {
				if (data.code == 0) {
					mui.toast("操作失败！");
				} else {
					mui.toast("修改成功！");
				}
			}
		});
	}
	/**
	 * 修改往来单位
	 * @param {Object} name
	 * @param {Object} location
	 * @param {Object} stateStr
	 */

function updateCustomerDetail(name, location, stateStr) {
	var param1 = {
		"_clientType": "wap",
		"customerId": customerId,
		"t": Math.random(),
		"userId": userId
	};
	_customerApi._getCustomerDetail(param1, function(data) {
		$("#customerName").html(data.customerName);
		$("#address").html(data.customerLocation);
		$("#customerState").html(data.customerStateStr);
		$("#followCount").html(data.comFollowUserCount);
		$("#relateCount").html(data.contactCount);
		$("#orderCount").html(data.orderCount);
		$("#chanceCount").html(data.chanceCount);
		$("#followUserId").val(data.followUserId);

		$("#ownerId").val(data.ownerId);
		//刷新跟进人 
		var param = {
			"_clientType": "wap",
			"customerId": customerId,
			"userId": userId,
			"t": Math.random(),
			"followUserId": $("#followUserId").val()
		};
		_customerApi._findOwnerFollowUsers(param, function(data) {
			if (data && data.owner) { //负责人
				var html = '';
				$("#ownerDiv").html(html);
				html += '<img class="ml10" src="' + window.windowCommon.photoUrl + '' + data.owner.photo + '" onerror="headError(this);" title="' + data.owner.userName + '"/>';
				html += '<a>' + data.owner.userName + '</a>';
				$("#ownerDiv").html(html);
			}
			if (data && data.follow) {
				$("#followUserDiv").find(".unit-ps").remove();
				mui.each(data.follow, function(index, item) {
					var html = '';
					html += '<div class="unit-img-box unit-ps" userId="'+item.userId+'">';
					html += '  <img class="ml10" src="' + window.windowCommon.photoUrl + '' + item.photo + '" onerror="headError(this);" title="' + item.userName + '" />';
					html += '	 <a>' + item.userName + '</a>';
					html += '  <em class="unit-follow-del" style="display:none;" onclick="deleteFollowUser(' + item.userId + ');"></em>';
					html += '</div>';
					$("#chooseFollower").before(html);
				})
			}
		});
	});
}

/**
 * 添加联系记录
 */
function toAddRecord(visitType) {
	mui.openWindow({
		url: '../visit/addvisit.html',
		id: 'addvisit',
		extras: {
			'fromType': 2, ////页面来源（1 [来自列表]   2 [来自往来单位详情]    3[来自机会详情]）
			'visitType': visitType, ////拜访类型 (1现场拜访 2沟通联系)
			'customerId': customerId, //单位ID
			'chanceId': '', //机会ID
			"webViewId": plus.webview.currentWebview().id, //新增成功后调用那个页面
			"webViewFunction": "refreshChildData" //新增成功后调用那个页面的那个方法
		}
	});
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
 * 刷新往来单位详情和机会订单列表 
 */
function refreshDetailAndList(){
	getCustomerDetail();
	findChanceOrderUserList();
}

//获得列表数据
function getVisitList() {
	var param = {
		"_clientType": "wap",
		"pageNo": currentPage,
		"pageSize": 2,
		"customerId": customerId,
		"userId": window.windowCommon.approveLoginId
	}
	if (currentPage > totalPage) {
		return false;
	}

	_customerApi._visitList(param, function(jsonData) {
		var jsonDataList = jsonData.list;
		totalPage = jsonData.totalPage;
		if (jsonDataList && jsonDataList.length > 0) {
			if (currentPage == 1) {
				$("#recordList").html('');
			}
			for (var i = 0; i <= jsonDataList.length - 1; i++) {
				var visitdetailId = jsonDataList[i].visitdetailId;
				var html = '<ul class="mui-table-view log" val="' + visitdetailId + '">';

				html += '<li class="mui-table-view-cell shi-time unit-ps">';
				html += '<em class="time-ico"></em>';
				html += '<span>' + jsonDataList[i].visitTime + '</span>';
				html += '</li>';
				html += '<li class="mui-table-view-cell mui-media log-user">';
				html += '<img class=" mui-pull-left shi-ppic" src="' + window.windowCommon.photoUrl + jsonDataList[i].createUserPhoto + '" title="' + jsonDataList[i].createUserName + '" onerror="headError(this);">';
				html += '<div class="mui-media-body">';
				html += '' + jsonDataList[i].createUserName + '';
				html += '</div>';
				html += '</li>';
				html += '<div class="content" id="xq">';
				html += '<ul class="content-list" id="list1">';
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
/**
 * 变更客户状态
 * @param {Object} state
 */
function changeCustomerState(obj){
	var param = {
		"_clientType":"wap",
		"customerId":customerId,
		"state":$(obj).attr("val"),
		"userId":window.windowCommon.approveLoginId
	};
	_customerApi._changeCustomerState(param,function(data){
		if(data==1){
			isNeedRefresh=1;
			mui.toast("操作成功");
			$(obj).addClass("month-active");
			$(obj).siblings().removeClass("month-active");
			$("#customerState").html($(obj).html());//改变span内容
			$("#cState").val($(obj).attr("val"));//隐藏域赋值
			mui("#statePopover").popover('toggle');
		}else{
			mui.toast("操作失败");
		}
	});
}

