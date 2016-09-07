/**
 * 回款记录js
 */
//修改页面时，初始化这个时间，long值。
var timeL;

//页面加载完毕初始化数据
function plusReady(){
	var self = plus.webview.currentWebview();
	var pid = self.pid;
	//判断新增或者编辑
	if(pid){
		$(".mui-title").html('编辑回款记录');
		$("#pid").val(pid);
		loadpayment(pid, initpaymentdict);
	}else{
		//初始化数据字典
		initpaymentdict();
		$("#ownerId").val(window.windowCommon.approveLoginId);
		$("#ownerIdSPAN").html(window.windowCommon.approveLoginName);
	}
	$("#orderId").val(self.orderId);
	$("#customerId").val(self.customerId);
	
	
	/* 绑订 查询条件中浮动框的特效 start */
	mui('.mui-scroll-wrapper').scroll();
	document.getElementById("payTimesLI").addEventListener('tap', function() {
		mui("#payTimesDIV").popover('toggle');
	});
	
 	mui("#payTimesDIV").on('tap', "li",function() {
		mui("#payTimesDIV").popover('toggle');
	});
	
	document.getElementById("payTypeLI").addEventListener('tap', function() {
		mui("#payTypeDIV").popover('toggle');
	});
	
 	mui("#payTypeDIV").on('tap', "li",function() {
		mui("#payTypeDIV").popover('toggle');
	});
	
	document.getElementById("isInvoiceLI").addEventListener('tap', function() {
		mui("#isInvoiceDIV").popover('toggle');
	});
	
 	mui("#isInvoiceDIV").on('tap', "li",function() {
		mui("#isInvoiceDIV").popover('toggle');
	});
	/* 绑订 查询条件中浮动框的特效 end */

	//绑订预计成交时间
	document.getElementById("payTimeLI").addEventListener('tap', function(){
		pickDate();
	});
	
	//点击收款人的方法
	document.getElementById("ownerIdLI").addEventListener('tap', function(){
		changeowner();
	});
	
	//完成方法
	document.getElementById("submitBtn").addEventListener('tap', function(){
		//console.log('点击完成的方法');
		saveorupdate();
	});
	
	/**
	 * 选择回款期次
	 */
	$("#payTimesUL").on("tap","li",function(){
		$("#payTimesUL").find("li").removeClass("month-active");
		$(this).addClass("month-active");
		$("#payTimes").val($(this).attr("name"));
		$("#payTimesLI a span").html($(this).html());
	});
	
	/**
	 * 选择是否开票
	 */
	$("#isInvoiceUL").on("tap","li",function(){
		$("#isInvoiceUL").find("li").removeClass("month-active");
		$(this).addClass("month-active");
		$("#isInvoice").val($(this).attr("name"));
		$("#isInvoiceLI a span").html($(this).html());
	});
	
	/**
	 * 选择付款方式
	 */
	$("#payTypeUL").on("tap","li",function(){
		$("#payTypeUL").find("li").removeClass("month-active");
		$(this).addClass("month-active");
		$("#payType").val($(this).attr("name"));
		$("#payTypeLI a span").html($(this).html());
	});

}

var loadpayment = function(pid, callback){
	var url = window.windowCommon.basePath + 'crm/payment/findPayment.c';
	
	var data = {
		"_clientType": "wap",
		"pid": pid
	};
	
	mui.ajax(url, {
		data: data,
		dataType: 'json',
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(response){
			if(response.payment.payTime){
				$("#payTime").html(response.payment.payTime);
				$("#payTime").removeClass("order-span");
				$("#payTime").addClass("order-span-after");
			}
			timeL = response.payment.payTimeL;
			$("#memo").val(response.payment.memo);
			$("#payTimes").val(response.payment.payTimes);
			$("#isInvoice").val(response.payment.isInvoice);
			$("#payType").val(response.payment.payType);
			$("#payMoney").val(response.payment.payMoney);
			
			$("#ownerId").val(window.windowCommon.approveLoginId);
			$("#ownerIdSPAN").html(window.windowCommon.approveLoginName);
			
			if (callback != undefined && callback != null) {
				callback();
			}
		}
	});
}
/**
 * 点击完成的方法
 */
var saveorupdate = function(){
	plus.nativeUI.showWaiting( "等待中..." );
	//
	var id = document.getElementById("pid").value;
	
	//回款日期
	var payTime = document.getElementById("payTime").innerHTML;
	if(!verifyEmpty(payTime, '请选择回款日期(必选)')){
		mui.toast('请选择回款日期!');
		plus.nativeUI.closeWaiting();
		return;
	}
	
	//回款期次
	var payTimes = document.getElementById("payTimes").value;
	if(!verifyEmpty(payTimes)){
		mui.toast('请选择回款期次!');
		plus.nativeUI.closeWaiting();
		return;
	}

	//是否开票
	var isInvoice = document.getElementById("isInvoice").value;
	if(!verifyEmpty(isInvoice)){
		mui.toast('请选择是否开票!');
		plus.nativeUI.closeWaiting();
		return;
	}
	//付款方式
	var payType = document.getElementById("payType").value;
	if(!verifyEmpty(payType)){
		mui.toast('请选择付款方式!');
		plus.nativeUI.closeWaiting();
		return;
	}
	
	//付款金额
	var payMoney = document.getElementById("payMoney").value;
	if(!verifyEmpty(payMoney)){
		mui.toast('请输入付款金额!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if (payMoney.indexOf('-') == 0) {
		mui.toast('付款金额必须为正数!');
		plus.nativeUI.closeWaiting();
		return;
	}
	payMoney = new Number(payMoney);
	if(isNaN(payMoney)){
		mui.toast('付款金额为数字!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if(payMoney==0){
		mui.toast('付款金额必须为正数!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if(!verifyPoints(payMoney, 2)){
		mui.toast('小数点位数最多为两位!');
		plus.nativeUI.closeWaiting();
		return;
	}
	//收款人
	var ownerId = document.getElementById("ownerId").value;
	if(!verifyEmpty(ownerId)){
		mui.toast('请选择收款人!');
		plus.nativeUI.closeWaiting();
		return;
	}
	
	//备注
	var memo = document.getElementById("memo").value;
	
	//订单ID
	var orderId = document.getElementById("orderId").value;
	
	//客户ID
	var customerId = document.getElementById("customerId").value;
	
	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"id": id,
		"payTime": payTime,
		"payTimes": payTimes,
		"isInvoice": isInvoice,
		"payType": payType,
		"payMoney": payMoney,
		"ownerId": ownerId,
		"memo": memo,
		"orderId":orderId,
		"customerId":customerId
	};
	
	var url = window.windowCommon.basePath + 'crm/payment/saveOrUpdatePayment.c';
	mui.ajax(url, {
		data: data,
		dataType: 'json',
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: saveorupdatesuccess
	});
}

/**
 * 新增或修改销售机会的响应
 * @param {Object} response
 */
var saveorupdatesuccess = function(response){
	//response = eval( '(' + response + ')' );
	if(response.code == 1){
		mui.toast('保存成功！');
	}else {
		mui.toast('保存失败！');
	}
	plus.nativeUI.closeWaiting();
	plus.webview.close("paymentrecords");
	plus.webview.getWebviewById(plus.webview.currentWebview().viewid)
			.evalJS(plus.webview.currentWebview().updatefunction+"();");
}

/**
 * 点击收款人的方法
 */
var changeowner = function(){
	//现有跟进人
	var ownerId = document.getElementById("ownerId").value
	ownerId = ','+ownerId+',';
	
	/*
	 * 第一个参数，已经勾选的人员ID，有多个时，逗号分割。
	 * 第二个参数，0表示多选， 1表示单选
	 * 第三个参数，回调方法，响应：[{"userId"：123, "userName": "张三", "userPhoto": "xx/xx.jpg", "picType":"string"},{}, ... ...]
	 */
	plus.qytxplugin.selectUsers(ownerId, 1, function(data) {
		if (data != null && data != undefined && data.length > 0) {
			//changeownersubmit(data[0].userId);
			document.getElementById("ownerId").value = data[0].userId;
			document.getElementById("ownerIdSPAN").innerHTML = data[0].userName;
		}else {
			mui.toast('请选择收款人！');
		}
	});
}

/**
 * 初始化回款期次和付款方式
 */
var initpaymentdict = function(){
	var url = window.windowCommon.basePath + 'crm/payment/loadPaymentDict.c';
	
	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId
	};
	
	mui.ajax(url, {
		data: data,
		dataType: 'json',
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(response){
			if(response.code == 1){
				//加载付款期次数据字典
				fillselect(response.payTimes, $("#payTimes").val(), 'payTimesUL', 'payTimesLI');
				//加载付款方式数据字典
				fillselect(response.payType, $("#payType").val(), 'payTypeUL', 'payTypeLI');
				//加载是否开票数据字典
				fillselect(response.isInvoice, $("#isInvoice").val(), 'isInvoiceUL', 'isInvoiceLI');
			}
		}
	});
}

/**
 * 填充下拉框
 * @param {Object} data array [{"value":1, "name":"lilipo"},{}, ...]
 * @param {Object} defaultvalue 默认值
 * @param {Object} ulid string 要填充的ul的ID名
 * @param {Object} liid string 默认值填充的li的ID名
 */
var fillselect = function(data, defaultvalue, ulid, liid){
	$("#"+ulid).html('');
	mui.each(data, function(i, n) {
		var html='';
		if(defaultvalue  && defaultvalue == n.value){
			html += '<li class="mui-table-view-cell month-active" name="'+n.value+'">';
			$("#"+liid+" a span").html(n.name);
		}else {
			html += '<li class="mui-table-view-cell" name="'+n.value+'">';
		}
		html += n.name;
		html += '</li>';
		$("#"+ulid).append(html);
	});
}

/**
 * 选择时间
 */
function pickDate(){
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
		var payTime = document.getElementById("payTime");
		var dateStr = bTime.split(" ")[0];
		//赋值
		payTime.innerHTML = dateStr;
		timeL = bTime;

		//修改样式
		$("#payTime").removeClass("order-span");
		$("#payTime").addClass("order-span-after");
					
	});
		
	
}
/**
 * 获取时间(mui)
 */
function pickDate_old() {
	var dDate = undefined;
	if(timeL == undefined){
		dDate = new Date();
	}else {
		dDate = new Date(timeL);
	}
	
	/*dDate.setFullYear(2014,0,1);
	var minDate=new Date();
	minDate.setFullYear(2010,0,1);
	var maxDate=new Date();
	maxDate.setFullYear(2016,11,31);*/
	plus.nativeUI.pickDate(function(e) {
		var d = e.date;
		var payTime = document.getElementById("payTime");
		/*
		 * + "-" + ((month + 1) < 10 ? ("0" + (month + 1)) : (month + 1)) 
					+ "-" + (monthday < 10 ? ("0" + monthday) : monthday);
		 */
		var dateStr = d.getFullYear() 
				+ "-" + ((d.getMonth() + 1) < 10 ? ("0" + (d.getMonth() + 1)) : (d.getMonth() + 1)) 
				+ "-" + (d.getDate() < 10 ? ("0" + d.getDate()) : d.getDate());
		//var dateStr = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
		
		payTime.innerHTML = dateStr;
		$("#payTime").removeClass("order-span");
		$("#payTime").addClass("order-span-after");
	}, function(e) {
		//outSet( "未选择日期："+e.message );
	}, {
		title: "请选择回款日期",
		date: dDate
		/*,minDate:minDate,
		maxDate:maxDate*/
	});
}

/**
 * 验证空值
 * @param {Object} val
 * @param {Object} defval
 */
var verifyEmpty = function(val, defval){
	if(val == null || val == undefined){
		return false;
	}
	if( defval == null || defval == undefined){
		if(val == ''){
			return false;
		}
	}else {
		if(val == defval){
			return false;
		}
	}
	return true;
}

if(window.plus){
	plusReady();
}else{
	document.addEventListener('plusready',plusReady,false);
}