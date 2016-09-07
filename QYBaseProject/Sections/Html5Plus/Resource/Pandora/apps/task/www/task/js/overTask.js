// 承办1/发起2/转交3
var type = 1;

//当前页数
var currentPage = 1;
//每页条数
var pageSize = 2;


mui.init({
	beforeback: function() {
		if(plus.webview.getWebviewById(plus.webview.currentWebview().indexId) != undefined) {
			// 新建日志后进入我发布的列表， 这种情况下返回刷新首页的数据
			// 若从首页直接进入我发布的列表， 这种情况下返回不刷新首页的数据
			plus.webview.getWebviewById(plus.webview.currentWebview().indexId).evalJS(plus.webview.currentWebview().callbackFun);
		}
		
	},
	pullRefresh: {
		container: '#pullrefresh',
		/*down: {
			contentdown: "下拉可以刷新",
			callback: pulldownRefresh
		},*/
		up: {
			contentrefresh: '正在加载...',
			contentnomore: '没有更多数据了',
			callback: pullupRefresh
		}
	}
});

//页面加载完毕方法
var pageReady = function() {
	// 得到父页面的参数信息
	/*var self = plus.webview.currentWebview();
	type = self.type;*/
	type = plus.storage.getItem("type");
	
	var Wh = $(window).height();
	var Ch = Wh-44;
	$(".mui-scroll-wrapper").css({height:Ch+"px"});
	
	//判断当前是否有网络
	/*if(!getNetConnection()){
		$(".mui-content").hide();
		$(".noNet").show();
		return false;
	}*/

};

/**
 * 下拉刷新具体业务实现
 */
function pulldownRefresh() {
	console.log("pulldownRefresh");
	setTimeout(function() {
		mui('#pullrefresh').pullRefresh().endPulldownToRefresh(); //refresh completed
	}, 1500);
}

/**
 * 上拉加载具体业务实现
 */
function pullupRefresh() {
	//console.log('上拉操作');
	setTimeout(function() {
		getlist();
	}, 1500);
}


/**
 * 查询列表数据
 */
var getlist = function() {
	//使用缓存数据
	var cacheData = plus.storage.getItem("overTask_cache_data");
	if(cacheData){
		var cacheAry=JSON.parse(cacheData);
		if(cacheAry[0]){
			for(var i=3; i<cacheAry.length; i++){
				showOverTaskData(cacheAry[i]);
			}
			cacheAry[0]=false;
			currentPage = cacheAry[2];
			plus.storage.setItem("overTask_cache_data", JSON.stringify(cacheAry));
			/*if(plus.os.name=="iOS"){
				document.scrollY=cacheAry[1];
			}else{
				document.body.scrollTop=cacheAry[1];
			}*/
			var scrollDiv = document.querySelector('.mui-scroll');
			$(scrollDiv).attr("style", cacheAry[1]);
			return false;
		}
	}
	console.log('查询数据库。');
	var param = {
		"_clientType": "wap",
		"which": type,
		"userId": window.windowCommon.approveLoginId,
		"pageNum": currentPage++,
		"pageSize": pageSize
	};
	
	_taskApi._getOverTaskList(param, function(data) {
		if((currentPage-1)==1){
			plus.storage.removeItem("overTask_cache_data");
		}
		showOverTaskData(data);
		// 保存缓存数据
		var cacheData = plus.storage.getItem("overTask_cache_data");
		var cacheAry = undefined;
		if(cacheData){
			cacheAry = JSON.parse(cacheData);
			var len = cacheAry.length;
			cacheAry[len]=data;
		}else{
			cacheAry=new Array();
			cacheAry[0]=false;
			cacheAry[3]=data;
		}
		
		plus.storage.setItem("overTask_cache_data", JSON.stringify(cacheAry));
	});
}

/**
 * 显示已结束任务列表的数据
 * @param {Object} response
 */
var showOverTaskData = function(response){
	var totalPage = response.totalPage;
	var pageNum = response.currentPage;
	console.log('pageNum='+pageNum);
	
	mui.each(response.list, function(i, n) {
		var html = '<div class="list_li pr">';
		html += '<span class="list_title text_hide">'+n.taskContent+'</span>';
		html += '<span class="list_one pr"><em class="time_ico"></em>完成日期：'+n.completeTime+'</span>';
		if(type == 1){
			html += '<span class="list_one pr"><em class="renwu_ico"></em>任务来源：'+n.createUserName+'</span>';
		}else if(type == 2) {
			html += '<span class="list_one pr"><em class="jieshou_ico"></em>承办人员：'+n.underTaskerUserName+'</span>';
		}else if(type == 3) {
			html += '<span class="list_one pr"><em class="renwu_ico"></em>任务来源：'+n.createUserName+'</span>';
			html += '<span class="list_one pr"><em class="jieshou_ico"></em>接收人员：'+n.transferToUserName+'</span>';
		}
		
		
		if(n.taskStatus == 2){
			html += '<em class="complete_flag"></em>';
		}else if(n.taskStatus == 3) {
			html += '<em class="un_complete_flag"></em>';
		}else if(n.taskStatus == 4) {
			html += '<em class="cancel_flag"></em>';
		}else if(n.taskStatus == 5) {
			html += '<em class="stop_flag"></em>';
		}
		
		html += ' </div>';
		if(n.decompose == 1){
			html += '<div class="div_one pr t_bor">';
			html += '<p class="finish">已完成：'+n.scheduleComplete+'/'+n.scheduleCount+'</p>';
			html += '</div>';
		}

		var subli = document.createElement("li");
		subli.setAttribute("taskId", n.taskId);
		subli.innerHTML = html;
		subli.addEventListener('tap', function(){
			var taskId = n.taskId;
			toTaskDetailPage(taskId);
		});
		mui("#pullrefresh ul")[0].appendChild(subli);
	});
	
	mui('#pullrefresh').pullRefresh().endPullupToRefresh(pageNum >= totalPage); //参数为true代表没有更多数据了。
}

/**
 * 跳转到任务详情页面
 * @param {Object} taskId
 */
var toTaskDetailPage = function(taskId){
	setCacheStarting();
	plus.storage.setItem("taskId", taskId+'');
	window.location.href="TaskDetail.html";
}

//启用缓存数据
var setCacheStarting = function() {
	//待审批缓存
	var cacheData = plus.storage.getItem("overTask_cache_data");
	var scrollDiv = document.querySelector('.mui-scroll');
	if (cacheData) {
		var cacheAry = JSON.parse(cacheData);
		cacheAry[0] = true;
		cacheAry[1] = $(scrollDiv).attr("style");
		cacheAry[2]	= currentPage;
		plus.storage.setItem("overTask_cache_data", JSON.stringify(cacheAry));
	}
}

if (mui.os.plus) {
	mui.plusReady(function() {
		setTimeout(function() {
			mui('#pullrefresh').pullRefresh().pullupLoading();
		}, 1000);
		pageReady();
	});
} else {
	mui.ready(function() {
		mui('#pullrefresh').pullRefresh().pullupLoading();
		pageReady();
	});
}