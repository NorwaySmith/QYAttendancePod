/**
 * 往来单位新增页面js
 */
var viewId; //来源页面id
var callbackFun; //来源页面回调函数
//页面加载完毕方法
mui.plusReady(function() {
	var self = plus.webview.currentWebview();
	viewId = self.viewId;
	callbackFun = self.callbackFun;
//	var dataJson=plus.qytxplugin.getLoginUserInfo();
	var user={};
//	if(typeof(dataJson)=="string"){
//		user=JSON.parse(dataJson);
//	}else{
//		user=dataJson;
//	}
	//拼装跟进人头像
	var headHtml='';
		headHtml+='<div class="unit-img-box" id="owner">';
		headHtml+='<img class="ml10" src="'+window.windowCommon.photoUrl+user.photo+'" title="'+window.windowCommon.approveLoginName+'" onerror="headError(this);" />';
		headHtml+='<a href="javascript:void(0);">'+window.windowCommon.approveLoginName+'</a>';
		headHtml+='</div>';
		headHtml+='<i class="unit-gd">······></i>';
	$(".unit-img-box").before(headHtml);
	//初始化客户数据字典
	initCustomerDict();
	
	mui.init({
		swipeBack: true //启用右滑关闭功能
	});
	mui('.mui-scroll-wrapper').scroll();
	
	//单击获得当前位置
	mui("#getLocation")[0].addEventListener('tap', function() {
		//获取地理位置
		if(plus.os.name=='iOS'){
			plus.qytxplugin.localMessage("", function(data) {
	            $("#customerLocationLongitude").val("");//经度
				$("#customerLocationLatitude").val("");//维度
				$("#customerLocation").val(data);//当前位置
	        });
		}else{
			plus.geolocation.getCurrentPosition( function(data){
				$("#customerLocationLongitude").val(data.coords.longitude);//经度
				$("#customerLocationLatitude").val(data.coords.latitude);//维度
				$("#customerLocation").val(data.addresses);//当前位置
			}, function ( e ) {
				mui.toast("请求超时");
			},{
				provider:'baidu',
			    timeout:5000//请求超时时间  5秒
			});//必填 代表调用百度api
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
				if(userId!=user.userId){
					var html='';
						html+='<div class="unit-img-box" val="'+userId+'" tag="follow">';
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

$(function(){
	$(".unit-more-thing").click(function(){
		$(".unit-three").show();
		$(".unit-more-box").hide();
	});
})

/**
 * 初始化新增页面数据字典
 */
function initCustomerDict(){
	var param = {
		"_clientType":"wap",
		"userId":window.windowCommon.approveLoginId
	};
	_customerApi._getCustomerDict(param,function(data){ 
		$.each(data,function(key,list){
			$.each(list,function(i,item){
				if(key == 'customerState' && i==0){
					$("#popover").find("span").eq(1).html(item.name);
					$("#popover").find("span").eq(1).removeClass("order-span");
					$("#popover").find("span").eq(1).addClass("order-span-after");
					$("#h_customerState").val(item.value);
				}
				var html='';
				html+='<li class="mui-table-view-cell" val="'+item.value+'">';
    			html+=item.name;
    			html+='	</li>';
    			$("#"+key).append(html);
			});
		});
	});
}

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
	
	var contactList=[];
	var contactUls = $("#contacts").find("ul");
	for(var i=1;i<contactUls.length;i++){
		var ul = contactUls.eq(i);
		var contact={};
		if(!ul.find("input[name='contactName']").val()){
			plus.nativeUI.closeWaiting();
			mui.toast("联系人姓名不能为空");
			return false;
		}
		var reg = /^(13[0-9]|15[0-9]|17[0-9]|18[0-9])\d{8}$/;
		if(ul.find("input[name='telphone']").val() && !reg.test(ul.find("input[name='telphone']").val())){
			plus.nativeUI.closeWaiting();
			mui.toast("手机号码为"+ul.find("input[name='telphone']").val()+"格式有误");
      		return false;
		}
		
		var reg1 = /^0(([1-9]\d)|([3-9]\d{2}))\d{8}$/;
		if(ul.find("input[name='phone']").val() && !reg1.test(ul.find("input[name='phone']").val())){
			plus.nativeUI.closeWaiting();
			mui.toast("座机号码为"+ul.find("input[name='phone']").val()+"格式有误");
      		return false;
		}
		
		var reg2 = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
		if(ul.find("input[name='email']").val() && !reg2.test(ul.find("input[name='email']").val())){
			plus.nativeUI.closeWaiting();
			mui.toast("邮箱为"+ul.find("input[name='email']").val()+"格式有误");
      		return false;
		}
		
		
		contact.contactName = ul.find("input[name='contactName']").val();
		contact.telphone = ul.find("input[name='telphone']").val();
		contact.phone = ul.find("input[name='phone']").val();
		contact.jobName = ul.find("input[name='jobName']").val();
		contact.email = ul.find("input[name='email']").val();
		contact.remark = ul.find("input[name='remark']").val();
		contactList[contactList.length] = contact;
	}
	
	var param = {
		_clientType:"wap",
		userId:window.windowCommon.approveLoginId,
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
		contactJson:JSON.stringify(contactList),
		ownerId:window.windowCommon.approveLoginId
	}
	_customerApi._saveCustomer(param,function(data){
		plus.nativeUI.closeWaiting();
		if(data=='1'){
			mui.toast('保存成功');
			if (viewId && callbackFun) {
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun + "();");
			}else{
				var customerWV = plus.webview.getWebviewById("customer");
				customerWV.evalJS("refreshChildData();");
				plus.webview.close("addCustomer");
			}
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

/**
 * 处理数字输入的正则表达式
 */
function regNumber(obj){
	var value = $(obj).val();
	if(/\D/g.test(value)){
		value = value.replace(/\D/g,'');
		$(obj).val(value);
	}
}
