/**
 * 修改联系记录页面js
 */
var visitType = 1;//拜访类型 1现场拜访 2沟通联系
var visitdetailId = '';
var imgNum = 0;//图片数量
var visitdetailId = "";
var callbackFun;//来源页面回调函数
var contactNum=0;//本单位联系人数量

mui.plusReady(function() {
	var self = plus.webview.currentWebview();
	visitdetailId = self.visitId;
	viewId = self.viewId;
	callbackFun = self.callbackFun;
	
	var param = {
		"_clientType": "wap",
		"userId":window.windowCommon.approveLoginId,
		"visitdetailId":visitdetailId
	}
	visitApi.getVisitInfo(param,function(data){
		visitType = data.visitType;
		if(visitType==1){
			document.getElementById("goutongDiv").setAttribute('style', 'display: none;');
			document.getElementById("visitTime").parentElement.parentElement.setAttribute('style', 'margin-top: 0px;');
			document.getElementById("visitTime").innerHTML = data.visitTime;
			document.getElementById("visitPoistion").innerHTML = data.visitPoistion;
		}else if(visitType==2){
			document.getElementById("visitTime").parentElement.setAttribute('style', 'display: none;');
			//初始化沟通方式
			var param = {
				"_clientType": "wap",
				"userId":window.windowCommon.approveLoginId,
				"communicationMode":data.communicationMode,
				"infoType": 'communicationMode'//communicationMode表示沟通方式
			}
			visitApi.getDictType(param,communicationModeUL)
			document.getElementById("communicationModeName").setAttribute("class","shi-rs-after");
			document.getElementById("communicationModeName").innerHTML = data.communicationModeName;
			document.getElementById("communicationMode").value = data.communicationMode;
			mui('.mui-scroll-wrapper').scroll();
			//初始化 沟通联系人（该单位所有联系人）
			getContactByCustomerId(data.customerId,data.communicationUserId);
			document.getElementById("communicationUserName").setAttribute("class","shi-rs-after");
			document.getElementById("communicationUserName").innerHTML = data.communicationUserName;
			document.getElementById("communicationUserId").value = data.communicationUserId;
		}
		document.getElementById("visitContent").value = data.visitContent;
		document.getElementById("visitDiffence").value = data.visitDiffence;
		//图片附件
		var attachmentIds = data.attachmentIds;
		document.getElementById("attachmentIds").value = ","+attachmentIds+",";
		var paths = data.paths;
		var imgPath = paths.split(",");
		var imgAttachmentId = attachmentIds.split(",");
		imgNum = imgAttachmentId.length;
		if(imgNum>2){
			$("#addimg").hide();
		}
		if(paths!=""){
			for (var n = 0;n<imgPath.length;n++ ) {
				console.log(imgPath[n])
				var innerHtml = '';
				innerHtml += "<div class=\"img\" style=\"width:67px;height:67px;background-color:#d9d9d9;\">";
				innerHtml += "<img src=\""+window.windowCommon.basePath+"crm/visitrecord/download.c?filePath="+imgPath[n]+"\" alt=\"\" style=\"max-width:67px;max-height:67px;margin:auto;\" data-preview-src='' data-preview-group='2'/>";
				innerHtml += "<i class=\"delete\" onclick=\"deleteImg(this,"+imgAttachmentId[n]+")\"></i>";
				innerHtml += "</div>";
				$("#addimg").before(innerHtml);
			}
			mui.previewImage();
		}
		
		if(data.nextVisitTimeStr!=""){
			document.getElementById("nextVisitTimeStr").setAttribute("class","shi-rs-after");
			document.getElementById("nextVisitTimeStr").innerHTML = data.nextVisitTimeStr.replace('年','-').replace('月','-').replace('日','');
			document.getElementById("nextVisitTime").value = data.nextVisitTimeStr.replace('年','-').replace('月','-').replace('日','');
		}
		document.getElementById("nextVisitMaincontent").value = data.nextVisitMaincontent;
		
		document.getElementById("customerId").value = data.customerId;
		document.getElementById("danwei").setAttribute("class","shi-rs-after");
		document.getElementById("danwei").innerHTML = data.customerName;
		document.getElementById("chanceId").value = data.chanceId;
		if(data.chanceName!=""){
			document.getElementById("jihui").setAttribute("class","shi-rs-after");
			document.getElementById("jihui").innerHTML = data.chanceName;
		}
		
		
	})

	//绑定选择时间事件
	mui("#pickDate")[0].addEventListener('tap', function(){
		pickDate();
	});	
	
	//绑订单位名称
	document.getElementById("getdanwei").addEventListener('tap', function() {
		selectcustomer();
	});
	
	//绑定选择机会事件
	mui("#getChance")[0].addEventListener('tap', function(){
		getChance();
	});
	
	//绑定提交事件
	mui("#submit")[0].addEventListener('tap', function(){
		submit();
	});


	//绑定上传图片事件
	var addimg = document.getElementById("addimg");
	addimg.addEventListener("tap", function() {
		galleryImgs();
	})
	
	//绑订沟通对象的方法
	mui("#sellStageA")[0].addEventListener('tap', function() {
		if(contactNum==0){
			mui.toast('本单位没有联系人，请先添加联系人');
			return;
		}
		mui("#popover1").popover('toggle');
	});
	
	mui("#popover1").on('tap', "li",function() {
		mui("#popover1").popover('toggle');
	});
	
	$("#toselectDiv1").click(function(){
		mui("#selectDiv1").popover("toggle");
	});
})

/**
 * 根据单位查询所有联系人
 */
function getContactByCustomerId(customerId,id){
	//初始化 沟通联系人（该单位所有联系人）
		var param = {
			"_clientType": "wap",
			"userId":window.windowCommon.approveLoginId,
			"customerId": customerId
		}
		visitApi.getContact(param,function(result){
			console.log(result);
			var jsonData = JSON.parse(result);
			var list = jsonData.list;
			document.getElementById("contactUL").innerHTML = '';
			contactNum = list.length;
			if(list.length==0){
				mui.toast('本单位没有联系人，请先添加联系人');
				return;
			}
			for (var i = 0; i < list.length; i++) {
				var li = document.createElement("li");
				if(id!=null && id==list[i].contactId){//选中效果
					li.setAttribute("class", "mui-table-view-cell month-active");
				}else{
					li.setAttribute("class", "mui-table-view-cell");
				}
				li.setAttribute("contactId", list[i].contactId);
				li.setAttribute("contactName", list[i].contactName);
				li.innerHTML = list[i].contactName;
				document.getElementById("contactUL").appendChild(li);
		
			}
			//绑定沟通方式弹出框选中事件
			var lis = mui("#contactUL li");
			mui.each(lis, function(i, n) {
				lis[i].addEventListener("tap", function() {
					selectContactDiv(lis[i]);
				});
			});
		});
}

/**
 * 删除图片
 * @param {Object} obj
 * @param {Object} imgAttachmentId
 */
function deleteImg(obj,imgAttachmentId){
	console.log(imgAttachmentId)
	obj.parentElement.setAttribute('style', 'display: none;');
	obj.parentElement.innerHTML = '';
	var att = document.getElementById("attachmentIds");
	console.log(att.value)
	att.value = att.value.replace(","+imgAttachmentId+",",",");
	console.log(att.value)
	$("#addimg").show();
	imgNum--;
}

/**
 * 初始化销售阶段的响应
 * @param {Object} response
 */
function communicationModeUL(response,id){
	if(response.code == 1){
		mui.each(response.data, function(i, n) {
			var li = document.createElement("li");
			if(id!=undefined && response.data[i].value==id){
				li.setAttribute("class", "mui-table-view-cell month-active");
			}else{
				li.setAttribute("class", "mui-table-view-cell");
			}
			li.setAttribute("communicationMode", response.data[i].value);
			li.setAttribute("communicationModeName", response.data[i].name);
			li.innerHTML = response.data[i].name;
			document.getElementById("communicationModeUL").appendChild(li);
		});
		//绑定沟通方式弹出框选中事件
		var lis = mui("#communicationModeUL li");
		mui.each(lis, function(i, n) {
			lis[i].addEventListener("tap", function() {
				selectDiv(lis[i]);
			});
		});
	}
}

/**
 * 获取时间
 */
function pickDate(){
	var timeL = document.getElementById("nextVisitTime").value;
	var dDate = undefined;
	if (!timeL) {
		dDate = new Date();
	} else {
		dDate = new Date(timeL);
	}
	var bTime = dDate.getFullYear() 
				+ "-" + ((dDate.getMonth() + 1) < 10 ? ("0" + (dDate.getMonth() + 1)) : (dDate.getMonth() + 1)) 
				+ "-" + (dDate.getDate() < 10 ? ("0" + dDate.getDate()) : dDate.getDate());
	var defaultAry=[bTime,"yyyy-MM-dd"];
	plus.qytxplugin.selectDateTime(defaultAry,function(da){
			
		bTime = da.date;
		var nextVisitTimeStr = document.getElementById("nextVisitTimeStr");
		var nextVisitTime = document.getElementById("nextVisitTime");
		var dateStr = bTime.split(" ")[0];
		//赋值
		nextVisitTimeStr.setAttribute("class","shi-rs-after");
		nextVisitTimeStr.innerHTML = dateStr;
		nextVisitTime.value = dateStr;
	});
}

/**
 * 获取时间(mui)
 */
function pickDate_old() {
	var dDate = new Date();
	/*dDate.setFullYear(2014,0,1);
	var minDate=new Date();
	minDate.setFullYear(2010,0,1);
	var maxDate=new Date();
	maxDate.setFullYear(2016,11,31);*/
	var nextVisitTime = document.getElementById("nextVisitTime");
	if(nextVisitTime.value!=""){
		dDate = new Date(Date.parse(nextVisitTime.value));
	}
	plus.nativeUI.pickDate(function(e) {
		var d = e.date;
		var nextVisitTimeStr = document.getElementById("nextVisitTimeStr");
		var nextVisitTime = document.getElementById("nextVisitTime");
		var month = d.getMonth() + 1;
		if(month<10){
			month = "0"+month;
		}
		var day = d.getDate();
		if(day<10){
			day = "0"+day;
		}
		var dateStr = d.getFullYear() + "-" + month + "-" + day;
		nextVisitTimeStr.innerHTML = dateStr;
		nextVisitTime.value = dateStr;
		
	}, function(e) {
		//outSet( "未选择日期："+e.message );
	}, {
		title: "请选择日期",
		date: dDate
		/*,minDate:minDate,
		maxDate:maxDate*/
	});
}

/**
 * 点击弹出框事件
 */
function selectDiv(obj){
	//修改样式
	var lis = mui("#communicationModeUL li");
	mui.each(lis, function(i, n) {
		lis[i].setAttribute("class", "mui-table-view-cell");
	});
	obj.setAttribute("class", "mui-table-view-cell month-active");
	//赋值
	document.getElementById("communicationModeName").setAttribute("class","shi-rs-after");
	document.getElementById("communicationModeName").innerHTML = obj.getAttribute("communicationModeName");
	document.getElementById("communicationMode").value = obj.getAttribute("communicationMode");
	console.log(document.getElementById("communicationMode").value )
	
	//消失
	mui('#selectDiv1').popover('toggle');
}

/**
 * 沟通对象点击弹出框事件
 */
function selectContactDiv(obj){
	//修改样式
	var lis = mui("#contactUL li");
	mui.each(lis, function(i, n) {
		lis[i].setAttribute("class", "mui-table-view-cell");
	});
	obj.setAttribute("class", "mui-table-view-cell month-active");
	//赋值
	document.getElementById("communicationUserName").setAttribute("class","shi-rs-after");
	document.getElementById("communicationUserName").innerHTML = obj.getAttribute("contactName");
	document.getElementById("communicationUserId").value = obj.getAttribute("contactId");
	console.log(document.getElementById("communicationUserId").value )
	//消失
	mui('.mui-popover add-popover').popover('toggle');
}

/**
 * 打开"选择客户"页面
 */
var selectcustomer = function(){mui.openWindow({
	    url: '../customer/selectCustomer.html',
	    id: 'selectCustomer',//不要改
	    extras: {
			viewid: 'editvisit', // 当前页面的ID
			tapone: 'taponecustomer' //需要回调的方法
		}
	});
}

/**
 * 选择单位回调方法
 * @param {Object} objs 长度为2，[0]是ID， [1]是name
 */
var taponecustomer = function (objs){
	
	//赋值(需要改)
	if(objs == undefined){
		console.log('选择客户后，返回了undefined');
	}else{
		console.log('id='+objs[0]+', name='+objs[1]);
		document.getElementById("danwei").innerHTML = objs[1];
		document.getElementById("customerId").value = objs[0];
		//重置机会
		document.getElementById("jihui").setAttribute("class","shi-rs");
		document.getElementById("jihui").innerHTML = '请选择相关机会';
		document.getElementById("chanceId").value = '';
		//重置沟通对象
		document.getElementById("communicationUserName").setAttribute("class","shi-rs");
		document.getElementById("communicationUserName").innerHTML = '请选择沟通对象(必选)';
		document.getElementById("communicationUserId").value = '';
		console.log(visitType)
		if(visitType==2){
			getContactByCustomerId(objs[0],'');
		}
	}
	
	//关闭(不要改)
	plus.webview.close("selectCustomerList");
	plus.webview.close("selectCustomer");
}

/**
 * 销售机会
 */
function getChance(){
	var customerId = document.getElementById("customerId").value;
	console.log("customerId="+customerId)
	if(customerId == null || customerId == ""){
		mui.toast("请选选择单位！");
		return;
	}
	mui.openWindow({
		url: '../chance/selectChanceList.html',
		id: 'selectChanceList',
		extras: {
			customerId: customerId,
			pageName:"editvisit"// 当前页面的ID
		}
	});
}

/**
 * 选择机会回调方法
 * @param {Object} objs 长度为2，[0]是ID， [1]是name
 */
var returnchance = function (objs){
	
	if(objs == undefined){
		console.log('选择客户后，返回了undefined');
	}else{
		if(objs[1]=="无"){//清空机会
			document.getElementById("jihui").setAttribute("class","shi-rs");
			document.getElementById("jihui").innerHTML = '请选择相关机会';
			document.getElementById("chanceId").value = '';
		}else{
			document.getElementById("jihui").setAttribute("class","shi-rs-after");
			document.getElementById("jihui").innerHTML = objs[1];
			document.getElementById("chanceId").value = objs[0];
		}
	}
	
	plus.webview.close("selectChanceList");
}

/**
 * 提交
 */
function submit(){
	plus.nativeUI.showWaiting( "等待中..." );
	var communicationMode = $.trim(document.getElementById("communicationMode").value);
	var communicationUserId = $.trim(document.getElementById("communicationUserId").value);
	if(visitType==2){
		if(communicationMode==""){
			mui.toast("请选择沟通方式！");
			plus.nativeUI.closeWaiting();
			return;
		}
		if(communicationUserId==""){
			mui.toast("请选择沟通对象！");
			plus.nativeUI.closeWaiting();
			return;
		}
	}
	var visitContent = $.trim(document.getElementById("visitContent").value);
	if(visitContent==""){
		mui.toast("请输入沟通内容！");
		plus.nativeUI.closeWaiting();
		return;
	}
	if(visitContent.length<10){
		mui.toast("沟通内容不能少于10个字符！");
		plus.nativeUI.closeWaiting();
		return;
	}
	
	var customerId = $.trim(document.getElementById("customerId").value);
	if(customerId==""){
		mui.toast("请选择拜访单位！");
		plus.nativeUI.closeWaiting();
		return;
	}
	
	if (!isCompleted()) {
		mui.toast("正在上传图片，请稍等...");
		plus.nativeUI.closeWaiting();
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
	if(imgNum>0){
		if(attachmentIds==""){
			attachmentIds = document.getElementById("attachmentIds").value.replace(",","");
			attachmentIds = attachmentIds.substring(0,attachmentIds.length-1);
		}else{
			attachmentIds = document.getElementById("attachmentIds").value.replace(",","")+attachmentIds;
		}
	}
	
	var param =
	{
		"visitdetailId":visitdetailId,
		"visitContent":visitContent,
		"nextVisitTime":$.trim(document.getElementById("nextVisitTime").value),
		"visitDiffence":$.trim(document.getElementById("visitDiffence").value),
		"nextVisitMaincontent":$.trim(document.getElementById("nextVisitMaincontent").value),
		"customerId":customerId,
		"chanceId":document.getElementById("chanceId").value,
		"userId":window.windowCommon.approveLoginId,
		"_clientType":"wap",
		"attachmentIds":attachmentIds,
		"visitType":visitType,
		"communicationMode":communicationMode,
		"communicationUserId":communicationUserId
	}
	visitApi.updateVisit(param,function(data){
		plus.nativeUI.closeWaiting();
		if(data==1){
			//刷新详情
			if(viewId && callbackFun){
				plus.webview.getWebviewById(viewId).evalJS(callbackFun+"();");
			}
			plus.webview.currentWebview().close();
		}else{
			mui.toast("保存失败");
		}
	},function(){
		plus.nativeUI.closeWaiting();
	});
}


