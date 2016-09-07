mui.init({
	pullRefresh: {
		container: '#pullrefresh',
//		down: {
//			callback: pulldownRefresh
//		},
		up: {//上拉刷新
			contentrefresh: '正在加载...',
		 	contentnomore: '没有更多数据了', //可选，请求完毕若没有更多数据时显示的提醒内容；
			callback: pullupRefresh
		}
	}
});

var count = 0;
//当前页数
var currentPage = 0;
//每页多少条
var pageSize = 20;
//本页有多少条数据
var totalPage = 999;
//是否最后一页
var isEnd = false;
//var upRefresh = false;

/**
 * 下拉刷新具体业务实现
 */
function pulldownRefresh() {
	setTimeout(function() {
		
	}, 1500);
}

/**
 * 上拉加载具体业务实现
 */
function pullupRefresh() {
	setTimeout(function() {		
		currentPage++;
		getlist();
	}, 1500);
}

//页面加载完毕方法
mui.plusReady(function() {
	//判断当前是否有网络
	if(!getNetConnection()){
		$(".mui-content").hide();
		$(".noNet").show();
		return false;
	}
	//绑订搜索方法
	document.getElementById("search").addEventListener('tap', function() {
		$(".listNoData").hide();
		currentPage = 0;
		isEnd = false;
		totalPage=999;

        mui('#pullrefresh').pullRefresh().disablePullupToRefresh();
		var table = document.body.querySelector('.mui-table-view');
		table.innerHTML = '';
        mui('#pullrefresh').pullRefresh().pullupLoading();
        mui('#pullrefresh').pullRefresh().enablePullupToRefresh();
	});
    setTimeout(function() {
		mui('#pullrefresh').pullRefresh().pullupLoading();
	}, 100);
    
});

var removeElement = function(_element) {
	var _parentElement = _element.parentNode;
	if (_parentElement) {
		_parentElement.removeChild(_element);
	}
}

//查询列表数据
var getlist = function() {
	var username = document.getElementById("username").value; 
	var url = window.windowCommon.basePath + 'worklog/findWorkogPage.c';

	var data = {
		"which": 1, //0表示我发布的； 1表示我收到的
		"userId": window.windowCommon.approveLoginId,
		"keyword": username,
		"currentPage": currentPage,
		"pageSize": pageSize
	};

	mui.ajax(url, {
		data: data,
		type: 'post', //HTTP请求类型
		timeout: 10000, //超时时间设置为10秒；
		crossDomain: true,
		success: success
	});

}

//加载列表后的回调方法
var success = function(response) {
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
		var table = document.body.querySelector('#dataUl');
		var cells = document.body.querySelectorAll('.mui-table-view-cell');
	 
		mui.each(json.aaData, function(i, n) {
			if(json.aaData[i].newDay == 'Y'){
				if(i==0){
					message += '<li class="mui-table-view-divider date">'+json.aaData[i].newDayStr+'</li>';
				}else{
					message += '<li class="mui-table-view-divider date" style="margin-top:-10px;">'+json.aaData[i].newDayStr+'</li>';
				}
			}
 
			message += "<li class=\"mui-table-view-cell mui-media log-user\">";
			message += '<img class="mui-media-object mui-pull-left" src="'+window.windowCommon.photoUrl+json.aaData[i].createUserPhoto+'" title="'+json.aaData[i].createUserName+'"  onerror="headRectError(this);"/>';
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
						fromPage:'worklogreceive',
						logUserId : this.getAttribute("logUserId")
					}
				});
			});
			var lihtml = "";
			lihtml += "<li class=\"mui-ellipsis\">";
			lihtml += "<span class=\"state\"><i class=\"state-1\"></i>已完成</span> " + json.aaData[i].successContent;
			lihtml += "</li>";
			lihtml += "<li class=\"mui-ellipsis\">";
			lihtml += "<span class=\"state\"><i class=\"state-2\"></i>未完成</span> " + json.aaData[i].failContent;
			lihtml += "</li>";
			lihtml += "<li class=\"mui-ellipsis\">";
			lihtml += "<span class=\"state\"><i class=\"state-3\"></i>需协调</span> " + json.aaData[i].tieContent;
			lihtml += "</li>";
			lihtml += "<li>";
			lihtml += "<span class=\"attach\">附件(" + json.aaData[i].worklogFileSize + ")</span>";
			lihtml += "</li>";
			ulObj.innerHTML = lihtml;
			var divObj = document.createElement("div");
			divObj.className = "operate";
			var divThml = "";
			if (json.aaData[i].newComment == 'Y') {
				divThml += "<a href=\"javascript:void(0)\" logid='"+json.aaData[i].id+"'  logUserId='"+json.aaData[i].createUserId+"' class=\"comment mui-pull-right\">评论(<em class=\"remind\">" + json.aaData[i].worklogCommentSize + "</em>)</a>";
			} else {
				divThml += "<a href=\"javascript:void(0)\" logid='"+json.aaData[i].id+"'  logUserId='"+json.aaData[i].createUserId+"' class=\"comment mui-pull-right\">评论(<em>" + json.aaData[i].worklogCommentSize + "</em>)</a>";
			}
			if (json.aaData[i].newPraise == 'Y') {
				divThml += "<a href=\"javascript:void(0)\" logid='"+json.aaData[i].id+"'  logUserId='"+json.aaData[i].createUserId+"' class=\"good mui-pull-right\">赞(<em class=\"remind\">" + json.aaData[i].worklogPraiseSize + "</em>)</a>";
			} else {
				divThml += "<a href=\"javascript:void(0)\" logid='"+json.aaData[i].id+"'  logUserId='"+json.aaData[i].createUserId+"' class=\"good mui-pull-right\">赞(<em >" + json.aaData[i].worklogPraiseSize + "</em>)</a>";
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
						fromPage:'worklogreceive',
						logUserId : this.getAttribute("logUserId")
					}
				});
        })   
 
	} else {
		//alert("not ok");
	}
	mui('#pullrefresh').pullRefresh().endPullupToRefresh((isEnd)); //参数为true代表没有更多数据了。
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