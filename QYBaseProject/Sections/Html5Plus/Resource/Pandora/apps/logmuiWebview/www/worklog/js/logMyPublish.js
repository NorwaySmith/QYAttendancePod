var totalPage = 999;
mui.init({
	pullRefresh: {
		container: '#pullrefresh',
		up: {
			contentrefresh: '正在加载...',
			contentnomore: '没有更多数据了',
			callback: pullupRefresh
		}
	}
});
//页面加载完毕方法
mui.plusReady(function() {
	setBackUrl("logIndex.html");
	//判断当前是否有网络
	if (!getNetConnection()) {
		$(".mui-content").hide();
		$(".noNet").show();
		return false;
	}

	//点击开始时间按钮
	document.getElementById("startTime").addEventListener('tap', function() {
		var timeL = document.getElementById("startTime").value;
		var dDate = undefined;
		if (!timeL) {
			dDate = new Date();
		} else {
			dDate = new Date(timeL);
		}
		var bTime = dDate.getFullYear() + "-" + ((dDate.getMonth() + 1) < 10 ? ("0" + (dDate.getMonth() + 1)) : (dDate.getMonth() + 1)) + "-" + (dDate.getDate() < 10 ? ("0" + dDate.getDate()) : dDate.getDate());
		var defaultAry = [bTime, "yyyy-MM-dd"];
		//调用手机端API,获取日历插件
		plus.qytxplugin.selectDateTime(defaultAry, function(da) {
			bTime = da.date;
			var startTime = document.getElementById("startTime");
			var dateStr = bTime.split(" ")[0];
			//赋值
			startTime.innerHTML = dateStr;
		});

	})

	//点击结束时间按钮
	document.getElementById("endTime").addEventListener('tap', function() {
		var timeL = document.getElementById("endTime").value;
		var dDate = undefined;
		if (!timeL) {
			dDate = new Date();
		} else {
			dDate = new Date(timeL);
		}
		var bTime = dDate.getFullYear() + "-" + ((dDate.getMonth() + 1) < 10 ? ("0" + (dDate.getMonth() + 1)) : (dDate.getMonth() + 1)) + "-" + (dDate.getDate() < 10 ? ("0" + dDate.getDate()) : dDate.getDate());
		var defaultAry = [bTime, "yyyy-MM-dd"];
		//调用手机端API,获取日历插件
		plus.qytxplugin.selectDateTime(defaultAry, function(da) {
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

var count = 0;
//当前页数
var currentPage = 0;
//每页条数
var pageSize = 20;
//是否为最后一页
var isEnd = false;
//var upRefresh = false;

/**
 * 上拉加载具体业务实现
 */
function pullupRefresh() {
	//使用缓存数据
	var cacheData = getCacheData("log_myPublish_data");
	if (cacheData) {
		var cacheAry = JSON.parse(cacheData);
		if (cacheAry[0]) {
			if(cacheAry[2]){
				document.getElementById("startTime").innerHTML=cacheAry[2];
			}
			if(cacheAry[3]){
				document.getElementById("endTime").innerHTML=cacheAry[3];
			}
			for (var i = 4; i < cacheAry.length; i++) {
				showDataWithHTML(cacheAry[i]);
			}
			cacheAry[0] = false;
			saveCacheData("log_myPublish_data", JSON.stringify(cacheAry));
			if (plus.os.name == "iOS") {
				document.scrollY = cacheAry[1];
			} else {
				document.body.scrollTop = cacheAry[1];
			}
			return false;
		}
	}
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
					clearCacheData("log_myPublish_data");
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
		success: function(data) {
			if (currentPage == 0) {
				clearCacheData("log_myPublish_data");
			}
			showDataWithHTML(data);
			//保存缓存数据
			var cacheData = getCacheData("log_myPublish_data");
			if (cacheData) {
				cacheAry = JSON.parse(cacheData);
				var len = cacheAry.length;
				cacheAry[len] = data;
			} else {
				var cacheAry = new Array();
				cacheAry[0] = false;
				cacheAry[2]=start;
				cacheAry[3]=end;
				cacheAry[4] = data;
			}
			saveCacheData("log_myPublish_data", JSON.stringify(cacheAry));
		},
		error: function(xhr, type, errorThrown) {
			//异常处理；
			mui.toast("请求数据异常！");
		}
	});

}

//加载列表后数据在页面中显示
var showDataWithHTML = function(response) {
		if (response.indexOf("100||") == 0) {
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
				message += '<img class="mui-media-object mui-pull-left" src="' + window.windowCommon.photoUrl + json.aaData[i].createUserPhoto + '" title="' + json.aaData[i].createUserName + '"  onerror="headRectError(this);"/>';
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
					//设置页面参数
					var mapParam = new Map();
					mapParam.put("logid", this.getAttribute("logid"));
					mapParam.put("logUserId", this.getAttribute("logUserId"));
					setPageParam("log_detail", mapParam);
					window.location.href = "logDetail.html";
					//设置使用缓存
					var cacheData = getCacheData("log_myPublish_data");
					if (cacheData) {
						var cacheAry = JSON.parse(cacheData);
						cacheAry[0] = true;
						if (plus.os.name == "iOS") {
							cacheAry[1] = document.scrollY + '';
						} else {
							cacheAry[1] = document.body.scrollTop + '';
						}
						saveCacheData("log_myPublish_data", JSON.stringify(cacheAry));
					}
					return false;
				});

				var lihtml = "";
				lihtml += "<li class=\"mui-ellipsis\">";
				lihtml += "<span class=\"state\"><i class=\"state-1\"></i> 已完成工作</span> " + json.aaData[i].successContent;
				lihtml += "</li>";
				lihtml += "<li class=\"mui-ellipsis\">";
				lihtml += "<span class=\"state\"><i class=\"state-2\"></i> 未完成工作</span> " + json.aaData[i].failContent;
				lihtml += "</li>";
				lihtml += "<li class=\"mui-ellipsis\">";
				lihtml += "<span class=\"state\"><i class=\"state-3\"></i> 需协调工作</span> " + json.aaData[i].tieContent;
				lihtml += "</li>";
				lihtml += "<li>";
				lihtml += "<span class=\"attach\">附件(" + json.aaData[i].worklogFileSize + ")</span>";
				lihtml += "</li>";
				ulObj.innerHTML = lihtml;

				var divObj = document.createElement("div");
				divObj.className = "operate";
				var divThml = "";
				if (json.aaData[i].newComment == 'Y') {
					divThml += "<a href=\"javascript:void(0);\" logid='" + json.aaData[i].id + "'  logUserId='" + json.aaData[i].createUserId + "' class=\"comment mui-pull-right\">评论(<em class=\"remind\">" + json.aaData[i].worklogCommentSize + "</em>)</a>";
				} else {
					divThml += "<a href=\"javascript:void(0);\" logid='" + json.aaData[i].id + "'  logUserId='" + json.aaData[i].createUserId + "' class=\"comment mui-pull-right\">评论(<em>" + json.aaData[i].worklogCommentSize + "</em>)</a>";
				}
				if (json.aaData[i].newPraise == 'Y') {
					divThml += "<a href=\"javascript:void(0);\" logid='" + json.aaData[i].id + "'  logUserId='" + json.aaData[i].createUserId + "' class=\"good mui-pull-right\">赞(<em class=\"remind\">" + json.aaData[i].worklogPraiseSize + "</em>)</a>";
				} else {
					divThml += "<a href=\"javascript:void(0);\" logid='" + json.aaData[i].id + "'  logUserId='" + json.aaData[i].createUserId + "' class=\"good mui-pull-right\">赞(<em >" + json.aaData[i].worklogPraiseSize + "</em>)</a>";
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

			$(".operate").on("tap", "a", function() {
				//设置页面参数
				var mapParam = new Map();
				mapParam.put("logid", this.getAttribute("logid"));
				mapParam.put("logUserId", this.getAttribute("logUserId"));
				setPageParam("log_detail", mapParam);
				window.location.href = "logDetail.html";
				//设置使用缓存
				var cacheData = getCacheData("log_myPublish_data");
				if (cacheData) {
					var cacheAry = JSON.parse(cacheData);
					cacheAry[0] = true;
					if (plus.os.name == "iOS") {
						cacheAry[1] = document.scrollY + '';
					} else {
						cacheAry[1] = document.body.scrollTop + '';
					}
					saveCacheData("log_myPublish_data", JSON.stringify(cacheAry));
				}
				return false;
			})

		} else {
			//alert("not ok");
		}
		mui('#pullrefresh').pullRefresh().endPullupToRefresh(isEnd); //参数为true代表没有更多数据了。
		if (totalPage <= 1) {
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
function refrenceList(logid, praiseNum, commentNum) {
	$(".operate a[logid='" + logid + "'] em")[0].innerHTML = commentNum;
	$(".operate a[logid='" + logid + "'] em")[0].className = "";
	$(".operate a[logid='" + logid + "'] em")[1].innerHTML = praiseNum;
	$(".operate a[logid='" + logid + "'] em")[1].className = "";
}