/**
 * 联系记录详细信息页面js
 */
var visitdetailId = "";

var viewId;
var callbackFun; //来源页面回调函数
var isNeedRefresh = 0; //是否需要刷新来源页面

mui.plusReady(function() {
	var self = plus.webview.currentWebview();
	visitdetailId = self.visitdetailId;
	viewId = self.viewId;
	callbackFun = self.callbackFun;

	mui.init({
		beforeback: function() {
			if (viewId && callbackFun && isNeedRefresh) {
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun + "();");
			}
		}
	});

	//绑定编辑事件
	document.querySelector("#edit").addEventListener("tap", function() {
		mui('#popover3').popover('toggle');
		mui.openWindow({
			url: "editvisit.html",
			id: "editvisit",
			extras: {
				visitId: visitdetailId,
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshDetail"
			}
		})
	});
	//绑定删除事件
	document.querySelector("#del").addEventListener("tap", function() {
		mui.confirm('确认删除吗？', null, null, function(e) {
			if (e.index == 0) {
				del(visitdetailId);
			} else if (e.index == 1) {
				console.log('取消');
			}
		});
	});

	getVisitInfo();

	$("#operate")[0].addEventListener("tap", function() {
		mui("#popover3").popover("toggle");
	});

	//绑定评论事件
	document.getElementById("fabiao").addEventListener('tap', function() {
		fabiao();
	});

	//绑定点赞事件
	$("#praiseAndComment").on("tap", ".good", function() {
		delPraise(this);
	});

	//绑定取消点赞事件
	$("#praiseAndComment").on("tap", ".nogood", function() {
		praise(this);
	});

});

/**
 * 刷新详情内容
 */
function refreshDetail() {
	isNeedRefresh = 1;
	getVisitInfo();
}

/**
 * 获取详情
 */
function getVisitInfo() {
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"visitdetailId": visitdetailId
	}
	visitApi.getVisitInfo(param, function(jsonData) {
		//权限操作处理
		if (jsonData.createUserId != window.windowCommon.approveLoginId) {
			$("#operate").hide();
		}
		if (jsonData.visitType == 1) {
			document.getElementById("visitType").innerHTML = '现场拜访：';
			$("#visitTypeVo").html(jsonData.visitPoistion);
			$("#customerType").html("拜访单位：");
		} else if (jsonData.visitType == 2) {
			document.getElementById("visitType").innerHTML = '沟通对象：';
			$("#visitTypeVo").html(jsonData.communicationUserName +'<span class="centre-text">（'+jsonData.communicationModeName+'沟通）</span>');
			$("#customerType").html("联系单位：");
		}
		$("#customerName").html(jsonData.customerName);
		$("#visitTime").text(jsonData.visitTime);
		$("#userName").text(jsonData.createUserName);
		$("#headImg").attr("src", window.windowCommon.photoUrl + jsonData.createUserPhoto);
		$("#headImg").attr("title", jsonData.createUserName);

		$("#visitContent").text(jsonData.visitContent);
		$("#visitDiffence").text(jsonData.visitDiffence);
		$("#nextVisitTime").text(jsonData.nextVisitTime);
		$("#nextVisitMaincontent").text(jsonData.nextVisitMaincontent);
		$(".imgarea").html('');
		var paths = jsonData.paths;
		var imgPath = paths.split(",");
		if(paths!=""){
			for (var n = 0;n<imgPath.length;n++ ) {
				var innerHtml = '<div><img onerror="recordImgError(this);" src="'+window.windowCommon.basePath+'crm/visitrecord/download.c?_clientType=wap&userId='+window.windowCommon.approveLoginId+'&filePath='+imgPath[n]+'" alt="" data-preview-src="" data-preview-group="2"/></div>';
				$(".imgarea").append(innerHtml);
			}
			mui.previewImage();
		}
		var visitRecord = jsonData.visitRecordCommentList;
		var html = '';
		if (visitRecord.length > 0) {
			html += '<a href="javascript:void(0);" class="comment mui-pull-right"><em>' + visitRecord.length + '</em></a>';
		} else {
			html += '<a href="javascript:void(0);" class="comment mui-pull-right"><em></em></a>';
		}

		if (jsonData.isPraise == 1) {
			html += '<a href="javascript:void(0);" class="good mui-pull-right" visitdetailId="' + visitdetailId + '">';
		} else {
			html += '<a href="javascript:void(0);" class="nogood mui-pull-right" visitdetailId="' + visitdetailId + '">';
		}
		if (jsonData.praiseCount > 0) {
			html += '<em class="remind" id="pl">' + jsonData.praiseCount + '</em></a>';
		} else {
			html += '<em class="remind" id="pl"></em></a>';
		}
		document.getElementById("praiseAndComment").innerHTML = html;
		var html2 = '';
		var visitRecordCommentList = jsonData.visitRecordCommentList;
		if (visitRecordCommentList.length > 0) {
			for (var k = 0; k <= visitRecordCommentList.length - 1; k++) {
				html2 += '<li>';
				html2 += '<div class="shi-visit-reply">';
				html2 += '<a class="shi-nm">' + visitRecordCommentList[k].userName + '</a><a class="shi-data">' + visitRecordCommentList[k].createTime + '</a>';
				html2 += '</div>';
				html2 += '<a class="shi-ly">' + visitRecordCommentList[k].content + '</a>';
				html2 += '</li>';
			}
		}
		document.getElementById("comment").innerHTML = html2;
	
	});
}


/**
 * 点赞
 * @param {Object} obj
 */
function praise(obj) {
	plus.nativeUI.showWaiting("等待中...");
	var num = "";
	if ($(obj).children().html() == "") {
		num = 1;
	} else {
		num = parseInt($(obj).children().html()) + parseInt(1);
	}
	var visitdetailId = $(obj).attr("visitdetailId");
	var param = {
		"_clientType": "wap",
		"visitdetailId": visitdetailId,
		"userId": window.windowCommon.approveLoginId
	}
	visitApi.savevisitPraise(param, function(data) {
		$(obj).children().text(num);
		$(obj).removeClass("nogood").addClass("good mui-pull-right");
		isNeedRefresh = 1;
		plus.nativeUI.closeWaiting();
	}, function() {
		//异常处理；
		plus.nativeUI.closeWaiting();
		console.log(errorThrown);
	});
}

/**
 * 取消点赞
 * @param {Object} obj
 */
function delPraise(obj) {
	plus.nativeUI.showWaiting("等待中...");
	var num = "";
	if ($(obj).children().html() == "") {
		num = "";
	} else {
		num = parseInt($(obj).children().html()) - parseInt(1);
	}
	if (num == 0) {
		num = "";
	}
	var visitdetailId = $(obj).attr("visitdetailId");
	var param = {
		"_clientType": "wap",
		"visitdetailId": visitdetailId,
		"userId": window.windowCommon.approveLoginId
	}
	visitApi.delvisitPraise(param, function(data) {
		$(obj).children().text(num);
		$(obj).removeClass("good").addClass("nogood");
		isNeedRefresh = 1;
		plus.nativeUI.closeWaiting();
	}, function() {
		//异常处理；
		plus.nativeUI.closeWaiting();
		console.log(errorThrown);
	});
}

/**
 * 评论
 */
function fabiao() {
	plus.nativeUI.showWaiting("等待中...");
	var content = $.trim($("#content").val());
	if (content == "") {
		plus.nativeUI.closeWaiting();
		mui.toast("请输入内容");
		return;
	}
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"visitdetailId": visitdetailId,
		"content": content
	}
	visitApi.saveComment(param, function(data) {
		plus.nativeUI.closeWaiting();
		mui.toast("评论成功！");
		document.getElementById("content").value = "";
		refreshDetail();
	}, function() {
		//异常处理；
		console.log(errorThrown);
		plus.nativeUI.closeWaiting();
		mui.toast("请求数据异常！");
	});

}


/**
 * 删除
 * @param {Object} a
 */
function del(visitdetailId) {
	plus.nativeUI.showWaiting("等待中...");
	var param = {
		"_clientType": "wap",
		"visitdetailId": visitdetailId,
		"userId": window.windowCommon.approveLoginId
	}
	visitApi._delRecord(param, function(data) {
		plus.nativeUI.closeWaiting();
		if (data == 1) {
			mui.toast("删除成功");
			//刷新列表
			if (viewId && callbackFun) {
				plus.webview.getWebviewById(viewId).evalJS(callbackFun + "();");
			}
			//关闭当前页面
			plus.webview.currentWebview().close();
		} else if (data == 2) {
			mui.toast("没有删除权限");
		}

	}, function() {
		//异常处理；
		plus.nativeUI.closeWaiting();
		mui.toast("删除失败");
	})
}

/**
 * 联系记录图片错误回调方法 
 */
function recordImgError(obj){
	$(obj).attr("src","../../images/error.png");
}
