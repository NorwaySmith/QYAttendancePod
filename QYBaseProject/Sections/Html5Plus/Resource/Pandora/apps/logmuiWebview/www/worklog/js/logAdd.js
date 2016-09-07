mui.plusReady(function() {
	//判断当前是否有网络
	if (!getNetConnection()) {
		$(".mui-content").hide();
		$(".noNet").show();
		return false;
	}
	//获取服务器当前时间
	var url = window.windowCommon.basePath + 'worklog/getSystemTime.c';
	mui.ajax(url, {
		data: {
			"_clientType": "wap"
		},
		dataType: 'json', //服务器返回json格式数据
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(response) {
			var dateObj = document.getElementById("dateStr");
			var weekObj = document.getElementById("weekStr");
			var timeObj = document.getElementById("timeStr");

			var hours = response.hour;
			if (hours < 10) {
				hours = "0" + hours;
			}
			var minutes = response.minute;
			if (minutes < 10) {
				minutes = "0" + minutes;
			}

			dateObj.innerHTML = (response.month + 1) + "月" + response.monthday + "日";
			weekObj.innerHTML = "日一二三四五六".charAt(response.weekday - 1);
			timeObj.innerHTML = hours + ":" + minutes;
		},
		error: function(xhr, type, errorThrown) {
			//异常处理；
			//alert(errorThrown);
			//alert("系统异常");
		}

	});
	/*mui.post(url, data, function(response) {
		var dateObj = document.getElementById("dateStr");
		var weekObj = document.getElementById("weekStr");
		var timeObj = document.getElementById("timeStr");

		var hours = response.hour;
		if (hours < 10) {
			hours = "0" + hours;
		}
		var minutes = response.minute;
		if (minutes < 10) {
			minutes = "0" + minutes;
		}

		dateObj.innerHTML = (response.month + 1) + "月" + response.monthday + "日";
		weekObj.innerHTML = "日一二三四五六".charAt(response.weekday - 1);
		timeObj.innerHTML = hours + ":" + minutes;

	}, 'json');*/

	//获取地理位置
	if (plus.os.name == 'iOS') {
		//调用手机端IOS，获取地理位置API
		plus.qytxplugin.localMessage("", function(data) {
			//赋值
			outSet(data);
		});
	} else {
		getPosBaidu();
	}

	//绑定点击事件
	var next = document.getElementById("next");
	next.addEventListener("click", function() {
		var successContent = $("#successContent").val();
		if (null == successContent || "" == successContent || "" == $.trim(successContent) || $.trim(successContent).length < 25) {
			mui.toast("请输入已完成工作，不少于25个字！");
			return;
		}
		nextMethod();
	})

	//绑定添加图片事件
	var addimg = document.getElementById("addimg");
	addimg.addEventListener("tap", function() {
		galleryImgs();
	})

})

/**
 * 下一步，时间
 */
function nextMethod() {
	var successContent = document.getElementById("successContent").value;
	if (successContent == null || successContent == "" || $.trim(successContent) == '') {
		mui.toast("已完成的工作不能为空！")
		return false;
	}

	var isFinish = isCompleted();
	if (!isFinish) {
		mui.alert("正在上传，请稍等...");
		return false;
	}
	var attachmentIds = "";
	for (var i = 0; i < taskArr.length; i++) {
		if (i == 0) {
			attachmentIds += taskArr[i].attachmentId;
		} else {
			attachmentIds += "," + taskArr[i].attachmentId
		}
	}
	$("#attachmentIds").val(attachmentIds);
	//调用人员树，选择人员
	selectUser();//模拟数据，发布需解除注释
//	$("#userIds").val("10987542,"); //模拟数据，发布需注释掉
	//console.log("userIds=" + $("#userIds").val());
//	submit("10987542,");
}

/**
 * 选择人员
 * @param {Object} obj
 */
function selectUser(obj) {
	plus.qytxplugin.selectUsers("", 0, function(data) {
		var userIds = "";
		if (data) {
			for (var i = 0; i < data.length; i++) {
				var userId = data[i].userId;
				userIds += userId + ",";
			}
		}
		if (userIds == "") {
			mui.alert("请选择人员！");
		} else {
			submit(userIds);
		}

	});
}

/**
 * 提交
 * @param {Object} userIds 被转发人
 */
function submit(userIds) {
	//显示提交等待
	showWaiting("处理中，请等待...");
	var successContent = document.getElementById("successContent").value;
	var failContent = document.getElementById("failContent").value;
	var tieContent = document.getElementById("tieContent").value;
	var memo = document.getElementById("memo").value;
	var attachmentIds = document.getElementById("attachmentIds").value;
	if (userIds != null && userIds != "") {
		userIds = userIds.substring(0, userIds.length - 1);
	}
	//console.log(attachmentIds)
	var createAddress = document.getElementById("output").innerHTML;
	//发送数据
	mui.ajax(window.windowCommon.basePath + 'worklog/saveWorkog.c', {
		data: {
			"successContent": successContent,
			"failContent": failContent,
			"tieContent": tieContent,
			"memo": memo,
			"attachmentIds": attachmentIds,
			"userIds": userIds,
			"createAddress": createAddress,
			"userId": window.windowCommon.approveLoginId,
			"_clientType": "wap"
		},
		dataType: 'text', //服务器返回json格式数据
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(msg) {
			//关闭提交等待
			closeWaiting();
			//服务器返回响应，根据响应结果，分析是否登录成功；
			if (msg.indexOf("100||") == 0) {
				if (msg.split("||")[1] == 1) {
					//新建成功，加跳转操作
					//跳转到我发布的列表
					plus.nativeUI.closeWaiting();
					window.location.href = "logMyPublish.html";
				} else {
					mui.alert("新建失败");
				}
			} else {
				mui.alert("新建失败");
			}
		},
		error: function(xhr, type, errorThrown) {
			//关闭提交等待
			closeWaiting();
			//异常处理；
			mui.toast("请求数据异常");
		}
	});
}
// 扩展API加载完毕后调用onPlusReady回调函数 
document.addEventListener("plusready", onPlusReady, false);
var r = null;
// 扩展API加载完毕，现在可以正常调用扩展API 
/**
 * mui上传图片
 */
function galleryImgs() {

	// 从相册中选择图片
	plus.gallery.pick(function(e) {
		if (taskArr.length == 2) { //如果已经上传2张图片，当上传第三张时，隐藏上传按钮
			$("#addimg").hide();
		}
		var innerHtml = "";
		// 分割获取文件名
		var file = e;
		var pathArr = file.split("/");
		var fileId = Math.floor(Math.random() * 100000 + 1);
		innerHtml += "<div class=\"img\" id='d_" + fileId + "'>";
		innerHtml += "<img src='" + file + "' width=\"67\" height=\"67\" data-preview-src='' data-preview-group='2'/>";
		innerHtml += "<i class=\"delete\" onclick=\"abortUpload(" + fileId + ")\"></i>";
		innerHtml += "</div>";
		//innerHtml += "<i><span id='" + fileId + "'>0%</span></i>";
		createUpload(file, fileId, pathArr[pathArr.length - 1]);
		$("#addimg").before(innerHtml);
		mui.previewImage();
		/*var goods = mui(".delete")[0];
		goods.addEventListener("tap", function() {
			abortUpload(fileId);
		});*/
	});

}
// 扩展API加载完毕后调用onPlusReady回调函数 
var r = null;
// 扩展API加载完毕，现在可以正常调用扩展API
function onPlusReady() {}
var taskArr = new Array();

/**
 * 创建上任务
 * @param {Object} filePath 本地文件路径
 * @param {Object} id 文件ID
 * @param {Object} fileName 文件名
 */
function createUpload(filePath, id, fileName) {
	// 保存上传任务
	var taskObj = new Object();
	taskObj.id = id;
	// 上传状态 0 上传中 1完成 2取消
	taskObj.status = 0;
	//上传
	var task = plus.uploader.createUpload(window.windowCommon.basePath + "worklog/upload.c?_clientType=wap&fileId=" + id, {}, function(t, status) {
		// 上传完成
		if (status == 200) {
//			alert("上传成功！");
		} else {
			console.log("上传图片失败");
		}
	});
	task.addFile(filePath, {
		key: fileName
	});
	task.addEventListener("statechanged", onStateChanged, false);
	task.addData("fileName", fileName);
	taskObj.task = task;
	taskArr.push(taskObj);
	task.start();
}
// 监听上传任务状态

function onStateChanged(upload, status) {
	// 获取ID， 更新进度
	var fileId = "";
	var url = upload.url;
	var paramArr = url.split("?");
	if (paramArr.length > 1) {
		paramArr = paramArr[1];
		paramArr = paramArr.split("&");
		for (var i = 0; i < paramArr.length; i++) {
			var param = paramArr[i];
			var paramStrArr = param.split("=");
			if ("fileId" == paramStrArr[0]) {
				fileId = paramStrArr[1];
				break;
			}
		}
	}
	// 计算上传百分比
	var uploadedSize = upload.uploadedSize;
	var totalSize = upload.totalSize;
	if (0 != totalSize) {
		var percent = parseInt(uploadedSize * 100 / totalSize);
		if ("" != fileId) {
			console.log(percent+"%");
			//$("#" + fileId).html(percent + "%");
			//$("#p_"+fileId).html(formatSize(totalSize));
		}
	}
	
	if (upload.state == 4 && status == 200) {
		//上传完成更新上传状态为已完成
		for (var i = 0; i < taskArr.length; i++) {
			var id = taskArr[i].id;
			if (id == fileId) {
				taskArr[i].status = 1;
				// 保存服务器返回的附件Id
				taskArr[i].attachmentId = $.parseJSON(upload.responseText).attachmentId;
				taskArr[i].path = $.parseJSON(upload.responseText).path;
				taskArr[i].name = $.parseJSON(upload.responseText).name;
				taskArr[i].size = $.parseJSON(upload.responseText).size;
				break;
			}
		}
	}
}

// 判断是否上传完成

function isCompleted() {
	var complete = true;
	for (var i = 0; i < taskArr.length; i++) {
		var status = taskArr[i].status;
		console.log(status);
		if (status == 0) {
			complete = false;
			break;
		}
	}
	return complete;
}

// 取消上传任务
function abortUpload(fileId) {
	var arrCursor = 0;
	var isExist = false;
	for (var i = 0; i < taskArr.length; i++) {
		var id = taskArr[i].id;
		if (fileId == id) {
			/*count--;
			$("#count").empty().html("共" + count + "个");
			if (count == 0) {
				$(".annex").hide();
			}*/
			arrCursor = i;
			var task = taskArr[i].task;
			task.abort();
			taskArr[i].status = 2;
			$("#d_" + fileId).hide();
			$("#" + fileId).hide();
			isExist = true;
			//todo 隐藏上传进度条及文件信息						
			break;
		}
	}
	if (isExist) {
		taskArr.splice(arrCursor, 1);
	}
	$("#addimg").show();
}

// 通过百度定位模块获取位置信息
function getPosBaidu() {
	console.log("获取百度定位位置信息...");
	plus.geolocation.getCurrentPosition(geoInf, function(e) {
		outSet("无法定位");
	}, {
		provider: 'baidu'
	});
}

/**
 * 定位成功回调
 * @param {Object} position 地点信息
 */
function geoInf(position) {
	var str = "";
	if (position.addresses == undefined) {
		outSet("无法定位");
	} else {
		str += position.addresses; //获取地址信息
		outSet(str);
	}

}