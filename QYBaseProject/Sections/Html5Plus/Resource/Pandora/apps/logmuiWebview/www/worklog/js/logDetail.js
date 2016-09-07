var logid = null;//日志ID
var fromPage = null;//来源页面
var praiseNum = 0;//点赞总数
var commentNum = 0;//评论总数
mui.init({
	gestureConfig:{
		tap:true
	}
});
mui.plusReady(function() {
	setBackUrl("");
	//判断当前是否有网络
	if(!getNetConnection()){
		$(".mui-content").hide();
		$(".noNet").show();
		return false;
	}
	var mapParam=getPageParam("log_detail");
	logid=mapParam.get("logid");
	var logUserId=mapParam.get("logUserId");//日志发布人
	if (logUserId == window.windowCommon.approveLoginId) {
		mui("#clickPraise span")[0].innerHTML = '自赞';
		mui("#publishComment span")[0].innerHTML = '自评';
		//mui(".mui-title")[0].innerHTML = '我发布的';
	} else {
		mui("#clickPraise span")[0].innerHTML = '赞';
		mui("#publishComment span")[0].innerHTML = '评论';
		//mui("#deleteWorklog").parent().hide();
		mui("#deleteWorklog")[0].parentElement.style.display = "none";
		//mui(".mui-title")[0].innerHTML = '我收到的';
	}
	//如果日志发布人==当前登录人    获取日志信息，并刷新最后查看时间
	if (logUserId == window.windowCommon.approveLoginId) {
		getLogInfo(logid, 0, verifySelfPraise);
	} else {//否则获取日志信息，不刷新最后查看时间
		getLogInfo(logid, 1, verifySelfPraise);
	}
	//绑定点赞/取消赞方法
	document.getElementById("clickPraise").addEventListener('touchstart', function() {
		clickPraise(logid);
	});

	//绑定删除方法
	document.getElementById("deleteWorklog").addEventListener('touchstart', function() {
		deleteWorklog(logid);
	});


	//绑定评论方法
	document.getElementById("publishComment").addEventListener('touchstart', function() {
		publishComment(logid);
	});

	//绑定转发方法
	document.getElementById("forwardingWorklog").addEventListener('touchstart', function() {
		forwardingWorklog();
	});

	//整个详情区域绑定方法
	mui(".mui-content")[0].addEventListener('touchstart', function() {
		plus.webview.close("worklogpublishcomment");
	});


	//绑定评论发表
	document.getElementById("publish").addEventListener('touchstart', function() {
		publicRizi(logid);
	});
});

/**
 * 处理自赞样式 
 * @param {Object} run
 */
var verifySelfPraise = function(run) {
	if (run) {
		var praiseUserIds = document.getElementById("praiseUserIds").value;
		if (praiseUserIds.indexOf(',' + window.windowCommon.approveLoginId + ',') == -1) {;
		} else {
			mui("#clickPraise span")[0].setAttribute("class", "active");
		}
	}
}

/**
 * 转发方法
 */
var forwardingWorklog = function() {
	var defaultUserIds = $("#userIds").val(); // 原转发人
	var userIds = ""; //新转发人
	var userId = "";
	//调用手机端API
	plus.qytxplugin.selectUsers("", 0, function(data) {
		if (data) {
			for (var i = 0; i < data.length; i++) {
				userId = data[i].userId;
				if (defaultUserIds.indexOf("," + userId + ",") < 0) {
					userIds = userIds + userId + ",";
				}
			}
			if (data.length == 0) {
				mui.alert('请选择转发人！');
			} else {
				submit(userIds);
			}
		}

	});

}

//提交
function submit(userIds) {
	if (userIds == "") {
		mui.alert("转发成功");
		return;
	}
	var mapParam=getPageParam("log_detail");
	var logid=mapParam.get("logid");
	var logUserId=mapParam.get("logUserId");//日志发布人
	//发送数据
	mui.ajax(window.windowCommon.basePath + 'worklog/forwardingWorklog.c', {
		data: {
			"userId": logUserId,
			"userIds": userIds,
			"worklogId": logid,
			"_clientType": "wap"
		},
		dataType: 'json', //服务器返回json格式数据
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(data) {
			//服务器返回响应，根据响应结果，分析是否登录成功；
			if (data.code == 1) {
				mui.alert("转发成功");
			} else {
				mui.alert("转发失败");
			}
		},
		error: function(xhr, type, errorThrown) {
			//异常处理；
			//alert(errorThrown);
			//alert("系统异常");
		}
	});
}



/**
 * 评论的方法
 * 评论输入框和发布按钮隐藏显示切换
 */
var publishComment = function(worklogId) {
	//alert(mui(".fixedBtnArea")[0].innerHTML);
	document.getElementById("content").value = "";
	mui("#publishCommentDIV")[0].style.visibility = "visible";
	document.body.scrollTop = document.body.scrollHeight;
	mui("#oparationDIV")[0].style.visibility = "hidden";
	//	mui.openWindow({
	//	    url: 'worklogpublishcomment.html',
	//	    id: 'worklogpublishcomment',
	//	    styles:{
	//			//top: 50,//新页面顶部位置
	//			bottom: 0,//新页面底部位置
	//			//width:newpage-width,//新页面宽度，默认为100%
	//			height: 75//新页面高度，默认为100%
	//	    },
	//	    extras:{
	//			//自定义扩展参数，可以用来处理页面间传值
	//			"logid": worklogId,
	//			"logUserId":window.windowCommon.approveLoginId
	//	    },
	//	    createNew:false//是否重复创建同样id的webview，默认为false:不重复创建，直接显示
	//	});
}

/**
 * 删除工作日志
 */
var deleteWorklog = function(worklogId) {
	//var btn = ["确定","取消"];
	mui.confirm('确认删除该日志吗？', null, null, function(e) {
		if (e.index == 0) {
			var url = window.windowCommon.basePath + 'worklog/deleteWorklog.c';
			var data = {
				"userId": window.windowCommon.approveLoginId,
				"worklogId": worklogId
			};

			mui.ajax(url, {
				data: data,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(response) {
					if (response.code != 0) {
						mui.back();
						//清理列表缓存
						clearCacheData("log_myPublish_data");
						clearCacheData("log_myReceive_data");
					}
				}
			});
		} else if (e.index == 1) {
		}
	});
	/*
	mui.confirm("确定删除该日志吗？", function(){
		console.log('确定');
		var url = window.windowCommon.basePath + 'worklog/deleteWorklog.c';
		
		var data = {
			"userId": window.windowCommon.approveLoginId,
			"worklogId": worklogId
		};

		mui.post(url, data, function(response){
			if(response.code != 0){
				mui.toast("将要进入列表。");
				plus.webview.close("worklogDetail");
			}
		}, 'json');
		}
	);
	*/
}

//这个n用来控制 clickPraise 方法的重复点击
var n = 0;
/**
 * 点赞/取消赞
 */
var clickPraise = function(worklogId) {
	//防止连击点赞
	if (n++ > 0) {
		console.log('无操作');
		return;
	}
	//（plus true表示点赞，false表示取消赞）
	var plus = false;

	var spanObj = mui("#clickPraise span")[0];
	var spanclass = spanObj.getAttribute("class");
	if (spanclass == 'active') {

	} else {
		plus = true;
	}

	var url = window.windowCommon.basePath + 'worklog/clickPraise.c';

	var data = {
		"userId": window.windowCommon.approveLoginId,
		"plus": plus,
		"worklogId": worklogId
	};

	mui.ajax(url, {
		data: data,
		dataType: 'json',
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(response) {
			if (response.code != 0) {
				if (response.plus) {
					spanObj.setAttribute("class", "active");
				} else {
					spanObj.removeAttribute("class");
				}
				if (response.praisenames == undefined) {
					mui(".goods-user span")[0].innerHTML = '';
				} else {
					mui(".goods-user span")[0].innerHTML = response.praisenames;
				}
				praiseNum = response.num;
				mui(".goods-user span")[1].innerHTML = '共' + response.num + '人觉得很赞';
				if (response.num > 0) {
					var goods = mui(".goods-user")[0];
					goods.addEventListener("tap", openWorkloggoods);
				} else {
					var goods = mui(".goods-user")[0];
					goods.removeEventListener("tap", openWorkloggoods);
				}
				//清理列表缓存
				clearCacheData("log_myPublish_data");
				clearCacheData("log_myReceive_data");
			}
			n = 0;
		}
	});
}

/**
 * 打开点赞人员列表
 */
function openWorkloggoods() {
	var mapParam=new Map();
	mapParam.put("logid",logid);
	setPageParam("log_praiseList",mapParam);
	window.location.href="logPraiseList.html";
}

/**
 * 获取工作日志详情
 * @param {Object} logid 日志主键ID
 * @param {Object} refresh 是否刷新（0表示不刷新、1表示刷新）
 * @param {Object} callback 回调方法
 * @param {Object} isTop 是否滚动条回到顶部
 */
function getLogInfo(logid, refresh, callback, isTop) {

	//发送数据
	mui.ajax(window.windowCommon.basePath + 'worklog/getLogInfo.c', {
		data: {
			"logid": logid,
			"refresh": refresh,
			"_clientType": "wap"
		},
		dataType: 'text', //服务器返回json格式数据
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(msg) {
			var run = false;
			//服务器返回响应，根据响应结果，分析是否登录成功；
			if (msg.indexOf("100||") == 0) {
				run = true;
				msg = msg.substring("100||".length);
				var json = eval('(' + msg + ')');
				var message = '';
				var div = document.body.querySelector('.mui-row');
				message += "<input type=\"hidden\" id=\"userIds\" value=\"" + json.publishUserIds + "\"/>";
				message += "<input type=\"hidden\" id=\"praiseUserIds\" value=\"" + json.praiseUserIds + "\"/>";
				message += "<ul class=\"mui-table-view logDetail\">";
				message += "<li class=\"mui-table-view-cell mui-media log-user\">";
				message += '<img  class="mui-media-object mui-pull-left" src="' + window.windowCommon.photoUrl + json.createUserPhoto + '" title="' + json.createUserName + '"  onerror="headRectError(this);"/>';
				message += "<div class=\"mui-media-body\">";
				message += json.createUserName;
				message += "<time class=\"mui-pull-right\">" + json.createTimeStr + "</time>";
				message += "</div>";
				message += "</li>";

				message += "<div class=\"content\">";
				message += "<ul class=\"content-list\">";
				message += "<li style=\"word-break:break-all\">";
				message += "<span class=\"state\"><i class=\"state-1\"></i>已完成工作</span> " + json.successContent;
				message += "</li>";
				message += "<li style=\"word-break:break-all\">";
				message += "<span class=\"state\"><i class=\"state-2\"></i>未完成工作</span> " + json.failContent;
				message += "</li>";
				message += "<li style=\"word-break:break-all\">";
				message += "<span class=\"state\"><i class=\"state-3\"></i>需协调工作</span> " + json.tieContent;
				message += "</li>";
//				message += "<li style=\"word-break:break-all\">";
//				message += "<span class=\"state\"><i class=\"state-4\"></i>备&nbsp;&nbsp;&nbsp;&nbsp;注</span>" + json.memo;
//				message += "</li>"
				message += "<li class=\"img-group\">";
				var imgs = json.worklogFile;
				for (var i = 0; i < imgs.length; i++) {
					message += "<img src=\"" + window.windowCommon.basePath + "worklog/download.c?filePath=" + imgs[i].filePath + "\" alt=\"\" width=\"67\" height=\"67\" data-preview-src='' data-preview-group='1'/>";
				}
				message += "</li>";
				message += "<li style=\"padding-left:0px\">";
				message += "<span class=\"address\" style=\"left:-30px\">" + json.address + "</span>";
				message += "</li>";
				message += "</ul>";
				message += "<div class=\"goods-user\">";
				message += "<ul class=\"mui-table-view\">";
				message += "<li class=\"mui-table-view-cell\">";
				message += "<a class=\"mui-navigate-right\">";
				message += "<span class=\"red-good mui-ellipsis\">";
				var praises = json.worklogPraise;
				var praisesNames = "";
				for (var i = 0; i < praises.length; i++) {
					if (i < 5) {
						praisesNames += praises[i].praiseName + "，"
					}
				}
				if (praisesNames != "") {
					praisesNames = praisesNames.substring(0, praisesNames.length - 1);
				}
				message += praisesNames;
				message += "</span>";
				praiseNum = json.worklogPraiseSize;
				message += "<span class=\"think-good\">共" + json.worklogPraiseSize + "人觉得很赞</span>";
				message += "</a>";
				message += "</li>";
				message += "</ul>";
				message += "</div>";
				commentNum = json.worklogCommentSize;
				message += "<div class=\"comment-panel\">";
				message += "<h5>评论区<em>(" + json.worklogCommentSize + ")</em></h5>";
				message += "<ul class=\"mui-table-view\">";
				var comments = json.worklogComment;
				for (var i = 0; i < comments.length; i++) {
					message += "<li class=\"mui-table-view\">";
					message += '<img class="mui-media-object mui-pull-left" src="' + window.windowCommon.photoUrl + comments[i].photo + '"  title="' + comments[i].name + '"  onerror="headRectError(this);">';
					message += "<div class=\"mui-media-body\">";
					message += "<p class=\"name\">" + comments[i].name + "</p>";
					message += "<time>" + comments[i].time + "</time>";
					message += "<p class=\"text\" style=\"word-break:break-all;margin-top:-6px;\">" + comments[i].content + "</p>";
					message += "</div>";
					message += "</li>";
				}

				message += "</ul>";
				message += "</div>";
				message += "<div  style=\"padding-top:10px\"></div>";

				message += "</div>";
				message += "</ul>";

				div.innerHTML = message;
				//var div = document.body.querySelector('.mui-row');
				if (json.worklogPraiseSize > 0) {
					var goods = mui(".goods-user")[0];
					goods.addEventListener("tap", openWorkloggoods);
				};
				mui.previewImage();

				if (isTop) {
					document.body.scrollTop = document.body.scrollHeight;
				}
			} else {
				run = false;
				mui.toast("该日志已经被作者删除");
//				if (plus.webview.currentWebview().logUserId == window.windowCommon.approveLoginId) {
//					plus.webview.getWebviewById('worklogrelease').evalJS("clicksearch()");
//				} else {
//					plus.webview.getWebviewById('worklogreceive').evalJS("getlist()");
//				}
				mui.back();
			}

			if (callback != null && callback != undefined) {
				callback(run);
			}
		},
		error: function(xhr, type, errorThrown) {
			//异常处理；
			//alert(errorThrown);
			//alert("系统异常");
		}
	});
}

/**
 * 发表评论
 * @param {Object} logid 日志ID
 */
function publicRizi(logid) {
	//评论内容
	var content = document.getElementById("content").value;
	if (content != '' && content != null && content != undefined && $.trim(content) != '') {
		var url = window.windowCommon.basePath + 'worklog/publishComment.c';
		var data = {
			"userId": window.windowCommon.approveLoginId,
			"worklogId": logid,
			"content": content
		};
		document.getElementById("content").value = '';
		mui.ajax(url, {
			data: data,
			dataType: 'json',
			type: 'post', //HTTP请求类型
			timeout: 10000, //超时时间设置为10秒；
			crossDomain: true,
			success: function(response) {
				if (response.code != 0) {
					//隐藏评论区域、显示点赞区域
					mui("#publishCommentDIV")[0].style.visibility = "hidden";
					mui("#oparationDIV")[0].style.visibility = "visible";
					getLogInfo(logid, 1, null, true);
					//清理列表缓存
					clearCacheData("log_myPublish_data");
					clearCacheData("log_myReceive_data");
				}
			}
		});
	} else {
		document.getElementById("content").value = '';
	}
}