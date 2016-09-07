setTimeout(function() {
	var mapParam=getPageParam("log_praiseList");
	var logid=mapParam.get("logid");
	//点赞数量
	var praiseCount = 0;
	
	//查询点赞列表
	mui.ajax(window.windowCommon.basePath+"worklogpraise/findWorklogPraiseList.c?worklogId="+logid,{
		dataType:'json',//服务器返回json格式数据
		type:'get',//HTTP请求类型
		timeout: 10000,//超时时间设置为10秒；  
		crossDomain: true,
		success:function(retdata){
			var message='';
			mui.each(retdata.data,function(i,n){
				//点赞人数统计加1
				praiseCount++;
				
//				if(retdata.data[i].logPraiseUserPhoto==undefined||retdata.data[i].logPraiseUserPhoto=="undefined"){
//			       message=message+"<li class=\"mui-table-view-cell mui-media\">"+
//					   "<a href=\"javascript:void(0);\">"+
//					   "<span class=\"mui-media-object mui-pull-left user-head head-bg-1\">"+retdata.data[i].logPraiseUserName+"</span>"+
//						"<div class=\"mui-media-body\">"+
//						"<span class=\"user-name\">"+retdata.data[i].logPraiseUserName+"<time class=\"mui-pull-right\">"+retdata.data[i].logPraiseCreateTime+"</time>"+
//						"</span>"+	
//					    "</div>"+
//					    "</a>"+
//					    "</li>";
//				}else{
				    var photoUrl=window.windowCommon.photoUrl+retdata.data[i].logPraiseUserPhoto;
					message=message+"<li class=\"mui-table-view-cell mui-media\">"+
					    "<a href=\"javascript:void(0);\">"+
					    "<img class=\"mui-media-object mui-pull-left\" src=\""+photoUrl+"\" width=\"43\" height=\"43\"   title='"+retdata.data[i].logPraiseUserName+"'  onerror='head42RectError(this);'>"+
						"<div class=\"mui-media-body\">"+
						"<span class=\"user-name\">"+retdata.data[i].logPraiseUserName+"<time class=\"mui-pull-right\">"+retdata.data[i].logPraiseCreateTime+"</time>"+
						"</span>"+	
					    "</div>"+
					    "</a>"+
					    "</li>";
//				}
			
	        });
	        
	        document.getElementById("praiseCount").innerHTML = '点赞人员('+praiseCount+')';
			var ulData=document.getElementById("ulData");
	        ulData.innerHTML=message;
			mui('#pullrefresh').pullRefresh().endPullupToRefresh(true);
			
		},
		error:function(xhr,type,errorThrown){
			//异常处理；
			console.log("请求数据异常！"+errorThrown);
		}
	}); 
}, 500);