/**
 * 单位下的机会选择页面js
 */
var currentPage = 1;
/**
 * 获得机会列表
 */
function getChance() {
	var self = plus.webview.currentWebview();
	var customerId = self.customerId;
	var pageName = self.pageName;
	//console.log(customerId)
	//业务逻辑代码，比如通过ajax从服务器获取新数据；
	var param = {
		"_clientType": "wap",
		"pageNo": currentPage,
		"pageSize": 999999,
		"keyword": "",
		"customerId": customerId,
		"userId": window.windowCommon.approveLoginId
	};
	_chanceApi._getSelectChanceList(param, function(data) {
		$.each(data.list, function(i, item) {
			var html = '<li class="mui-table-view-cell">';
			html += '<a class="mui-navigate-right">';
			html += '<span cid="'+item.chanceId+'">' + item.chanceName + '</span>';
			html += '</a>';
			html += ' </li>';
			$("#list").append(html);
		});
		
		var lis = mui(".mui-table-view-cell");
		mui.each(lis, function(i, n) {
			
			lis[i].addEventListener("tap", function() {
				var span = $(lis[i]).find(".mui-navigate-right").eq(0).find("span").eq(0);
				var id = span.attr('cid');
				var name = span.html();
				plus.webview.getWebviewById(pageName).evalJS("returnchance(['"+id+"', '"+name+"']);");
			});
		});
		
		
	});
}

if (mui.os.plus) {
	mui.plusReady(function() {
		setTimeout(function() {
			getChance();
		}, 100);
	});
} else {
	mui.ready(function() {
		getChance();
	});
}