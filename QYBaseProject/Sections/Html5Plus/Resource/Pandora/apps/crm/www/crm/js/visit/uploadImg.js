/**
 * 上传图片js
 */
// 扩展API加载完毕后调用onPlusReady回调函数
document.addEventListener("plusready", onPlusReady, false);
var r = null;
// 扩展API加载完毕，现在可以正常调用扩展API 
function galleryImgs() {
		/*if(taskArr.length>=3){
			mui.alert("最多上传3张图片");
			return;
		}*/
		// 从相册中选择图片
		//console.log("从相册中选择多张图片:");
		plus.gallery.pick(function(e) {
			if((imgNum+taskArr.length)==2){//如果已经上传2张图片，当上传第三张时，隐藏上传按钮
				$("#addimg").hide();
			}
			var innerHtml = "";

			// 分割获取文件名
			var file = e;
			var pathArr = file.split("/");
			var fileId = Math.floor(Math.random() * 100000 + 1);

			innerHtml += "<div class=\"img\" id='d_" + fileId + "' style=\"width:67px;height:67px;background-color:#d9d9d9;\">";
			innerHtml += "<img src='" + file + "' style=\"max-width:67px;max-height:67px;margin:auto;\" data-preview-src='' data-preview-group='2'/>";
			innerHtml += "<i class=\"delete\" onclick=\"abortUpload("+fileId+")\"></i>";
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

function createUpload(filePath, id, fileName) {
		// 保存上传任务
		var taskObj = new Object();
		taskObj.id = id;
		// 上传状态 0 上传中 1完成 2取消
		taskObj.status = 0;
		var task = plus.uploader.createUpload(window.windowCommon.basePath + "crm/visitrecord/upload.c?_clientType=wap&fileId=" + id+"&userId="+window.windowCommon.approveLoginId, {}, function(t, status) {
			// 上传完成
			if (status == 200) {
				//$("#" + id).html("100%");
				//alert("上传成功！")
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
				console.log(upload.responseText)
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
			$("#d_" + fileId).html("");
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