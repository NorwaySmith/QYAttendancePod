/**
 * 单个下属的联系记录页面js
 */
var currentPage = 0;
var totalPage = 999;
var searchFollower = "0";//是否搜索全部下属
var yearmo = "";//年月（2015-09）
var tian = "";//天(30)
var followerId = 0;//下属的id

var viewId;
var callbackFun;//来源页面回调函数
var isNeedRefresh=0;//是否需要刷新来源页面

/**
 * 页面加载完毕初始化数据 
 */
function plusReady() {
	
	//绑定页面上拉加载数据
	mui.init({
		pullRefresh: {
			container: "#pullrefresh", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
			up: {
				contentrefresh: "正在加载...", //可选，正在加载状态时，上拉加载控件上显示的标题内容
				contentnomore: '没有更多数据了', //可选，请求完毕若没有更多数据时显示的提醒内容；
				callback: pullupRefresh //必选，刷新函数，根据具体业务来编写，比如通过ajax从服务器获取新数据；
			}
		},
		beforeback: function(){
			if(viewId && callbackFun && isNeedRefresh){
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun+"();");
			}
		}
	});
	
   	var self = plus.webview.currentWebview();
	if(self.userName){
		$(".mui-title").html(self.userName+"的拜访记录");
	}
	if(self.followerId){
		followerId = self.followerId;
	}
	viewId = self.viewId;
	callbackFun = self.callbackFun;

	//绑定进入详情事件
	$("#List").on("tap","ul.content-list",function(){
		mui.openWindow({
			url: 'visitdetail.html',
			id: 'visitdetail',
			extras: {
				visitdetailId: $(this).parents("ul.log").attr("val"),
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshData"
			}
		});
	});
	
	//绑定展开评论区域div事件
	$("#List").on("tap",".comment",function(){
		if($(this).parent().siblings(".shi-comment")){
			$(this).parent().siblings(".shi-comment").toggle();
		}
	});
	
	//绑定点赞事件
	$("#List").on("tap",".good",function(){
		delPraise(this);
	});
	
	//绑定取消点赞事件
	$("#List").on("tap",".nogood",function(){
		praise(this);
	});
}

/**
 * 刷新子页面数据
 */
function refreshChildData() {
	currentPage = 0;
	totalPage = 999;
	$("#List").html('');
	_enablePullUp();
	mui('#pullrefresh').pullRefresh().pullupLoading();
}

//刷新数据并更新父页面更新状态
function refreshData(){
	isNeedRefresh=1;
	refreshChildData();
}

/**
 * 上拉刷新
 */
function pullupRefresh() {
	if (currentPage > totalPage) {
		mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
	} else {
		//业务逻辑代码，比如通过ajax从服务器获取新数据；
		var param = {
			"_clientType": "wap",
			"pageNo": currentPage,
			"pageSize": 5,
			"visitDate":"",
			"searchFollower": searchFollower,
			"userId": window.windowCommon.approveLoginId
		}

		if(followerId){
 			param.followerId=followerId;
 		}
		visitApi.visitList(param, function(data) {
			currentPage++;
			var jsonData = JSON.parse(data);
			var jsonDataList = jsonData.list;
			totalPage = jsonData.totalPage;
			if (jsonDataList && jsonDataList.length > 0) {
				for (var i = 0; i <= jsonDataList.length - 1; i++) {
					var visitdetailId = jsonDataList[i].visitdetailId;
					var html = '<ul class="mui-table-view log" val="'+visitdetailId+'">';
						
					html += '<li class="mui-table-view-cell shi-time unit-ps">';
					html += '<em class="time-ico"></em>';
					html += '<span>' + jsonDataList[i].visitTime + '</span>';
					html += '</li>';
					html += '<li class="mui-table-view-cell mui-media log-user">';
					html += '<img class="mui-pull-left shi-ppic" src="'+window.windowCommon.photoUrl+jsonDataList[i].createUserPhoto+'" title="'+jsonDataList[i].createUserName+'" onerror="headError(this);">';
					html += '<div class="mui-media-body">';
					html += '' + jsonDataList[i].createUserName + '';
					html += '</div>';
					html += '</li>';
					html += '<div class="content">';
					html += '<ul class="content-list">';
					html += '<li class="mui-ellipsis-2 quan">';
					if(jsonDataList[i].visitType==1){
						html += '<span class="shi-tit">现场拜访：</span><p class="shi-txt">' + jsonDataList[i].visitPoistion + '</p>';
					}else if(jsonDataList[i].visitType==2){
						html += '<span class="shi-tit">沟通对象：</span><p class="shi-txt"><span class="public-span1 w40 cttext">' + jsonDataList[i].communicationUserName +'</span><span class="centre-text">（'+jsonDataList[i].communicationModeName+'沟通）</span>' + '</p>';
					}
					
					html += '<li class="mui-ellipsis-2">';
					if (jsonDataList[i].visitType == 1) {
						html += '<span class="shi-tit">拜访单位：</span><p class="shi-txt">' + jsonDataList[i].customerName + '</p>';
					} else if (jsonDataList[i].visitType == 2) {
						html += '<span class="shi-tit">联系单位：</span><p class="shi-txt">' + jsonDataList[i].customerName + '</p>';
					}
					html += '</li>';
					
					html += '</li>';
					html += '<li class="mui-ellipsis-2">';
					html += '<span class="shi-tit">沟通内容：</span><p class="shi-txt">' + jsonDataList[i].visitContent + '</p> ';
					html += '</li>';
					html += '<li class="mui-ellipsis-2">';
					html += '<span class="shi-tit">双方异议：</span><p class="shi-txt">' + jsonDataList[i].visitDiffence + '</p> ';
					html += '</li>';
					html += '<li class="mui-ellipsis-2">';
					html += '<span class="shi-tit shi-txt-active">下次沟通：</span><p class="shi-txt shi-txt-active">' + jsonDataList[i].nextVisitTime + '</p> ';
					html += '</li>';
					html += '<li class="mui-ellipsis-2">';
					html += '<span class="shi-tit shi-txt-active">跟进要点：</span><p class="shi-txt shi-txt-active">' + jsonDataList[i].nextVisitMaincontent + '</p> ';
					html += '</li>';
					html += '</ul>';
					
					//绑定按钮域
					html += '<div class="operate" id="cz">';
					html += '<a class="sale-new-del unit-ps" onclick="del(' + visitdetailId + ')"><em class="sale-del"></em>删除</a>';
					var visitRecord = jsonDataList[i].visitRecordCommentList;
					if (visitRecord.length > 0) {
						html += '<a href="javascript:void(0);" class="comment mui-pull-right"><em>' + visitRecord.length + '</em></a>';
					} else {
						html += '<a href="javascript:void(0);" class="comment mui-pull-right"><em></em></a>';
					}
					if (jsonDataList[i].praiseCount > 0) {
						if (jsonDataList[i].isPraise == 1) {
							html += '<a href="javascript:void(0);" class="good mui-pull-right" visitdetailId="' + visitdetailId + '" ><em>' + jsonDataList[i].praiseCount + '</em></a>';
						} else {
							html += '<a href="javascript:void(0);" class="nogood mui-pull-right" visitdetailId="' + visitdetailId + '"><em>' + jsonDataList[i].praiseCount + '</em></a>';
						}
					} else {
						if (jsonDataList[i].isPraise == 1) {
							html += '<a href="javascript:void(0);" class="good mui-pull-right" visitdetailId="' + visitdetailId + '" ><em class="remind" ></em></a>';
						} else {
							html += '<a href="javascript:void(0);" class="nogood mui-pull-right" visitdetailId="' + visitdetailId + '" ><em class="remind" ></em></a>';
						}
					}
					html += '</div>';
					
					
					var visitRecordCommentList = jsonDataList[i].visitRecordCommentList;
					if (visitRecordCommentList.length > 0) {
						for (var k = 0; k <= visitRecordCommentList.length - 1; k++) {
							html += '<ul class="shi-comment" id="pinglun" style="display:none">';
							html += '<li>';
							html += '<div class="shi-visit-reply">';
							html += '<a class="shi-nm">' + visitRecordCommentList[k].userName + '</a><a class="shi-data">' + visitRecordCommentList[k].createTime + '</a>';
							html += '</div>';
							html += '<a class="shi-ly">' + visitRecordCommentList[k].content + '</a>';
							html += '</li>';
							html += '</ul>';
						}
					}
					html += '</div>';
					html += '</ul>';
					$("#List").append(html);
				}
				if (currentPage >= totalPage) {
					mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
				} else {
					mui('#pullrefresh').pullRefresh().endPullupToRefresh(false); //参数为true代表没有更多数据了。
				}
			} else {
				mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
			}

			if (totalPage <= 1) {
				if (totalPage == 0) {
					$(".listNoData").show();
				}
				mui('#pullrefresh').pullRefresh().disablePullupToRefresh();
			}
		})


	}
}


/**
 * 页面加载完毕初始化数据
 */
if (window.plus) {
	plusReady();
} else {
	document.addEventListener('plusready', plusReady, false);
}


//进入页面加载第一页
if (mui.os.plus) {
	mui.plusReady(function() {
		setTimeout(function() {
			mui('#pullrefresh').pullRefresh().pullupLoading();
		}, 100);
	});
} else {
	mui.ready(function() {
		mui('#pullrefresh').pullRefresh().pullupLoading();
	});
}