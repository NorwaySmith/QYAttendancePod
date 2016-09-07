/**
 * 订单新增页面js
 */
if(window.plus){
	plusReady();
}else{
	document.addEventListener('plusready',plusReady,false);
}
/**
 * 保存订单
 */
function saveOrder() {
	plus.nativeUI.showWaiting( "等待中..." );
	
	var orderName = $.trim($("#orderName").val());
	if (!orderName) {
		mui.toast("请输入订单名称！");
		plus.nativeUI.closeWaiting();
		return;
	}
	var customerId = $("#customerId").val();
	if(!customerId){
		mui.toast("请选择单位！");
		plus.nativeUI.closeWaiting();
		return;
	}
	var orderMoney = $("#orderMoney").val();
	if (!orderMoney||orderMoney.indexOf("必填")>-1) {
		mui.toast("请输入全款金额！");
		plus.nativeUI.closeWaiting();
		return;
	}
	if (orderMoney.indexOf('-') == 0) {
		mui.toast('全款金额必须为正数!');
		plus.nativeUI.closeWaiting();
		return;
	}
	orderMoney = new Number(orderMoney);
	if(isNaN(orderMoney)){
		mui.toast('全款金额必须为数字!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if(orderMoney==0){
		mui.toast('全款金额必须为正数!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if(!verifyPoints(orderMoney, 2)){
		mui.toast('小数点位数最多为两位!');
		plus.nativeUI.closeWaiting();
		return;
	}
	var orderType = $("#orderTypeV").val();
	if(!orderType){
		mui.toast("请选择订单类型！");
		plus.nativeUI.closeWaiting();
		return;
	}
	var payType = $("#payTypeV").val();
	if(!payType){
		mui.toast("请选择支付类型！");
		plus.nativeUI.closeWaiting();
		return;
	}
	var dealTime = $("#dealTime").html();
	if (dealTime.indexOf("必选")>-1) {
		mui.toast("请选择签单日期！");
		plus.nativeUI.closeWaiting();
		return;
	}
	var beginTime = $("#startTime").html();
	if (beginTime.indexOf("必选")>-1) {
		mui.toast("请选择开始日期！");
		plus.nativeUI.closeWaiting();
		return;
	}
	var endTime = $("#endTime").html();
	if (endTime.indexOf("必选")>-1) {
		mui.toast("请选择结束日期！");
		plus.nativeUI.closeWaiting();
		return;
	}
	var ownerId = $("#ownerId").val();
	if (!ownerId) {
		mui.toast("请选择订单负责人！");
		plus.nativeUI.closeWaiting();
		return;
	}
	var createUserId = window.windowCommon.approveLoginId;
	//新增时  如果当前登陆用户不是负责人，把当前登录用户追加为跟进人
	var followUserIds = "";
	if(!$("#orderId").val()&&createUserId!=ownerId){//新增
		followUserIds = "," + createUserId + ",";
	}
	var param = {
		"createUserId":createUserId,
		"orderName":orderName,
		"orderMoney":orderMoney,
		"orderType":orderType,
		"payType":payType,
		"signTime":dealTime+" 00:00:00.000",
		"beginTime":beginTime+" 00:00:00.000",
		"endTime":endTime+" 00:00:00.000",
		"memo":$.trim($("#memo").val())==null?null:$.trim($("#memo").val()),
		"customerId":customerId,
		"ownerId":ownerId,
		"id":$("#orderId").val(),
		"followUserIds":followUserIds
	};
	orderAPI.saveOrUpdate(param,function(result){
		if(result == 1){
			mui.toast('保存成功！');
			if(!$("#orderId").val()){//新增
				var customerWV = plus.webview.getWebviewById("orderlist");
				customerWV.evalJS("refreshChildData();");
			}else {
				var customerWV = plus.webview.getWebviewById("orderDetail");
				customerWV.evalJS("isNeedRefresh=1; loadOrderDetail();");
			}
			plus.webview.currentWebview().close();
		}else {
			mui.toast('保存失败！');
		}
		plus.nativeUI.closeWaiting();
	},function(){
		plus.nativeUI.closeWaiting();
	});
}
/**
 * 初始化新增页面数据字典
 */
function initOrderDict(){
	var param = {
		"_clientType":"wap",
		"userId":window.windowCommon.approveLoginId
	};
	orderAPI.getOrderDict(param,function(data){ 
		$.each(data,function(key,list){
			$.each(list,function(i,item){
				var html='';
				if($("#"+key+"V").val()){//修改页面
					if($("#"+key+"V").val()==item.value){
						html+='<li class="mui-table-view-cell month-active" val="'+item.value+'">';
						$("#"+key+"Str").html(item.name);
						$("#"+key+"Str").addClass("order-span-after");
						$("#"+key+"Str").removeClass("order-span");
						$("#"+key+"V").val(item.value);
					}else{
						html+='<li class="mui-table-view-cell" val="'+item.value+'">';
					}
				}else{//新增
					if(i==0){
						html+='<li class="mui-table-view-cell month-active" val="'+item.value+'">';
						$("#"+key+"Str").html(item.name);
						$("#"+key+"Str").addClass("order-span-after");
						$("#"+key+"Str").removeClass("order-span");
						$("#"+key+"V").val(item.value);
					}else{
						html+='<li class="mui-table-view-cell" val="'+item.value+'">';
					}
				}
    			html+=item.name;
    			html+='	</li>';
    			$("#"+key).append(html);
			});
		});
	});
}
/**
 * 获取时间
 */
function pickDate(panName,widownTitle,startTimeUrl,endTimeUrl) {
	//处理开始时间 结束时间
	var startTime;
	if(startTimeUrl){
		startTimeUrl = startTimeUrl.replace(/-/g,   "/");
		startTime =  new Date(Date.parse(startTimeUrl));
	}
	var endTime;
	if(endTimeUrl){
		endTimeUrl = endTimeUrl.replace(/-/g,   "/");
		endTime =  new Date(Date.parse(endTimeUrl));
	}
	var dDate ;
	var timeL = $("#"+panName).html();
	if(timeL.indexOf("必选")>-1){
		dDate = new Date();
	}else {
		timeL = timeL.replace(/-/g,   "/");
		dDate = new Date(Date.parse(timeL));
	}
	var bTime = dDate.getFullYear() 
				+ "-" + ((dDate.getMonth() + 1) < 10 ? ("0" + (dDate.getMonth() + 1)) : (dDate.getMonth() + 1)) 
				+ "-" + (dDate.getDate() < 10 ? ("0" + dDate.getDate()) : dDate.getDate());
	var defaultAry=[bTime,"yyyy-MM-dd"];
	plus.qytxplugin.selectDateTime(defaultAry,function(e) {
		bTime = e.date;
		var d = new Date(Date.parse(bTime.split(" ")[0].replace(/-/g,   "/")));
		if(startTimeUrl&&d<startTime){
			mui.toast("结束时间不能小于开始时间");
			return false;
		}
		if(endTimeUrl&&d>endTime){
			mui.toast("开始时间不能大于结束时间");
			return false;
		}
		var dateStr = bTime.split(" ")[0];
		$("#"+panName).html(dateStr);
		$("#"+panName).addClass("order-span-after");
		$("#"+panName).removeClass("order-span");
	});
}

/**
 * 获取时间(mui)
 */
function pickDate_old(panName,widownTitle,startTimeUrl,endTimeUrl) {
	//处理开始时间 结束时间
	var startTime;
	if(startTimeUrl!=undefined){
		startTimeUrl = startTimeUrl.replace(/-/g,   "/");
		startTime =  new Date(Date.parse(startTimeUrl));
	}
	var endTime;
	if(endTimeUrl!=undefined){
		endTimeUrl = endTimeUrl.replace(/-/g,   "/");
		endTime =  new Date(Date.parse(endTimeUrl));
	}
	var dDate ;
	var timeL = $("#"+panName).html();
	if(timeL.indexOf("必选")>-1){
		dDate = new Date();
	}else {
		timeL = timeL.replace(/-/g,   "/");
		dDate = new Date(Date.parse(timeL));
	}
	plus.nativeUI.pickDate(function(e) {
		var d = e.date;
		if(startTimeUrl&&d<startTime){
			mui.toast("结束时间不能小于开始时间");
			return false;
		}
		if(endTimeUrl&&d>endTime){
			mui.toast("开始时间不能大于结束时间");
			return false;
		}
		var dateStr = d.getFullYear() 
				+ "-" + ((d.getMonth() + 1) < 10 ? ("0" + (d.getMonth() + 1)) : (d.getMonth() + 1)) 
				+ "-" + (d.getDate() < 10 ? ("0" + d.getDate()) : d.getDate());
		$("#"+panName).html(dateStr);
		$("#"+panName).addClass("order-span-after");
		$("#"+panName).removeClass("order-span");
	}, function(e) {
		//outSet( "未选择日期："+e.message );
	}, {
		title: widownTitle,
//		minDate:startTime,
//		maxDate:endTime,
		date: dDate
	});
}
/**
 * 打开"选择客户"页面
 */
function selectcustomer(){
	mui.openWindow({
	    url: '../customer/selectCustomer.html',
	    id: 'selectCustomer',//不要改
	    extras: {
			viewid: plus.webview.currentWebview().id, // 当前页面的ID
			tapone: 'selectedCustomer' //需要回调的方法
		}
	});
}
function selectedCustomer(objs){
	//赋值(需要改)
	if(objs == undefined){
		console.log('选择客户后，返回了undefined');
	}else{
		//console.log('id='+objs[0]+', name='+objs[1]);
		$("#customerName").html(objs[1]);
		$("#customerName").addClass("order-span-after");
		$("#customerName").removeClass("order-span");
		$("#customerId").val(objs[0]);
	}
	
	//关闭(不要改)
	plus.webview.close("selectCustomerList");
	plus.webview.close("selectCustomer");
}
function plusReady(){
	var self = plus.webview.currentWebview();
	if(self.isUpdate){
		$("#orderTitle").html("编辑销售订单");
		$("#selectOwner").hide();
	}
	//判断是否需要加载订单信息  加载ownerId
	if(self.orderId){//修改
		$("#add_customer").hide();
		$("#edit_customer").show();
		
		var param = {};
		param.userId = window.windowCommon.approveLoginId;
		param.orderId = self.orderId;
		param._clientType = "wap";
		orderAPI._orderDetail(param,function(data){
			$("#orderId").val(data.order.id);
			$("#orderName").val(data.order.orderName);
			$("#customerName").html(data.customerName);
			$("#edit_customer").find("input").eq(0).val(data.customerName);
			$("#customerName").addClass("order-span-after");
			$("#customerName").removeClass("order-span");
			$("#customerId").val(data.order.customerId);
			$("#orderMoney").val(data.order.orderMoney);
			$("#orderTypeV").val(data.order.orderType);
			$("#payTypeV").val(data.order.payType);
			
			if(data.dealTime1){
				$("#dealTime").html(data.dealTime1);
				$("#dealTime").addClass("order-span-after");
				$("#dealTime").removeClass("order-span");
			}
			if(data.beginTime1){
				$("#startTime").html(data.beginTime1);
				$("#startTime").addClass("order-span-after");
				$("#startTime").removeClass("order-span");
			}
			if(data.endTime1){
				$("#endTime").html(data.endTime1);
				$("#endTime").addClass("order-span-after");
				$("#endTime").removeClass("order-span");
			}
			$("#ownerId").val(data.order.ownerId);
			$("#ownerName").html(data.ownerName);
			$("#memo").html(data.order.memo);
			//初始化数据字典
			initOrderDict();
		});
	}else{//新增
		$("#ownerId").val(window.windowCommon.approveLoginId);
		$("#ownerName").html(window.windowCommon.approveLoginName);
		//初始化数据字典
		initOrderDict();
		
	}
	//绑定选择选择单位事件
	$("#customerName").click(function(){
		selectcustomer();
	});
	//绑定订单类型点击事件
	$("#orderTypeStr").click(function(){
		mui("#o_popover").popover('toggle');
	});
	//绑定支付类型点击事件
	$("#payTypeStr").click(function(){
		mui("#p_popover").popover('toggle');
	});
	
	//绑订新增方法
	document.getElementById("saveOrder").addEventListener('tap', function() {
		saveOrder();
	});
	//绑订签单时间
	mui("#dealTime")[0].addEventListener('tap', function(){
		pickDate("dealTime","签单时间");
	});
	//绑订开始时间
	mui("#startTime")[0].addEventListener('tap', function(){
		pickDate("startTime","开始时间",null,$("#endTime").html());
	});
	//绑订结束时间
	mui("#endTime")[0].addEventListener('tap', function(){
		pickDate("endTime","结束时间",$("#startTime").html(),null);
	});
	//绑定选择负责人事件
	mui("#ownerName")[0].addEventListener('tap',function(){
		var ownerId = $("#ownerId").val();//获得负责人
		plus.qytxplugin.selectUsers(ownerId,1,function(data){
			$.each(data,function(i,item){
				$("#ownerName").html(item.userName);
				$("#ownerId").val(item.userId);
			});
		});
	});

	//点击订单类型触发事件
	$("#o_popover").on("click","li",function(){
		$(this).addClass("month-active");
		$(this).siblings().removeClass("month-active");
		$("#orderTypeStr").html($(this).html());//改变span内容
		$("#orderTypeV").val($(this).attr("val"));//隐藏域赋值
		mui("#o_popover").popover('toggle');
	});
	//点击支付类型触发事件
	$("#p_popover").on("click","li",function(){
		$(this).addClass("month-active");
		$(this).siblings().removeClass("month-active");
		$("#payTypeStr").html($(this).html());//改变span内容
		$("#payTypeV").val($(this).attr("val"));//隐藏域赋值
		mui("#p_popover").popover('toggle');
	});

}
