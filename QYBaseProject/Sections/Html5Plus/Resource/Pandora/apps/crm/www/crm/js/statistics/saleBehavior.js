/**
 * 销售行为页面js
 */
var echarts ;
var searchFollower = 0;//全部下属为1，单个成员为0或者null
var followerId;
var year;
var mouth;
mui.init();
/**
 * 页面加载完毕初始化数据
 */
function plusReady() {
	var self = plus.webview.currentWebview();
	console.log(self.userName)
	if(self.userName){
		$("#toPopover2").find("font").html(self.userName);
		followerId = self.followerId;
		searchFollower = 0;
		$("#toPopover2").find("em").removeClass("unit-filter-r1");
	}else{
		$("#toPopover2").find("font").html(window.windowCommon.approveLoginName);
		$("#myName").html(window.windowCommon.approveLoginName);
		followerId = window.windowCommon.approveLoginId;
		//绑定选择下属点击事件
		$("#toPopover2").click(function() {
			mui("#popover2").popover("toggle");
		});
	}
	
	mui('.mui-scroll-wrapper1').scroll();
	
	visitApi.getTime({"format":"yyyy-MM"},function(data){
		console.log(data)
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
		
		refreshChildData();
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


	//选中当前登录人
	mui("#myName")[0].addEventListener('click', function() {
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		searchFollower = 0; //选中当前登录人
		followerId = window.windowCommon.approveLoginId;
		$("#toPopover2").find("font").html(window.windowCommon.approveLoginName);
		mui('#popover2').popover('toggle');
		refreshChildData(); //刷新子页面数据
	});

	//选中全部下属
	mui("#allFollower")[0].addEventListener('click', function() {
		console.log(2)
		$(this).siblings().removeClass("month-active");
		$(this).addClass("month-active");
		searchFollower = 1; //选择全部下属
		$("#toPopover2").find("font").html('全部下属');
		mui('#popover2').popover('toggle');
		refreshChildData(); //刷新子页面数据
	});

	//单击选择单个成员
	mui("#chooseFollower")[0].addEventListener('click', function() {
		console.log(1)
		mui('#popover2').popover('toggle');
		mui.openWindow({
			url: '../user/selectFollower.html',
			id: 'chooseFollowerForCustomer',
			extras: {
				viewId: plus.webview.currentWebview().id,
				callbackFun: null,
				tourl: "../statistics/saleBehavior.html"
			}
		});
	});
	
	
}


function refreshChildData(){
	plus.nativeUI.showWaiting("等待中...");
	//回到页面顶部
	if(plus.os.name=='iOS'){
		//mui('.mui-content-padded').scroll().scrollTo(0,0,10);//10毫秒滚动到顶
	}else{
		window.scrollTo(0, 0);
	}
	console.log(year)
	console.log(mouth)
	console.log('刷新')
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"followerId": followerId,
		"year": year,
		"mouth": mouth,
		"searchFollower": searchFollower
	}
	visitApi.saleBehavior(param,function(data){
		plus.nativeUI.closeWaiting();
		print('locale','现场拜访','line',data.x,data.y0);
    	print('phone','电话沟通','line',data.x,data.y1);
    	print('email','邮件沟通','line',data.x,data.y2);
    	print('qq','QQ/微信沟通','line',data.x,data.y3);
	},null);
}

/**
 * 画统计图
 * @param {Object} id
 * @param {Object} name
 * @param {Object} showType
 * @param {Object} xData
 * @param {Object} yData
 */
function print(id,name,showType,xData,yData){
	var num = 0;
	for (var i =0;i<yData.length;i++) {
		num += yData[i];
	}
	document.getElementById(id+'Num').innerHTML = num;
	var x = [];
	var y = [];
	x = xData;
	y = yData;
    // 基于准备好的dom，初始化echarts图表
    var myChart = echarts.init(document.getElementById(id)); 
    
    var option = {
    	/* title : {
	        text: name+'：'+num,
	        textStyle:{
			    fontSize: 16,
			    fontWeight: '',
			    color: '#353535'
			} 
	    },*/
        tooltip: {
            show: false/*,//点击显示数据
            trigger: 'axis'//鼠标点击显示竖线数据*/
        },
        legend: {
        	show: false,
            data:[name]
        },
        grid: {
			x: 25,
			x2: 10,
			y: 30,
			y2: 35
		},
		calculable: false,
        xAxis : [
            {
                type : 'category',
                data : x
            }
        ],
        yAxis : [
            {
                type : 'value',
                splitArea : {show : false}
            }
        ],
        series : [
            {
                "name":name,
                "type":showType,
                "itemStyle": {normal: {areaStyle: {type: 'default'}}},
                "data":y
            }
        ]
    };

    // 为echarts对象加载数据 
    myChart.setOption(option); 

}

if (window.plus) {
	plusReady();
} else {
	document.addEventListener('plusready', plusReady, false);
}
