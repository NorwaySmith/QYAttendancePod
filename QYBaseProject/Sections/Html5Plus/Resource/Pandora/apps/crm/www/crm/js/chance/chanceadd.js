/**
 * 销售机会新增/修改页面js
 */
var cid;
var viewId; //来源页面id
var callbackFun; //来源页面回调函数

//页面加载完毕方法
mui.plusReady(function() {
	var self = plus.webview.currentWebview();
	cid = self.cid;//获得来源页面的机会id
	viewId = self.viewId;//来源页面的id
	callbackFun = self.callbackFun;//来源页面的回调函数

	mui.init({
		swipeBack: true //启用右滑关闭功能
	});
	mui('.mui-scroll-wrapper').scroll();


	if (cid) {//如果有机会id，则是编辑页面
		mui('.mui-title')[0].innerHTML = '编辑销售机会';
		//移除必填项的灰色效果
		removeallhui();
		//初始化机会详情
		initChanceInfo(cid, initSellStage);
		//修改页面不允许修改往来单位
		$("#selectcustomer").hide();
		$("#edit_customer").show();
	} else {//新增页面
		//初始化销售阶段数据字典
		initSellStage();
		//绑订单位名称
		document.getElementById("selectcustomer").addEventListener('tap', function() {
			selectcustomer();
		});
	}

	//绑订完成的方法
	document.getElementById("submitBtn").addEventListener('tap', function() {
		addOne();
	});

	//绑订销售阶段的方法
	document.getElementById("sellStageLI").addEventListener('tap', function() {
		mui('.mui-popover').popover('toggle');
	});

	//绑订预计成交时间
	document.getElementById("expectedTimeLI").addEventListener('tap', function() {
		pickDate();
	});

});

/**
 * 修改页面时，调用这个方法。把三个选择项移除灰色字样式。
 */
var removeallhui = function() {
	var spans = mui('.shi-sale-one span');
	for (var i = 0; i < spans.length; i++) {
		removeClass(spans[i], 'hui');
	}
}

/**
 * 初始化销售机会信息
 */
var initChanceInfo = function(id, callback) {
	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"id": id
	};

	_chanceApi._findChance(data, function(response) {

		document.getElementById("cid").value = response.chance.id;
		document.getElementById("chanceName").value = response.chance.chanceName;
		document.getElementById("chanceMoney").value = response.chance.chanceMoneyNF;
		document.getElementById("expectedTime").innerHTML = response.chance.expectedTimeU.replace('-','年').replace('-','月')+'日';
		timeL = response.chance.expectedTimeL;
		document.getElementById("remark").value = response.chance.remark;
		document.getElementById("selectcustomerSPAN").innerHTML = response.chance.customerName;
		$("#edit_customer").find("input").eq(0).val(response.chance.customerName);
		document.getElementById("customerId").value = response.chance.customerId;
		document.getElementById("sellStage").value = response.chance.sellStage;
		document.getElementById("sellStageSPAN").innerHTML = response.chance.sellStageName;
		if (callback != undefined && callback != null) {
			callback();
		}
	});
}

/**
 * 初始化销售阶段
 */
var initSellStage = function() {
	var data = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"infoType": 'sellStage' //sellStage表示销售阶段
	};

	_chanceApi._getDictType(data, initSellStageSuccess);
}

/**
 * 初始化销售阶段的响应
 * @param {Object} response
 */
var initSellStageSuccess = function(response) {
	if (response.code == 1) {
		var sellStage = document.getElementById("sellStage").value;


		var sellStageULObj = document.getElementById("sellStageUL");
		sellStageULObj.innerHTML = '';
		mui.each(response.data, function(i, n) {
			var subli02 = document.createElement("li");
			if (sellStage == response.data[i].value) {
				subli02.setAttribute("class", "mui-table-view-cell month-active");
			} else {
				subli02.setAttribute("class", "mui-table-view-cell");
			}
			subli02.setAttribute("name", response.data[i].value);
			subli02.innerHTML = response.data[i].name;
			sellStageULObj.appendChild(subli02);
		});

		var lis = mui("#sellStageUL li");
		mui.each(lis, function(i, n) {
			lis[i].addEventListener("tap", function() {
				selectSellStage(lis[i]);
			});
		});
	}
}

/**
 * 选择一个销售阶段
 * @param {Object} obj
 */
var selectSellStage = function(obj) {
	//修改样式
	var lis = mui("#sellStageUL li");
	mui.each(lis, function(i, n) {
		lis[i].setAttribute("class", "mui-table-view-cell");
	});
	obj.setAttribute("class", "mui-table-view-cell month-active");
	removeClass(document.getElementById("sellStageSPAN"), 'hui');

	//赋值
	document.getElementById("sellStage").value = obj.getAttribute("name");
	document.getElementById("sellStageSPAN").innerHTML = obj.innerHTML;

	//消失
	mui('.mui-popover').popover('toggle');
}



/**
 * 新增销售机会
 */
var addOne = function() {
	plus.nativeUI.showWaiting("等待中...");

	//销售机会名称
	var chanceName = document.getElementById("chanceName").value;
	if (!verifyEmpty(chanceName)) {
		mui.toast('请输入机会名称!');
		plus.nativeUI.closeWaiting();
		return;
	}

	//预计金额
	var chanceMoney = document.getElementById("chanceMoney").value;
	if (!verifyEmpty(chanceMoney)) {
		mui.toast('请输入预计金额!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if (chanceMoney.indexOf('-') == 0) {
		mui.toast('预计金额必须为正数!');
		plus.nativeUI.closeWaiting();
		return;
	}
	chanceMoney = new Number(chanceMoney);
	if (isNaN(chanceMoney)) {
		mui.toast('预计金额必须为数字!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if(chanceMoney==0){
		mui.toast('预计金额必须为正数!');
		plus.nativeUI.closeWaiting();
		return;
	}
	if(!verifyPoints(chanceMoney, 2)){
		mui.toast('小数点位数最多为两位!');
		plus.nativeUI.closeWaiting();
		return;
	}

	//往来单位ID
	var customerId = document.getElementById("customerId").value;
	if (!verifyEmpty(customerId, 0)) {
		mui.toast('请选择单位名称!');
		plus.nativeUI.closeWaiting();
		return;
	}
	//销售阶段
	var sellStage = document.getElementById("sellStage").value;
	if (!verifyEmpty(sellStage)) {
		mui.toast('请选择销售阶段!');
		plus.nativeUI.closeWaiting();
		return;
	}

	//预计成交时间
	var expectedTime = document.getElementById("expectedTime").innerHTML;
	if (!verifyEmpty(expectedTime, '请选择预计成交时间(必选)')) {
		mui.toast('请选择预计成交时间!');
		plus.nativeUI.closeWaiting();
		return;
	}
	var patt = new RegExp("\\D", "gm");
	expectedTime = expectedTime.replace(patt, "-");
	if (expectedTime.lastIndexOf('-') == (expectedTime.length - 1)) {
		expectedTime = expectedTime.substring(0, expectedTime.length - 1);
	}

	//备注
	var remark = document.getElementById("remark").value;

	var param = {
		"_clientType": "wap",
		"id": document.getElementById("cid").value,
		"userId": window.windowCommon.approveLoginId,
		"chanceName": chanceName,
		"chanceMoney": chanceMoney,
		"customerId": customerId,
		"sellStage": sellStage,
		"expectedTime": expectedTime,
		"remark": remark
	};

	_chanceApi._saveOrUpdateChance(param, function(response) {
		plus.nativeUI.closeWaiting();
		if (response.code == 1) {
			mui.toast('保存成功！');
			if (viewId && callbackFun) {
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun + "();");
			}
			plus.webview.currentWebview().close();
		} else {
			mui.toast('保存失败！');
		}
	}, function() {
		plus.nativeUI.closeWaiting();
	});
}

/**
 * 验证空值
 * @param {Object} val
 * @param {Object} defval
 */
var verifyEmpty = function(val, defval) {
	if (val == null || val == undefined) {
		return false;
	}
	if (defval == null || defval == undefined) {
		if (val == '') {
			return false;
		}
	} else {
		if (val == defval) {
			return false;
		}
	}
	return true;
}

/**
 * 打开"选择客户"页面
 */
var selectcustomer = function() {
	mui.openWindow({
		url: '../customer/selectCustomer.html',
		id: 'selectCustomer', //不要改
		extras: {
			viewid: 'chanceadd', // 当前页面的ID
			tapone: 'taponecustomer' //需要回调的方法
		}
	});
}

/**
 * 选择客户后的回调方法
 * @param {Object} objs 长度为2，[0]是ID， [1]是name
 */
var taponecustomer = function(objs) {

	//赋值(需要改)
	if (objs == undefined) {
		console.log('选择客户后，返回了undefined');
	} else {
		document.getElementById("selectcustomerSPAN").innerHTML = objs[1];
		document.getElementById("customerId").value = objs[0];
	}

	//修改样式
	removeClass(document.getElementById("selectcustomerSPAN"), 'hui');

	//关闭(不要改)
	plus.webview.close("selectCustomerList");
	plus.webview.close("selectCustomer");
}

var timeL = '';//期望成交时间字符串
/**
 * 调用手机端原生选择时间控件
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
		var y = bTime.split(" ")[0].split("-")[0];
		var m = bTime.split(" ")[0].split("-")[1];
		var d = bTime.split(" ")[0].split("-")[2];
		if(m.indexOf("0")==0){
			m = m.substring(1);
		}
		if(d.indexOf("0")==0){
			d= d.substring(1);
		}
		var expectedTime = document.getElementById("expectedTime");
		var dateStr = y + "年" + m + "月" + d + "日";
		//赋值
		expectedTime.innerHTML = dateStr;
		timeL = bTime;

		//修改样式
		removeClass(document.getElementById("expectedTime"), 'hui');
					
	});
		
	
}
/**
 * 获取时间（mui）
 */
function pickDate_old() {
	var dDate = undefined;
	if (timeL == undefined) {
		dDate = new Date();
	} else {
		dDate = new Date(timeL);
	}

	plus.nativeUI.pickDate(function(e) {
		var d = e.date;
		var expectedTime = document.getElementById("expectedTime");
		var dateStr = d.getFullYear() + "年" + (d.getMonth() + 1) + "月" + d.getDate() + "日";
		//赋值
		expectedTime.innerHTML = dateStr;
		timeL = d.getTime();

		//修改样式
		removeClass(document.getElementById("expectedTime"), 'hui');
	}, function(e) {
		//outSet( "未选择日期："+e.message );
	}, {
		title: "请选择日期",
		date: dDate
			/*,minDate:minDate,
			maxDate:maxDate*/
	});
}