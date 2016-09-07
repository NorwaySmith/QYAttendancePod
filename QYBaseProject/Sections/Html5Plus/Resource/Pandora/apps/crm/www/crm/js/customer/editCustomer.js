/**
 * 往来单位修改页面js
 */
var customerId;
//页面加载完毕方法
mui.plusReady(function() {
	var self = plus.webview.currentWebview();
	customerId = self.customerId;
	
	loadDetail();
	
	mui.init({
		swipeBack: true //启用右滑关闭功能
	});
	mui('.mui-scroll-wrapper').scroll();
	
	//单击获得当前位置
	mui("#getLocation")[0].addEventListener('tap', function() {
		if(plus.os.name=='iOS'){
			plus.qytxplugin.localMessage("", function(data) {
	            $("#customerLocationLongitude").val("");//经度
				$("#customerLocationLatitude").val("");//维度
				$("#customerLocation").val(data);//当前位置
	        });
		}else{
			plus.geolocation.getCurrentPosition( function(data){
				$("#customerLocationLongitude").val(data.coords.longitude);
				$("#customerLocationLatitude").val(data.coords.latitude);
				$("#customerLocation").val(data.addresses);
			}, function ( e ) {
				mui.toast("请求超时");
			},{
				provider:'baidu',
			    timeout:5000//请求超时时间  5秒
			});
		}
	});
	
	$("#popover,#popover1,#popover2,#popover3,#popover4,#popover5").click(function(){
		var id = $(this).attr("id");
		mui("#c_"+id).popover('toggle');
	});
	
	//点击状态触发事件
	$("#c_popover,#c_popover1,#c_popover2,#c_popover3,#c_popover4,#c_popover5").on("click","li",function(){
		$(this).addClass("month-active");
		$(this).siblings().removeClass("month-active");
		var id = $(this).parent().attr("id");
		var parentId = $(this).parents(".mui-popover").attr("id");
		
		if($(this).attr("val") == '0'){
			$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).html($(this).attr("msg"));//改变span内容
			$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).removeClass("order-span-after");
			$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).addClass("order-span");
			$("#h_"+id).val("");//隐藏域赋值
		}else{
			$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).html($(this).html());//改变span内容
			$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).removeClass("order-span");
			$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).addClass("order-span-after");
			$("#h_"+id).val($(this).attr("val"));//隐藏域赋值
		}
		mui("#"+parentId).popover('toggle');
	});
	
	//绑定添加联系人事件
	$(".unit-btn1").click(function(){
		$("#contacts").append($("#contacts ul:first").clone());
		$("#contacts ul:last").show();
	});
	
	//绑定删除联系人事件
	$("#contacts").on("click","em",function(){
		$(this).parent().parent().remove();
		return false;
	});
	
	//绑定选择跟进人事件
	$("#chooseFollower").click(function(){
		var followUserIds = $("#followUserIds").val();//获得跟进人ids
		plus.qytxplugin.selectUsers(followUserIds,0,function(data){
			$("div[tag='follow']").remove();
			$("i[tag='follow']").remove();
			var ids=",";
			$.each(data,function(i,item){
				var userId = item.userId;
				if(userId!=$("#ownerId").val()){
					var html='';
						html+='<div class="unit-img-box ml12" val="'+userId+'" tag="follow">';
						html+='<img class="ml10" src="'+item.userPhoto+'" title="'+item.userName+'" onerror="headError(this);" />';
						html+='<a href="javascript:void(0);">'+item.userName+'</a>';
						html+='</div>';
						html+='<i class="unit-gd" val="'+userId+'" tag="follow">······></i>';
					ids+=userId+",";
					$("#chooseFollower").before(html);
				}
			});
			if(ids==","){
				ids="";
			}
			$("#followUserIds").val(ids);
		});
	});
	
	//绑定长按跟进人头像删除操作
	$(".unit-per-box").on("click","div[tag='follow']",function(){
		var id = $(this).attr("val");
		$(this).remove();
		$("i[val='"+id+"']").remove();
		var followUserIds = $("#followUserIds").val();//获得跟进人ids
		followUserIds = followUserIds.replace(","+id+",",",");
		if(followUserIds==","){
			followUserIds="";
		}
		$("#followUserIds").val(followUserIds);
	});
});

/**
 * 保存联系人
 */
function saveCustomer(){
	plus.nativeUI.showWaiting( "等待中..." );
	if(!$("#customerName").val()){
		plus.nativeUI.closeWaiting();
		mui.toast("单位名称不能为空");
		return false;
	}
	/*if(!$("#customerLocation").val()){
		plus.nativeUI.closeWaiting();
		mui.toast("单位地址不能为空");
		return false;
	}*/
	if(!$("#h_customerState").val()){
		plus.nativeUI.closeWaiting();
		mui.toast("请选择客户状态");
		return false;
	}
	
	var param = {
		_clientType:"wap",
		userId:window.windowCommon.approveLoginId,
		id:customerId, 
		customerName:$("#customerName").val(),
		customerLocation:$("#customerLocation").val(),
		customerLocationLongitude:$("#customerLocationLongitude").val(),
		customerLocationLatitude:$("#customerLocationLatitude").val(),
		customerState:$("#h_customerState").val(),
		customerProfession:$("#h_customerProfession").val(),
		customerLevel:$("#h_customerLevel").val(),
		customerSource:$("#h_customerSource").val(),
		customerFeeling:$("#h_customerFeeling").val(),
		customerProperty:$("#h_customerProperty").val(),
		followUserIds:$("#followUserIds").val(),
		ownerId:$("#ownerId").val()
	}
	_customerApi._saveEdit(param,function(data){
		plus.nativeUI.closeWaiting();
		if(data=='1'){
			var customerWV = plus.webview.getWebviewById("customerDetail");
			customerWV.evalJS("isNeedRefresh=1; updateCustomerDetail('"+$("#customerName").val()+"','"+$("#customerLocation").val()+"','"+$("#popover").find("span").html()+"');");
			mui.toast('保存成功');
			plus.webview.currentWebview().close();
		}else if(data=='0'){
			mui.toast("保存失败");			
			return false;
		}else if(data =='2'){
			mui.toast("单位名称已存在");			
			return false;
		}
	},function(){
		plus.nativeUI.closeWaiting();
		mui.toast("保存失败");			
		return false;
	});
}

//加载详情
function loadDetail(){
	var param={
		_clientType:"wap",
		userId:window.windowCommon.approveLoginId,
		customerId:customerId
	}
	_customerApi._getCustomerDetailForEdit(param,function(customer){
		$("#customerName").val(customer.customerName);
		$("#customerLocation").val(customer.customerLocation);
		$("#customerLocationLatitude").val(customer.customerLocationLatitude);
		$("#customerLocationLongitude").val(customer.customerLocationLongitude);
		$("#followUserIds").val(customer.followUserIds);
		$("#ownerId").val(customer.ownerId);
		
		$.each(customer.dict,function(key,list){
			var cValue = customer[key];
			var parentId = $("#"+key).parents(".mui-popover").attr("id");
			$("#h_"+key).val(cValue);
			$.each(list,function(i,item){
				var html='';
				if(item.value==cValue){
					$("#"+key).find("li").removeClass("month-active");
					html='<li class="mui-table-view-cell month-active" val="'+item.value+'">'+item.name+'</li>';
					$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).html(item.name);
					$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).removeClass("order-span");
					$("#"+parentId.substring(2,parentId.length)).find("span").eq(1).addClass("order-span-after");
				}else{
					html='<li class="mui-table-view-cell" val="'+item.value+'">'+item.name+'</li>';
				}
    			$("#"+key).append(html);
			});
		});
		
		
		//初始化负责人头像
		var ownerHeadHtml='';
		ownerHeadHtml+='<div class="unit-img-box" id="owner">';
		ownerHeadHtml+='<img class="ml10" src="'+window.windowCommon.photoUrl+customer.ownerMap.userPhoto+'" title="'+customer.ownerMap.userName+'" onerror="headError(this);" />';
		ownerHeadHtml+='<a href="javascript:void(0);">'+customer.ownerMap.userName+'</a>';
		ownerHeadHtml+='</div>';
		ownerHeadHtml+='<i class="unit-gd">······></i>';
		$(".unit-img-box").before(ownerHeadHtml);
		
		//初始化跟进人头像
		$.each(customer.followerList, function(i,item) {
			var html='';
				html+='<div class="unit-img-box" val="'+item.userId+'" tag="follow">';
				html+='<img class="" src="'+item.userPhoto+'" title="'+item.userName+'" onerror="headError(this);" />';
				html+='<a href="javascript:void(0);">'+item.userName+'</a>';
				html+='</div>';
				html+='<i class="unit-gd" val="'+item.userId+'" tag="follow">······></i>';
			$("#chooseFollower").before(html);
		});
	});
}
