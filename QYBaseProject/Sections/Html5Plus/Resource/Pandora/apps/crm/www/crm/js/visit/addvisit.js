/**
 * 新增联系记录页面js
 */
var fromType = 1;//页面来源（1 [来自列表]有单位，有机会    2 [来自往来单位详情]无单位，有机会    3[来自机会详情]无单位，无机会）
var visitType = 1;//拜访类型 1现场拜访 2沟通联系
var webViewId;//新增成功后调用那个页面
var webViewFunction;//新增成功后调用那个页面的那个方法
var imgNum = 0;//图片数量
mui.plusReady(function() {
	var self = plus.webview.currentWebview();
	fromType = self.fromType;
	visitType = self.visitType;
	webViewId = self.webViewId;
	webViewFunction = self.webViewFunction;
	
	if(fromType==1){
		//1 [来自列表]有单位，有机会    2 [来自往来单位详情]无单位，有机会    3[来自机会详情]无单位，无机会
	}else if(fromType==2){
		document.getElementById("bfdw").parentElement.setAttribute('style', 'display: none;');
		document.getElementById("customerId").value = self.customerId;
	}else if(fromType==3){
		document.getElementById("bfdw").parentElement.setAttribute('style', 'display: none;');
		document.getElementById("customerId").value = self.customerId;
		document.getElementById("chanceId").value = self.chanceId;
	}
	
	if(visitType==1){
		if(fromType==1){
			document.getElementById("header").innerHTML='新增客户拜访';
		}else{
			document.getElementById("header").innerHTML='新增拜访记录';
		}
		document.getElementById("goutongDiv").setAttribute('style', 'display: none;');
		document.getElementById("visitTime").parentElement.parentElement.setAttribute('style', 'margin-top: 0px;');
		var param1 = {
			"_clientType": "wap",
			"userId":window.windowCommon.approveLoginId
		}
		
		visitApi.getTime(param1,function(data){
			document.getElementById("visitTime").innerHTML=data;
		})
		getVisitPoistion();
		
		//绑定刷新定位
		mui(".replay")[0].addEventListener('tap', function(){
			getVisitPoistion();
		});
		
	}else if(visitType==2){
		document.getElementById("header").innerHTML='新增沟通记录';
		document.getElementById("visitTime").parentElement.setAttribute('style', 'display: none;');
		//初始化沟通方式
		var param = {
			"_clientType": "wap",
			"userId":window.windowCommon.approveLoginId,
			"infoType": 'communicationMode'//communicationMode表示沟通方式
		}
		visitApi.getDictType(param,communicationModeUL);
		mui('.mui-scroll-wrapper').scroll();
		//初始化 沟通联系人（该单位所有联系人）
		getContactByCustomerId(self.customerId);
	}
	
	//绑定上传图片事件
	var addimg = document.getElementById("addimg");
	addimg.addEventListener("tap", function() {
		galleryImgs();
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
	
	$("#toselectDiv1").click(function(){
		mui("#selectDiv1").popover("toggle");
	});
})

/**
 * 定位
 */
function getVisitPoistion(){
	//获取地理位置
	var visitPoistion = document.getElementById("visitPoistion");
	visitPoistion.innerHTML = '正在获取位置信息...';
	if(plus.os.name=='iOS'){
		plus.qytxplugin.localMessage("", function(data) {
            visitPoistion.innerHTML = data;
        });
	}else{
		plus.geolocation.getCurrentPosition(function(data){
			if (data.addresses == undefined) {
				visitPoistion.innerHTML = "无法定位";
			} else {
				visitPoistion.innerHTML = data.addresses;
			}
		}, function(e) {
			visitPoistion.innerHTML = "无法定位";
			mui.toast("无法定位");
		}, {
			provider: 'baidu',
			timeout:10000//请求超时时间  10秒
		});
	}
}

/**
 * 根据单位查询所有联系人
 */
function getContactByCustomerId(customerId){
	//初始化 沟通联系人（该单位所有联系人）
		var param = {
			"_clientType": "wap",
			"userId":window.windowCommon.approveLoginId,
			"customerId": customerId
		}
		visitApi.getContact(param,function(result){
			var jsonData = JSON.parse(result);
			var list = jsonData.list;
			for (var i = 0; i < list.length; i++) {
				document.getElementById("sellStageUL")
				var li = document.createElement("li");
				li.setAttribute("class", "mui-table-view-cell");
				li.setAttribute("contactId", list[i].contactId);
				li.setAttribute("contactName", list[i].contactName);
				li.innerHTML = list[i].contactName;
				document.getElementById("contactUL").appendChild(li);
		
			}
			if(list.length==0){
				mui.toast('本单位没有联系人，请先添加联系人');
				mui("#sellStageA")[0].addEventListener('tap', function() {
					mui.toast('本单位没有联系人，请先添加联系人');
				});
			}else{
				//绑订沟通对象的方法
				mui("#sellStageA")[0].addEventListener('tap', function() {
					mui("#popover1").popover('toggle');
				});
				
				mui("#popover1").on('tap', "li",function() {
					mui("#popover1").popover('toggle');
				});
				//绑定沟通方式弹出框选中事件
				var lis = mui("#contactUL li");
				mui.each(lis, function(i, n) {
					lis[i].addEventListener("tap", function() {
						selectContactDiv(lis[i]);
					});
				});
			}
		});
}


/**
 * 初始化销售阶段的响应
 * @param {Object} response
 */
var communicationModeUL = function(response){
	if(response.code == 1){
		mui.each(response.data, function(i, n) {
			var li = document.createElement("li");
			li.setAttribute("class", "mui-table-view-cell");
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
 * 获取时间（mui）
 */
function pickDate_old() {
	var dDate = new Date();
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
		nextVisitTimeStr.setAttribute("class","shi-rs-after");
		nextVisitTimeStr.innerHTML = dateStr;
		nextVisitTime.value = dateStr;
		
	}, function(e) {
		//outSet( "未选择日期："+e.message );
	}, {
		title: "请选择下次沟通时间",
		date: dDate
		/*,minDate:minDate,
		maxDate:maxDate*/
	});
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
	//消失
	mui('.mui-popover add-popover').popover('toggle');
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
	
	//消失
	mui('#selectDiv1').popover('toggle');
}

/**
 * 打开"选择客户"页面
 */
var selectcustomer = function(){mui.openWindow({
	    url: '../customer/selectCustomer.html',
	    id: 'selectCustomer',//不要改
	    extras: {
			viewid: 'addvisit', // 当前页面的ID
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
		document.getElementById("danwei").setAttribute("class","shi-rs-after");
		document.getElementById("danwei").innerHTML = objs[1];
		document.getElementById("customerId").value = objs[0];
		//重置机会
		document.getElementById("jihui").setAttribute("class","shi-rs");
		document.getElementById("jihui").innerHTML = '请选择相关机会';
		document.getElementById("chanceId").value = '';
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
	if(customerId == null || customerId == ""){
		mui.toast("请选选择单位！");
		return;
	}
	mui.openWindow({
		url: '../chance/selectChanceList.html',
		id: 'selectChanceList',
		extras: {
			customerId: customerId,
			pageName:"addvisit"//// 当前页面的ID
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
	
	var visitPoistion = document.getElementById("visitPoistion").innerHTML;
	if(visitPoistion==undefined ||visitPoistion=="" || visitPoistion=="正在获取位置信息..."){
		visitPoistion = "无法定位";
	}
	
	var param =
	{
		"visitTime":document.getElementById("visitTime").innerHTML,
		"visitPoistion":visitPoistion,
		"visitContent":visitContent,
		"nextVisitTime":document.getElementById("nextVisitTime").value,
		"visitDiffence":$.trim(document.getElementById("visitDiffence").value),
		"nextVisitMaincontent":$.trim(document.getElementById("nextVisitMaincontent").value),
		"customerId":customerId,
		"chanceId":document.getElementById("chanceId").value,
		"userId":window.windowCommon.approveLoginId,
		"_clientType":"wap",
		"attachmentIds":attachmentIds,
		"visitType":visitType,
		"fromType":fromType,
		"communicationMode":communicationMode,
		"communicationUserId":communicationUserId
		
	}
	visitApi.saveVisit(param,function(data){
		if(data==1){
			//mui.alert("新增成功");
			plus.webview.getWebviewById(webViewId).evalJS(webViewFunction+"();");
			plus.webview.close("addvisit");
		}else{
			mui.toast("新增失败");
		}
		plus.nativeUI.closeWaiting();
	},function(){
		plus.nativeUI.closeWaiting();
	});
}


