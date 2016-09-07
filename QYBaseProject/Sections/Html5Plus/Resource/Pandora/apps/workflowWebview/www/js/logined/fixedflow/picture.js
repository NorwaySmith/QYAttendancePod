mui.plusReady(function() {
	$("#photoCamera").click(function() {
		camera();
		return false;
	});
	$("#photoGallery").click(function() {
		gallery();
		return false;
	});
	$("#cancle").click(function() {
		cancle();
		return false;
	});
})

//拍照
function camera() {
	mui("#picture").popover("toggle");
	var cmr = plus.camera.getCamera();
	var res = cmr.supportedImageResolutions[0];
	var fmt = cmr.supportedImageFormats[0];
	cmr.captureImage(function(path) {
		plus.io.resolveLocalFileSystemURL(path, function(entry) {
			//压缩图片
			compressImage(entry.fullPath);
		}, function(e) {
			//			alert(e.message);
		});
	}, function(error) {
		//		alert(error);
	}, {
		resolution: res,
		format: fmt
	})
}
//选取图片
function gallery() {
	mui("#picture").popover("toggle");
	// 从相册中选择图片
	plus.gallery.pick(function(path) {
		//压缩图片
		compressImage(path);
	});
}
//取消
function cancle() {
	mui("#picture").popover("toggle");
}

//上传图片
/**
 * 创建上任务
 * @param {Object} filePath 本地文件路径
 * @param {Object} id 文件ID
 * @param {Object} fileName 文件名
 */
function createUpload(filePath, id, fileName) {
	//上传
	var task = plus.uploader.createUpload(window.windowCommon.fileUploadPath + "?_clientType=wap&moduleCode=workflow&origin=app&userId="+window.windowCommon.approveLoginId, {}, function(t, status) {
		plus.nativeUI.closeWaiting();
		// 上传完成
		if (status == 200) {
			var name = $("#picture").attr("name");
			if(t.responseText&&t.responseText.indexOf("100||")>-1){
				var result=t.responseText.substring(5);
				var data = jQuery.parseJSON(result);
				if (data&&data[0].path) {
					var path = data[0].path;
					var html = "<div class=\"img\">";
					html += "<img src='" + window.windowCommon.fileDownPath + "?_clientType=wap&filePath=" + path + "' width=\"67\" height=\"67\" data-preview-src='' data-preview-group='2'/>";
					html += "<i class=\"delete\" onclick=\"deleteImg(this,'" + path + "','" + name + "')\"></i>";
					html += "</div>";
					$("#formDiv div.img-group[name='" + name + "']").append(html);
					if(!$("#formDiv div.img-group[name='" + name + "']").hasClass("img-group-css")){
						$("#formDiv div.img-group[name='" + name + "']").addClass("img-group-css");
					}
					var paths = $("#formDiv span[name='" + name + "']").html();
					$("#formDiv span[name='" + name + "']").html(paths + "," + path);
					var len = $("#formDiv div.img-group[name='" + name + "'] div").length;
					if (len >= 9) {
						$("#formDiv a[name='" + name + "']").unbind("tap"); 
						$("#formDiv a[name='" + name + "'] em").removeClass("camera_btn");
					}
				}else{
					mui.toast("上传图片失败");
				}
			}else{
				mui.toast("上传图片失败");
			}
			mui.previewImage();
		} else {
			mui.toast("上传图片失败");
		}

	});
	task.addFile(filePath, {
		key: "file"
	});
	task.addEventListener("statechanged", onStateChanged, false);
	task.addData("fileName", fileName);
	task.start();
}
//上传图片状态监听
function onStateChanged(upload, status) {
	if (upload.state == 4 && status == 200) {

	}
}

//压缩图片
function compressImage(srcPath) {

	plus.nativeUI.showWaiting('正在上传...', {
		padding: "10px"
	});
	
	var dstPath = "";
	if (srcPath) {
		plus.io.requestFileSystem(plus.io.PRIVATE_DOC, function(fs) {
			var entry = fs.root;
			var fileName = (new Date()).getTime() + srcPath.substring(srcPath.lastIndexOf("."), srcPath.length);
			//压缩文件路径
			dstPath = entry.fullPath + fileName;
			if(plus.os.name=='iOS'){
				if(srcPath.indexOf("file://")!=0){
					srcPath="file://"+srcPath;
				}
				if(dstPath.indexOf("file://")!=0){
					dstPath="file://"+dstPath;
				}
			}
			plus.zip.compressImage({
					src: srcPath,
					dst: dstPath,
					width: "600px",
					format:"jpg"
				},
				function() {
					//压缩成功
					var pathAry = dstPath.split("/");
					var fileName = pathAry[pathAry.length - 1];
					var id = "";
					createUpload(dstPath, id, fileName);
				},
				function(error) {
					console.log(error.message);
					//压缩失败
					var pathAry = srcPath.split("/");
					var fileName = pathAry[pathAry.length - 1];
					var id = "";
					createUpload(srcPath, id, fileName);
				});
		});

	}

}

//删除图片
function deleteImg(obj, path, name) {
	var paths = $("#formDiv span[name='" + name + "']").html();
	if (paths) {
		paths = paths.replace("," + path, "");
		$("#formDiv span[name='" + name + "']").html(paths);
	}
	var len = $("#formDiv div.img-group[name='" + name + "'] div").length;
	if (len >= 9) {
		$("#formDiv a[name='" + name + "']").bind("tap", function() {
			//手动关闭页面小键盘
			closeKeyborad();
			var name = $(this).attr("name");
			$("#picture").attr("name", name);
			setTimeout(function() {
				mui("#picture").popover("toggle");
			}, 300);
		});
		$("#formDiv a[name='" + name + "'] em").addClass("camera_btn");
	}
	$(obj).parent().remove();
	if($("#formDiv div.img-group[name='" + name + "'] div").length==0){
		$("#formDiv div.img-group[name='" + name + "']").removeClass("img-group-css");
	}
}