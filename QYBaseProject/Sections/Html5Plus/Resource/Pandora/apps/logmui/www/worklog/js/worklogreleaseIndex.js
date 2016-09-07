
//查询列表数据
var getlist = function() {
	console.info('首页上查询最新的一条日志数据');

	var url = window.windowCommon.basePath + 'worklog/findWorkogPage.c';
	var data = {
		"which": 0, //0表示我发布的； 1表示我收到的
		"userId": window.windowCommon.approveLoginId,
		"currentPage": 1,
		"pageSize": 1
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
	//console.log(response);
	if (response.indexOf("100||") == 0) {
		mui("#worklogreleaseMore")[0].style.display = "none";
		mui(".listNoData")[0].style.display = "none";
		
		response = response.substring("100||".length);
		var json = eval('(' + response + ')');
		if(json.aaData.length > 0){
			mui("#worklogreleaseMore")[0].style.display = "block";
			var message = '';
			var table = document.getElementById("worklogreleaseIndex");
			table.innerHTML = '';
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
							fromPage:plus.webview.currentWebview().id,
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
			
			mui(".operate").on("tap","a",function(){
	               //打开详情
					mui.openWindow({
						url: 'worklogdetail.html',
						id: 'worklogDetail',
						extras: {
							logid: this.getAttribute("logid"),
							fromPage:plus.webview.currentWebview().id,
							logUserId : this.getAttribute("logUserId")
						}
					});
	        })  
			
		}else {
			mui(".listNoData")[0].style.display = "block";
		}

		
	} else {
		//alert("not ok");
	} 
}

/**
 * 详情变动后回调刷新
 * @param {Object} logid 日志ID
 * @param {Object} praiseNum 最新点赞数
 * @param {Object} commentNum 最新评论数
 */
function refrenceList(logid,praiseNum,commentNum){
	mui(".operate a[logid='"+logid+"'] em")[0].innerHTML=commentNum;
	mui(".operate a[logid='"+logid+"'] em")[0].className="";
	mui(".operate a[logid='"+logid+"'] em")[1].innerHTML=praiseNum;
	mui(".operate a[logid='"+logid+"'] em")[1].className="";
}