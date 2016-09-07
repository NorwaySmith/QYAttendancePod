/**
 * 联系人新增页面js
 */
mui.plusReady(function(){
	$("#addcontact").click(function(){
		addcontact();
		return false;
	});
	
	mui("#operate")[0].addEventListener("click",function(){
		mui("#popover1").popover("toggle");
	});
	
	//点击状态触发事件
	$("#popover1").on("click","li",function(){
		addContactType(this);
		mui("#popover1").popover("toggle");
	});
	
	mui("#operate4")[0].addEventListener("click",function(){
		mui("#popover4").popover("toggle");
	});
	
	//点击状态触发事件
	$("#popover4").on("click","li",function(){
		selectSex(this);
		mui("#popover4").popover("toggle");
	});
	
	//点击选择客户
	$(".link")[0].addEventListener("tap",function(){
		selectcustomer();
	});
	
	mui.init({
		swipeBack: true, //启用右滑关闭功能
		beforeback: function(){
			/*if(viewId && callbackFun && isNeedRefresh){
				var parent = plus.webview.getWebviewById("contact");
				parent.evalJS("refreshChildData();");
			}*/
		}
	});
	mui('.mui-scroll-wrapper').scroll();
});



/**
 * 选择性别
 * @param {Object} obj
 */
function selectSex(obj){
	if(obj.innerHTML=="男"){
		$("#sex").val(1);
		$("#sexName").html("男");
		mui("#nanLi")[0].setAttribute("class", "mui-table-view-cell month-active");
		mui("#nvLi")[0].setAttribute("class", "mui-table-view-cell");
	}else if(obj.innerHTML=="女"){
		$("#sex").val(0);
		$("#sexName").html("女");
		mui("#nanLi")[0].setAttribute("class", "mui-table-view-cell");
		mui("#nvLi")[0].setAttribute("class", "mui-table-view-cell month-active");
	}
}

/**
 * 添加联系方式
 * @param {Object} obj
 */
function addContactType(obj){
	var html ="";
	html += "<li class=\"mui-table-view-cell\">";
	var type = "";
	var typeId = "";
	var len = 20;
	console.log(obj.innerHTML)
	if(obj.innerHTML=="手机"){
		type= "手机";
		typeId = "telphone";
	}else if(obj.innerHTML=="座机"){
		type= "座机";
		typeId = "phone";
	}else if(obj.innerHTML=="QQ"){
		type= "QQ";
		typeId = "qq";
	}else if(obj.innerHTML=="邮箱"){
		type= "邮箱";
		typeId = "email";
		len = 100;
	}
	html += "<a class=\"ts1\">"+type+"</a>";
	if(obj.innerHTML=="邮箱"){
	 	html += "<input type=\"text\" placeholder=\"请输入联系人"+type+"\" name=\""+typeId+"\" maxlength='"+len+"' />";
	}else{
	 	html += "<input type=\"text\" placeholder=\"请输入联系人"+type+"\" name=\""+typeId+"\" maxlength='"+len+"' onkeyup=\"this.value=this.value.replace(/[^0-9]/g,'')\"/>";
	}
	html += "<em class=\"per-way-del\" onclick=\"shanchu(this)\"></em>";
	html += "</li>";
	$("#fs").before(html);
}
/**
 * 删除联系方式
 * @param {Object} obj
 */
function shanchu(obj){
	$(obj).parent().remove();
}
/**
 * 保存联系人
 */
function addcontact(){
	plus.nativeUI.showWaiting( "等待中..." );
	
	var contactName = $.trim($("#contactName").val());
	if(contactName==""){
	 	mui.toast("请输入联系人姓名");
	 	plus.nativeUI.closeWaiting();
	 	return false;
	 }
	var customerId = $.trim($("#customerId").val());
	var customerName = $.trim($("#customerName").val());
	if(customerName==undefined||customerName==""){
		mui.toast("请输入单位名称");
		plus.nativeUI.closeWaiting();
	 	return false;
	}
	 
	var groupName = $.trim($("#groupName").val());
	 /*if(groupName==""){
	 	mui.alert("请输入联系人部门");
	 	return;
	 }*/
	var jobName = $.trim($("#jobName").val());
	 /*if(jobName==""){
	 	mui.alert("请输入联系人职务");
	 	return;
	 }*/
	var telphone1 = document.getElementsByName("telphone");
	var telphone = "";
	for (var i=0;i<=telphone1.length-1;i++) {
	 //	alert(telphone1[i].value);
		if(telphone1[i].value!=""){
			var reg = /^(13[0-9]|15[0-9]|17[0-9]|18[0-9])\d{8}$/;
			if (reg.test(telphone1[i].value)) {
				telphone +=","+ telphone1[i].value;
			}else{
				mui.toast("手机号码为"+telphone1[i].value+"格式有误");
				plus.nativeUI.closeWaiting();
				return false;
			}
		}
	}
	if(telphone!=""){
	 	telphone += ",";
	}
	var phone1 = document.getElementsByName("phone");
	var phone = "";
	for (var i=0;i<=phone1.length-1;i++) {
	 	if(phone1[i].value!=""){
 			var reg1 = /^0(([1-9]\d)|([3-9]\d{2}))\d{8}$/;
 			if(reg1.test(phone1[i].value)){
 				phone +=","+ phone1[i].value;
 			}else{
 				mui.toast("座机号码为"+phone1[i].value+"格式有误");
 				plus.nativeUI.closeWaiting();
 				return false;
 			}
	 //	alert(telphone1[i].value);
		}
	}
	if(phone!=""){
	 	phone += ",";
	}
	 
	var qq1 = document.getElementsByName("qq");
	var qq = "";
	for (var i=0;i<=qq1.length-1;i++) {
	 //	alert(telphone1[i].value);
	 	if(qq1[i].value!=""){
			var reg2 = /^[1-9]\d{4,10}$/;
    		if (reg2.test(qq1[i].value)) {
    			qq +=","+ qq1[i].value;
    		}else{
    			mui.toast("qq为"+qq1[i].value+"格式有误");
    			plus.nativeUI.closeWaiting();
    			return;
    		}
		}
	}
	if(qq!=""){
		qq += ",";
	}
	var email1 = document.getElementsByName("email");
	var email = "";
	for (var i=0;i<=email1.length-1;i++) {
	 //	alert(telphone1[i].value);
		if(email1[i].value!=""){
			var reg3 = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
    		if (reg3.test(email1[i].value)) {
	    		email +=","+ email1[i].value;
	    	}else{
	    		mui.toast("邮箱为"+email1[i].value+"格式有误");
	    		plus.nativeUI.closeWaiting();
	    		return false;
	    	}
		}
	}
	if(email!=""){
		email += ",";
	}
	 
	var sex = $("#sex").val();
	var birthday = $.trim($("#birthday").val());
	var address = $.trim($("#address").val());
	var favorite = $.trim($("#favorite").val());
	var remark = $.trim($("#remark").val());
	
	var param = {
		"_clientType": "wap",
				"userId":window.windowCommon.approveLoginId,
				"contactName":contactName,
				"customerId":customerId,
				"customerName":customerName,
				"groupName":groupName,
				"jobName":jobName,
				"telphone":telphone,
				"phone":phone,
				"qq":qq,
				"email":email,
				"sex":sex,
				"birthday":birthday,
				"address":address,
				"favorite":favorite,
				"type":'add',
				"remark":remark
	}
	contactApi.saveContact(param,function(data){
		plus.nativeUI.closeWaiting();
		if(data=="1"){
			mui.toast("保存成功");
			plus.webview.getWebviewById('contact').evalJS("refreshChildData()");
			plus.webview.close("addcontact", "auto", 100 );
		}else if(data == "0"){
			mui.toast("保存失败");
			return false;	
		}else if(data == "2"){
			mui.toast("单位名称已存在");
			return false;			
		}
	})
	
}

var timeL = '';
/**
 * 获取时间
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
		var birthday = document.getElementById("birthday");
		//赋值
		birthday.value = bTime.split(" ")[0];
		timeL = bTime;

		//修改样式
		removeClass(document.getElementById("birthday"), 'hui');
					
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
	var birthday = document.getElementById("birthday");
	if(birthday.value!=""){
		dDate = new Date(Date.parse(birthday.value));
	}
	plus.nativeUI.pickDate(function(e) {
		var d = e.date;
		var dateStr = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate() ;
		birthday.value = dateStr;
	}, function(e) {
		//outSet( "未选择日期："+e.message );
	}, {
		title: "请选择生日",
		date: dDate
		/*,minDate:minDate,
		maxDate:maxDate*/
	});
}


/**
 * 打开"选择客户"页面
 */
var selectcustomer = function(){mui.openWindow({
	    url: '../customer/selectCustomer.html',
	    id: 'selectCustomer',//不要改
	    extras: {
			viewid: 'addcontact', // 当前页面的ID
			tapone: 'taponecustomer' //需要回调的方法
		}
	});
}

/**
 * 回调方法
 * @param {Object} objs 长度为2，[0]是ID， [1]是name
 */
var taponecustomer = function (objs){
	//赋值(需要改)
	if(objs == undefined){
		console.log('选择客户后，返回了undefined');
	}else{
		$("#customerId").val(objs[0]);
		$("#customerName").val(objs[1]);
	}
	
	//关闭(不要改)
	plus.webview.close("selectCustomerList");
	plus.webview.close("selectCustomer");
}