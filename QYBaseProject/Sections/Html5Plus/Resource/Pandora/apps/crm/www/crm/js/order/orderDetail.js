/**
 * 订单详情页面js
 */
var orderId;
var customerId;
var paymentId;
var isInvoice;

var viewId;//来源页面id
var callbackFun;//来源页面回调函数
var isNeedRefresh=0;//是否需要刷新来源页面

//页面加载完毕初始化数据
function plusReady(){
	var self = plus.webview.currentWebview();
	orderId = self.orderId;
	viewId = self.viewId;
	callbackFun = self.callbackFun;

	mui.init({
		swipeBack: true, //启用右滑关闭功能
		beforeback: function(){
			if(viewId && callbackFun && isNeedRefresh){
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun+"();");
			}
		}
	});
	mui('.mui-scroll-wrapper').scroll();

	//加载订单详情
	loadOrderDetail();
	
	//加载回款记录
	loadPaymentList();
	
	$("#toPopover").click(function(){
		mui("#popover").popover('toggle');
	});
	
	$("#popover").on("click","li",function(){
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		mui("#popover").popover("toggle");
		$("#state").val($(this).attr("val"));
		$("#orderState").html($(this).html());
		
		var param={
			_clientType:"wap",
			userId:window.windowCommon.approveLoginId,
			orderId:orderId,
			state:$(this).attr("val")
		};
		orderAPI._updateOrderState(param,function(data){
			if(data == '0'){
				mui.toast("操作失败");
				return false;
			}
			mui.toast("变更成功");	
			isNeedRefresh=1;
		});
		
	});

	$("#paymentList").on("click","li",function(){
		paymentId = $(this).attr("val");
		isInvoice = $(this).attr("val1");
		if(isInvoice == "0"){
			$("#updateInvoice").find("a").html("设置为已开票");
		}else{
			$("#updateInvoice").find("a").html("设置为未开票");
		}
		mui("#middlePopover").popover("toggle");
	});
	
	//绑订添加回款记录的方法
	boundpaymentrecords();
	//点击订单名称进入订单修改
	mui("#toUpdate")[0].addEventListener('tap', function(){
		mui.openWindow({
		    url: 'orderAdd.html',
		    id: 'orderAdd',
		    extras:{
		    	isUpdate:1,
			  	orderId : $(this).attr("val")
			}
		});
	});
	
	//绑定点击回款记录操作按钮关闭弹层事件
	$("#middlePopover").on("click","li",function(){
		mui("#middlePopover").popover("toggle");
	});
	
	//绑定修改回款记录事件
	$("#editPayment").click(function(){
		mui.openWindow({
		    url: 'paymentrecords.html',
		    id: 'paymentrecords',
		    extras: {
		    	pid: paymentId,
		    	orderId: plus.webview.currentWebview().orderId,
		    	customerId: customerId,
		    	viewid: "orderDetail",
				updatefunction: "refreshPymentList",
			}
		});
	});

	//绑定删除回款记录事件
	$("#delPayment").click(function(){
		mui.confirm('确认删除该回款记录吗？', null, null, function(e) {
			if (e.index == 0) {
				//console.log('确定');
				/**
				 * 删除
				 */
				var param={
					_clientType:"wap",
					userId:window.windowCommon.approveLoginId,
					paymentId:paymentId
				}
				orderAPI._delPayment(param,function(result){
					if(result == "1"){
						//删除成功 刷新列表
						mui.toast("删除成功");	
						refreshPymentList();
					}else{
						mui.toast("操作失败");				
					}
				});
			} else if (e.index == 1) {
				//console.log('取消');
			}
		});
	});
	
	//绑定修改回款记录是否取消开票
	$("#updateInvoice").click(function(){
		/**
		 * 删除
		 */
		var param={
			_clientType:"wap",
			userId:window.windowCommon.approveLoginId,
			paymentId:paymentId,
			isInvoice:1-parseInt(isInvoice)
		}
		orderAPI._updatePaymentState(param,function(result){
			if(result == "1"){
				//删除成功 刷新列表
				refreshPymentList();
			}else{
				mui.toast("操作失败");				
			}
		});
	});
	
	
	//绑订跟进人的方法（进入跟进人页面）
	document.getElementById("followUserIdsA").addEventListener('tap', function() {
		mui.openWindow({
		    url: 'followUserIdsORDER.html',
		    id: 'followUserIdsORDER',
		    extras: {
		    	cid: orderId,
		    	viewId: plus.webview.currentWebview().id,
				callbackFun: "loadOrderDetail",
			}
		});
	});
	
}

/**
 * 绑订添加回款记录的方法
 */
var boundpaymentrecords = function(){
	document.getElementById("addpaymentrecords").addEventListener('tap', function(){
		mui.openWindow({
		    url: 'paymentrecords.html',
		    id: 'paymentrecords',
		    extras: {
		    	orderId: plus.webview.currentWebview().orderId,
		    	customerId: customerId,
		    	viewid: "orderDetail",
				updatefunction: "refreshPymentList",
			}
		});
	});
}

/**
 * 加载订单详情
 */
function loadOrderDetail(){
	var param={
		_clientType:"wap",
		userId:window.windowCommon.approveLoginId,
		"t":Math.random(),
		orderId:orderId
	};
	orderAPI._orderDetail(param,function(detail){
		customerId = detail.customerId;
		$("#toUpdate").attr("val",detail.orderId);
		$("#orderName").html(detail.orderName);
		if(!detail.orderMoney || detail.orderMoney =='0'){
			$("#orderMoney").html("0.00");
		}else{
			$("#orderMoney").html(detail.orderMoneyF);
		}
		$("#beginTime").html(detail.beginTime);
		$("#endTime").html(detail.endTime);
		$("#followUserNames").html(detail.followUserNames);
		$("#state").val(detail.state);
		switch(detail.state){
			case '0':
				$("#orderState").html("执行前");
				break;
			case '1':
				$("#orderState").html("执行中");
				break;
			case '2':
				$("#orderState").html("结束");
				break;
			case '3':
				$("#orderState").html("意外中止");
				break;
		}
		$("#popover").find("li[val='"+detail.state+"']").addClass("month-active");
	});
}

/**
 * 加载回款列表
 */
function loadPaymentList(){
	var param={
		_clientType:"wap",
		userId:window.windowCommon.approveLoginId,
		orderId:orderId
	};
	orderAPI._paymentList(param,function(list){
		if(list.length>0){
			$("#paymentCount").html("("+list.length+"笔)");
			$("#paymentList").html('');
		}else{
			$("#paymentList").html('<div class="no_payment">您还没有添加回款记录</div>');
		}
		$.each(list,function(i,payment){
			var money = "0.00";
			if(payment.payMoneyF){
				money = payment.payMoneyF;
			}
			var html = "";
			    if(payment.memo){
			    	html += '<li class="mui-table-view-cell order-two bor-bottom" val="'+payment.paymentId+'" val1="'+payment.isInvoice+'">';
			    }else{
			    	html += '<li class="mui-table-view-cell order-two-nomemo bor-bottom" val="'+payment.paymentId+'" val1="'+payment.isInvoice+'">';
			    }
				
				html += '<a href="javascript:void(0);">';
				html += '<div class="order-two-floor mt6">';
				html += '<span class="order-date">'+payment.payTime+'('+payment.payTimes+'期)</span>';
				if(payment.isInvoice == "1"){
					html += '<span class="order-state-yes fr mr12">已开票</span>';
				}else{
					html += '<span class="order-state-no fr mr12">未开票</span>';
				}
				html += '</div>';
				html += '<div class="order-two-floor">';
				html += '<span class="order-date"><em class="order-money" style="margin-top:6px;"></em><span class="order-orange">'+money+'&nbsp;('+payment.payType+')</span></span>';
//				html += '<span class="order-date centre-text ml12">付款方式：<span class="order-orange">'+payment.payType+'</span></span>';
				html += '</div>';
				if(payment.memo){
					html += '<div class="order-two-floor1">';
					html += '<span class="order-date centre-text"><em class="notice"></em><span class="fl order-notice">'+payment.memo+'</span></span>';
					html += '</div>';
				}
				html += '</a>';
				html += '</li>';
				$("#paymentList").append(html);
		});
	});
}

/**
 * 刷新回款记录列表
 */
function refreshPymentList(){
	$("#paymentCount").html("");
	$("li.order-two").remove();
	loadPaymentList();
}

if(window.plus){
	plusReady();
}else{
	document.addEventListener('plusready',plusReady,false);
}