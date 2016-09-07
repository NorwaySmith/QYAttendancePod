/**
 * 销售龙虎榜页面js
 */
var currentPage = 0;
var totalPage = 999;
var sequence = 0;//序号123456...
var ranking = 0;//排名
var beforMoney = 0;//上个人销售金额
var year;
var mouth;
/**
 * 页面加载完毕初始化数据
 */
function plusReady() {
	//绑定页面上拉加载数据
	mui.init({
		swipeBack: true, //启用右滑关闭功能
		pullRefresh: {
			container: "#pullrefresh", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
			up: {
				contentrefresh: "正在加载...", //可选，正在加载状态时，上拉加载控件上显示的标题内容
				contentnomore: '没有更多数据了', //可选，请求完毕若没有更多数据时显示的提醒内容；
				callback: pullupRefresh //必选，刷新函数，根据具体业务来编写，比如通过ajax从服务器获取新数据；
			}
		}
	});
	mui('.mui-scroll-wrapper1').scroll();
	
	visitApi.getTime({"format":"yyyy-MM"},function(data){
		//console.log(data)
		year = data.split("-")[0];
		mouth = data.split("-")[1];
		$("#fullYear").find("font").html(year+'年');
		$("#fullMouth").find("font").html(mouth+'月');
		$("#expectedYearUL").append('<li class="mui-table-view-cell month-active" yearValue="'+year+'">'+year+'年</li>');
		for (var i=1;i<5;i++) {
			thisYear = year -i;
			$("#expectedYearUL").append('<li class="mui-table-view-cell" yearValue="'+thisYear+'">'+thisYear+'年</li>');
		}
		$("#expectedMouthUL li[mouthValue='"+mouth+"']").addClass("month-active");
		
	})
	
	
	//绑定年点击事件
	$("#fullYear").click(function() {
		mui("#popover3").popover("toggle");
	});

	//绑定月点击事件
	$("#fullMouth").click(function() {
		mui("#popover1").popover("toggle");
	});
	
	//绑定选择年列表事件
	$("#expectedYearUL").on("click", "li", function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		mui("#popover3").popover("toggle");
		$("#fullYear").find("font").html($(this).html());
		year = $(this).attr('yearValue');
		refreshChildData(); //刷新子页面数据
	});

	//绑定选择月份列表事件
	$("#expectedMouthUL").on("click", "li", function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		mui('#popover1').popover('toggle');
		$("#fullMouth").find("font").html($(this).html());
		mouth = $(this).attr('mouthValue');
		refreshChildData(); //刷新子页面数据
	});
	
	
}



/**
 * 刷新子页面数据
 */
function refreshChildData() {
	console.log('刷新')
	currentPage = 0;
	totalPage = 999;
	sequence = 0;
	ranking = 0;
	beforMoney = 0;
	$("#list").html('');
	mui('#pullrefresh').pullRefresh().refresh(true);
	mui('#pullrefresh').pullRefresh().pullupLoading();
}

/**
 * 上拉刷新
 */
function pullupRefresh() {
	//console.log(year+'/'+mouth)
	if (currentPage > totalPage) {
		mui('#pullrefresh').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
	} else {
		//业务逻辑代码，比如通过ajax从服务器获取新数据；
		var param = {
			"_clientType": "wap",
			"pageNo": currentPage,
			"pageSize": 10,
			"year": year,
			"mouth": mouth,
			"userId": window.windowCommon.approveLoginId
		}

		orderAPI.saleBillboard(param, function(jsonData) {
			//console.log(JSON.stringify(jsonData));
			currentPage++;
			var jsonDataList = eval(jsonData.list);
			totalPage = jsonData.totalPage;
			if (jsonDataList && jsonDataList.length > 0) {
				for (var i = 0; i < jsonDataList.length ; i++) {
					sequence ++;//序号每次加1
					if(currentPage==1 && i==0){//第一条数据，不能用beforMoney==jsonDataList[i].money比较，因为beforMoney默认为0
						ranking++;
					}else{
						if(beforMoney==jsonDataList[i].money){//当此金额等于上个金额时
							console.log('我和上个排名一样哦...')
						}else{
							ranking = sequence;//取当前序号作为排名
						}
					}
					beforMoney = jsonDataList[i].money;//赋值
					var html='';
						html+='<li class="mui-table-view-cell">';
							if(ranking==1){
								html+='<span class="bay no1">第'+ranking+'名</span>';
							}else if(ranking==2){
								html+='<span class="bay no2">第'+ranking+'名</span>';
							}else if(ranking==3){
								html+='<span class="bay no3">第'+ranking+'名</span>';
							}else{
								html+='<span class="bay">第'+ranking+'名</span>';
							}
							
							html += '<img class="ml12" src="' + window.windowCommon.photoUrl + jsonDataList[i].photo + '" title="' + jsonDataList[i].userName + '" onerror="headError(this);" />';
							html+='<span class="per-name">'+jsonDataList[i].userName+'</span>';
							if(ranking<=3){
								html+='<span class="money">¥'+commNum(jsonDataList[i].money)+'</span>';
								html+='<span class="state">成交：</span>';
							}else{
								html+='<span class="money-more">¥'+commNum(jsonDataList[i].money)+'</span>';
								html+='<span class="state-more">成交：</span>';
							}
							
						html+='</li>';
					$("#list").append(html);
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
 * 把数字转成千分位
 */
function commNum(num) {
	num = num.toFixed(2) +"";
	var re=/(-?\d+)(\d{3})/
	while(re.test(num)){
		num=num.replace(re,"$1,$2");
	}
	return num;
}


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
