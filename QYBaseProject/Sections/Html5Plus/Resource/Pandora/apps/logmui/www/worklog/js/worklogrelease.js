var totalPage = 999;
//页面加载完毕方法
mui.plusReady(function() {
	//判断当前是否有网络
	if(!getNetConnection()){
		$(".mui-content").hide();
		$(".noNet").show();
		return false;
	}
	mui.init({
		beforeback: function() {
			if(plus.webview.getWebviewById(plus.webview.currentWebview().indexId) != undefined) {
				// 新建日志后进入我发布的列表， 这种情况下返回刷新首页的数据
				// 若从首页直接进入我发布的列表， 这种情况下返回不刷新首页的数据
				plus.webview.getWebviewById(plus.webview.currentWebview().indexId).evalJS(plus.webview.currentWebview().callbackFun);
			}
			
		}
	});

	//点击开始时间按钮
	document.getElementById("startTime").addEventListener('tap', function() {
		/*var dDate = new Date(document.getElementById("startTime").innerHTML);
		plus.nativeUI.pickDate(function(e) {
			var d = e.date;
			document.getElementById("startTime").innerHTML = formatDate(d);
		}, function(e) {

		}, {
			title: "请选择日期",
			date: dDate
		});*/
		var timeL = document.getElementById("startTime").value;
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
		//调用手机端API,获取日历插件
		plus.qytxplugin.selectDateTime(defaultAry,function(da){
			bTime = da.date;
			var startTime = document.getElementById("startTime");
			var dateStr = bTime.split(" ")[0];
			//赋值
			startTime.innerHTML = dateStr;
		});
		
	})

	//点击结束时间按钮
	document.getElementById("endTime").addEventListener('tap', function() {
		/*var dDate = new Date(document.getElementById("endTime").innerHTML);
		plus.nativeUI.pickDate(function(e) {
			var d = e.date;
			document.getElementById("endTime").innerHTML = formatDate(d);
		}, function(e) {

		}, {
			title: "请选择日期",
			date: dDate
		});*/
		var timeL = document.getElementById("endTime").value;
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
		//调用手机端API,获取日历插件
		plus.qytxplugin.selectDateTime(defaultAry,function(da){
			bTime = da.date;
			var endTime = document.getElementById("endTime");
			var dateStr = bTime.split(" ")[0];
			//赋值
			endTime.innerHTML = dateStr;
		});
	})

	//初始化
	initTime(clicksearch);

});

/**
 * 格式化日期,格式为yyyy-MM-dd
 */
function formatDate(srcDate) {
	var result = "";
	if (null != srcDate) {
		result += srcDate.getFullYear() + "-";

		if (srcDate.getMonth() < 9) {
			result += "0" + (srcDate.getMonth() + 1);
		} else {
			result += (srcDate.getMonth() + 1);
		}
		result += "-";
		if (srcDate.getDate() < 10) {
			result += "0" + srcDate.getDate();
		} else {
			result += srcDate.getDate();
		}
	}
	return result;
}

mui.init({
	pullRefresh: {
		container: '#pullrefresh',
//		down: {
//			contentdown: "下拉可以刷新",
//			callback: pulldownRefresh
//		},
		up: {
			contentrefresh: '正在加载...',
			contentnomore: '没有更多数据了',
		 
			callback: pullupRefresh
		}
	}
});

var count = 0;
//当前页数
var currentPage = 0;
//每页条数
var pageSize = 20;
//是否为最后一页
var isEnd = false;
//var upRefresh = false;

/**
 * 下拉刷新具体业务实现
 */
function pulldownRefresh() {
	console.log("pulldownRefresh");
//	setTimeout(function() {
//		//		mui('#pullrefresh').pullRefresh().pullupLoading();
//		//		mui('#pullrefresh').pullRefresh().endPulldownToRefresh(); //refresh completed
//	}, 1500);
}

/**
 * 上拉加载具体业务实现
 */
function pullupRefresh() {
	setTimeout(function() {
		currentPage++;
		getlist();
	}, 500);
}



/**
 * 点击搜索按钮
 */
var clicksearch = function() {
	$(".listNoData").hide();
	currentPage = 0;
	isEnd = false;
	var table = document.body.querySelector('.mui-table-view');
	table.innerHTML = '';
	mui('#pullrefresh').pullRefresh().refresh(true);
	mui('#pullrefresh').pullRefresh().pullupLoading();
}

/**
 * 删除一个节点
 * @param {Object} _element
 */
var removeElement = function(_element) {
	var _parentElement = _element.parentNode;
	if (_parentElement) {
		_parentElement.removeChild(_element);
	}
}

//初始化搜索时间
var initTime = function(callback) {
	var url = window.windowCommon.basePath + 'worklog/getSystemTime.c';
	//console.log(url);
	var data = {}
	mui.ajax(url, {
		//data: data,
		dataType: 'json',
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: function(response) {
			plus.webview.close("worklogeditlog");
			var date = response.date;
			var lastmonthdate = response.lastmonthdate;
			var startTimeObj = document.getElementById("startTime");
			startTimeObj.innerHTML = lastmonthdate;
			var endTimeObj = document.getElementById("endTime");
			endTimeObj.innerHTML = date;

			if (callback != undefined && callback != null) {
				callback();
				//绑订搜索方法
				document.getElementById("search").addEventListener('tap', function() {
					clicksearch();
				});
			}
		}
	});

}

//查询列表数据
var getlist = function() {
	var start = document.getElementById("startTime").innerHTML;
	var end = document.getElementById("endTime").innerHTML;

	var url = window.windowCommon.basePath + 'worklog/findWorkogPage.c';

	var data = {
		"which": 0, //0表示我发布的； 1表示我收到的
		"userId": window.windowCommon.approveLoginId,
		"start": start,
		"end": end,
		"currentPage": currentPage,
		"pageSize": pageSize
	};

	mui.ajax(url, {
		data: data,
		dataType: 'text',
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: success
	});

}

//加载列表后的回调方法
var success = function(response) {
	console.log(response);
	if (response.indexOf("100||") == 0) {
		//alert("ok");
		//mui.toast("提交成功");
		//关闭当前窗口
		//plus.webview.close("advice");
		response = response.substring("100||".length);
		var json = eval('(' + response + ')');
	 	totalPage = json.totalPage;
		if (json.aaData.length != pageSize) {
			isEnd = true;
		}
		var listcontentObj = document.getElementById("pullrefresh");
		var message = '';
		var table = document.body.querySelector('.mui-table-view');
		var cells = document.body.querySelectorAll('.mui-table-view-cell');
		mui.each(json.aaData, function(i, n) {
			message += "<li class=\"mui-table-view-cell mui-media log-user\">";
			//console.log(window.windowCommon.photoUrl + json.aaData[i].createUserPhoto);
			message += '<img class="mui-media-object mui-pull-left" src="' + window.windowCommon.photoUrl + json.aaData[i].createUserPhoto + '" title="'+json.aaData[i].createUserName+'"  onerror="headRectError(this);"/>';
			message += "<div class=\"mui-media-body\">";
			message += json.aaData[i].createUserName;
			message += "<time class=\"mui-pull-right\">" + json.aaData[i].createTimeStr + "</time>";
			message += "</div>";
			message += "</li>";
			var divObj1 = document.createElement("div");
			divObj1.className = "content";

			var ulObj = document.createElement("ul");
			ulObj.setAttribute("class", "content-list");
			ulObj.setAttribute("logid", json.aaData[i].id);
			ulObj.setAttribute("logUserId", json.aaData[i].createUserId);
			ulObj.addEventListener("tap", function() {
				//打开详情
				mui.openWindow({
					url: 'worklogdetail.html',
					id: 'worklogDetail',
					extras: {
						logid: this.getAttribute("logid"),
						fromPage:'worklogrelease',
						logUserId: this.getAttribute("logUserId")
					}
				});
			});

			var lihtml = "";
			lihtml += "<li class=\"mui-ellipsis\">";
			lihtml += "<span class=\"state\"><i class=\"state-1\"></i> 已完成</span> " + json.aaData[i].successContent;
			lihtml += "</li>";
			lihtml += "<li class=\"mui-ellipsis\">";
			lihtml += "<span class=\"state\"><i class=\"state-2\"></i> 未完成</span> " + json.aaData[i].failContent;
			lihtml += "</li>";
			lihtml += "<li class=\"mui-ellipsis\">";
			lihtml += "<span class=\"state\"><i class=\"state-3\"></i> 需协调</span> " + json.aaData[i].tieContent;
			lihtml += "</li>";
			lihtml += "<li>";
			lihtml += "<span class=\"attach\">附件(" + json.aaData[i].worklogFileSize + ")</span>";
			lihtml += "</li>";
			ulObj.innerHTML = lihtml;

			var divObj = document.createElement("div");
			divObj.className = "operate";
			var divThml = "";
			if (json.aaData[i].newComment == 'Y') {
				divThml += "<a href=\"javascript:void(0);\" logid='"+json.aaData[i].id+"'  logUserId='"+json.aaData[i].createUserId+"' class=\"comment mui-pull-right\">评论(<em class=\"remind\">" + json.aaData[i].worklogCommentSize + "</em>)</a>";
			} else {
				divThml += "<a href=\"javascript:void(0);\" logid='"+json.aaData[i].id+"'  logUserId='"+json.aaData[i].createUserId+"' class=\"comment mui-pull-right\">评论(<em>" + json.aaData[i].worklogCommentSize + "</em>)</a>";
			}
			if (json.aaData[i].newPraise == 'Y') {
				divThml += "<a href=\"javascript:void(0);\" logid='"+json.aaData[i].id+"'  logUserId='"+json.aaData[i].createUserId+"' class=\"good mui-pull-right\">赞(<em class=\"remind\">" + json.aaData[i].worklogPraiseSize + "</em>)</a>";
			} else {
				divThml += "<a href=\"javascript:void(0);\" logid='"+json.aaData[i].id+"'  logUserId='"+json.aaData[i].createUserId+"' class=\"good mui-pull-right\">赞(<em >" + json.aaData[i].worklogPraiseSize + "</em>)</a>";
			}
			divObj.innerHTML = divThml;

			divObj1.appendChild(ulObj);
			divObj1.appendChild(divObj);
			var ul = document.createElement('ul');
			ul.className = 'mui-table-view log';
			ul.innerHTML = message;
			ul.appendChild(divObj1);
			table.appendChild(ul);

			message = '';
		});
		
		$(".operate").on("tap","a",function(){
               //打开详情
				mui.openWindow({
					url: 'worklogdetail.html',
					id: 'worklogDetail',
					extras: {
						logid: this.getAttribute("logid"),
						fromPage:'worklogrelease',
						logUserId : this.getAttribute("logUserId")
					}
				});
        })  

	} else {
		//alert("not ok");
	} 
	mui('#pullrefresh').pullRefresh().endPullupToRefresh(isEnd); //参数为true代表没有更多数据了。
	if (totalPage<=1) {
		if (totalPage == 0) {
			$(".listNoData").show();
		}
		mui('#pullrefresh').pullRefresh().disablePullupToRefresh();
	}
}

/**
 * 详情变动后回调刷新
 * @param {Object} logid 日志ID
 * @param {Object} praiseNum 最新点赞数
 * @param {Object} commentNum 最新评论数
 */
function refrenceList(logid,praiseNum,commentNum){
	$(".operate a[logid='"+logid+"'] em")[0].innerHTML=commentNum;
	$(".operate a[logid='"+logid+"'] em")[0].className="";
	$(".operate a[logid='"+logid+"'] em")[1].innerHTML=praiseNum;
	$(".operate a[logid='"+logid+"'] em")[1].className="";
}
