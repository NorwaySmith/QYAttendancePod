/**
 * 跟进人页面js
 */
var cid = undefined;
var currentownerid = undefined;

var viewId;
var callbackFun;
var isNeedRefresh=0;


//页面加载完毕方法
mui.plusReady(function() {
	//得到父页面的参数信息
	var self = plus.webview.currentWebview();
	cid = self.cid;
	
	viewId = self.viewId;
    callbackFun = self.callbackFun;
	
	mui.init({
		beforeback: function(){
			if(viewId && callbackFun && isNeedRefresh){
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun+"();");
			}
		}
	});
	
	//初始化人员信息
	initChanceInfo(self.cid);
	
	//绑订修改负责人的方法
	document.getElementById("changeownerIMG").addEventListener('tap', function() {
		changeowner();
	});
	
	/*//绑订添加跟进人的方法
	document.getElementById("addfollowerIMG").addEventListener('tap', function() {
		//console.log('添加跟进人');
		changefollower('add');
	});*/
	
});

/**
 * 删除跟进人的方法
 */
var bindingdels = function(){
	//绑订删除跟进人的方法
	var dels = mui(".unit-follow-del");
	mui.each(dels, function(i, n) {
		dels[i].addEventListener("tap", function() {
			//console.log('删除跟进人');
			var fid = mui(this)[0].getAttribute("fid");
			changefollower('del', fid);
		});
	});
}
/**
 * 初始化销售机会信息
 */
var initChanceInfo = function(id, callback){
	//console.log('id='+id);
	//console.log('初始化销售机会信息');
	//var url = window.windowCommon.basePath + 'crm/chance/findChance.c';
	
	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"id": id
	};
	_chanceApi._findChance(data, function(response){
			
			initUserInfo(response.chance.usermap);
			
			if (callback != undefined && callback != null) {
				callback();
			}
		});
}

/**
 * 初始化销售阶段
 */
var initUserInfo = function(usermap){
	//console.log(JSON.stringify(usermap));
	initOwnerInfo(usermap);
	initFollowerInfo(usermap);
	bindingdels();
}

/**
 * 给负责人赋值
 * @param {Object} usermap
 */
var initOwnerInfo = function(usermap){
	//console.log(JSON.stringify(usermap));
	currentownerid = usermap.owner.id;
	mui("#ownerid")[0].value = usermap.owner.id;
	mui("#owner")[0].innerHTML='';
	var img = document.createElement("img");
	img.setAttribute("src", window.windowCommon.photoUrl+usermap.owner.photo);
	img.setAttribute("alt", "");
	img.setAttribute("class","ml10");
	img.setAttribute("title", usermap.owner.name);
	img.setAttribute("onerror", "headError(this);");
	mui("#owner")[0].appendChild(img);
	var a = document.createElement("a");
	a.innerHTML = usermap.owner.name;
	mui("#owner")[0].appendChild(a);
}

/**
 * 给跟进人人赋值
 * @param {Object} usermap
 */
var initFollowerInfo = function(usermap){
	var followerids = ',';
	
	var div1 = document.createElement("div");
	div1.setAttribute("class", "unit-img-box ml12");
	div1.setAttribute("id", "addfollower");
	//div1.innerHTML = html;
	var img1 = document.createElement("img");
	img1.setAttribute("class", "ml10");
	img1.setAttribute("src", "../../images/unit-follow-ico_10.png");
	img1.setAttribute("id", "addfollowerIMG");
	//绑订添加跟进人的方法
	img1.addEventListener('tap', function() {
		//console.log('添加跟进人');
		changefollower('add');
	});
	div1.appendChild(img1);
	var a1 = document.createElement("a");
	a1.innerHTML = '添加';
	div1.appendChild(a1);
	
	var div2 = document.createElement("div");
	div2.setAttribute("class", "unit-img-box unit-dele ml12");
	div2.setAttribute("id", "delfollower");
	
	var img2 = document.createElement("img");
	img2.setAttribute("class", "ml10");
	img2.setAttribute("src", "../../images/unit-follow-ico_07.png");
	img2.addEventListener('tap', function() {
		if($(".unit-follow-del").is(":hidden")){
   			$(".unit-follow-del").show();   //如果元素为隐藏,则将它显现
		}else{
		     $(".unit-follow-del").hide();     //如果元素为显现,则将其隐藏
		}	
	});
	div2.appendChild(img2);
	var a2 = document.createElement("a");
	a2.innerHTML = '移除';
	div2.appendChild(a2);
	
	document.getElementById("followers").innerHTML = '';
	document.getElementById("followers").appendChild(div1);
	document.getElementById("followers").appendChild(div2);
	
	var html = '';
	
	mui.each(usermap.followers, function(i, n) {
		followerids += n.id + ','
		html += '<img class="ml10" alt="" title="'+n.name+'" src="'+window.windowCommon.photoUrl + n.photo+'" onerror="headError(this);" />';
		
		html += '<a>'+n.name+'</a>';
		html += '<em class="unit-follow-del" style="display: none;" fid="'+n.id+'"></em>';
		
		var divObj = document.createElement("div");
		divObj.setAttribute("class", "unit-img-box ml12 unit-ps");
		divObj.setAttribute("fid", n.id);
		divObj.innerHTML = html;
		//document.getElementById("followers").appendChild(divObj);//
		var list = document.getElementById("followers");
		list.insertBefore(divObj, list.childNodes[0]);
		html = '';
	});
	document.getElementById("followerids").value = followerids;
}


/**
 * 点击修改负责人
 */
var changeowner = function(){
	
	var ownerid = document.getElementById("ownerid").value;
	ownerid = ','+ownerid+',';
	/*
	 * 第一个参数，已经勾选的人员ID，有多个时，逗号分割。
	 * 第二个参数，0表示多选， 1表示单选
	 * 第三个参数，回调方法，响应：[{"userId"：123, "userName": "张三", "userPhoto": "xx/xx.jpg", "picType":"string"},{}, ... ...]
	 */
	plus.qytxplugin.selectUsers(ownerid, 1, function(data) {
		if (data != null && data != undefined && data.length > 0) {
			mui.confirm('确认变更负责人吗？', "变更负责人", null, function(e) {
				if (e.index == 0) {
					changeownersubmit(data[0].userId);
				} else if (e.index == 1) {
					//console.log('取消');
				}
			});
		}else {
			mui.toast('请选择负责人！');
		}
	});
}

/**
 * 变更负责人
 * @param {Object} ownerid
 */
var changeownersubmit = function(ownerid){
	//console.log('ownerId='+ownerid);
	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"cid": cid,
		"ownerid": ownerid,
		"which": 3
	};
	
	//var url = window.windowCommon.basePath + 'crm/chance/modifyChancePart.c';
	_chanceApi._modifyChancePart(data, function(response){
			if(response.code == 1){
				initUserInfo(response.usermap);
				isNeedRefresh=1;
				mui.toast('修改成功！');
			}else if(response.code == 0){
				mui.toast('操作失败！');
			}else {
				mui.toast('没有权限！');
			}
		});
}

/**
 * 点击添加跟进人按钮
 */
var changefollower = function(opera, fid){
	//现有跟进人
	var followerids = document.getElementById("followerids").value
	
	if(opera == 'add'){
		/*
		 * 第一个参数，已经勾选的人员ID，有多个时，逗号分割。
		 * 第二个参数，0表示多选， 1表示单选
		 * 第三个参数，回调方法，响应：[{"userId"：123, "userName": "张三", "userPhoto": "xx/xx.jpg", "picType":"string"},{}, ... ...]
		 */
		plus.qytxplugin.selectUsers(followerids, 0, function(data) {
			if (data != null && data != undefined && data.length > 0) {
				followerids = ',';
				for (var i=0;i<data.length;i++){
					followerids += data[i].userId+',';
				}
				//当选择的跟进人中有当前的负责人时，移除。
				followerids = followerids.replace(','+currentownerid+',', ',');
				
				if(followerids==","){
					followerids="";
				}
				changefollowersubmit(followerids);
			}else {
				mui.toast('请选择跟进人！');
			}
		});
	}else {
		followerids = followerids.replace(','+fid+',', ',');
		changefollowersubmit(followerids);
	}
}

/**
 * 保存跟进人
 * @param {Object} followerids
 */
var changefollowersubmit = function(followerids){
	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"cid": cid,
		"followUserIds": followerids,
		"which": 2
	};
	
	//var url = window.windowCommon.basePath + 'crm/chance/modifyChancePart.c';
	_chanceApi._modifyChancePart(data, function(response){
			if(response.code == 1){
				initUserInfo(response.usermap);
				isNeedRefresh=1;
				mui.toast('修改成功！');
			}else if(response.code == 0){
				mui.toast('操作失败！');
			}else {
				mui.toast('没有权限！');
			}
		});
}