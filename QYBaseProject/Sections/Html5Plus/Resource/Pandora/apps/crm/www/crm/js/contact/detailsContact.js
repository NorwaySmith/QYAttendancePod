/**
 * 联系人详情页面js
 */
var contactId;

var viewId; //来源页面id
var callbackFun; //来源页面回调函数
var isNeedRefresh = 0; //是否需要刷新来源页面

mui.plusReady(function() {
	//接受父页面传过来的参数
	var self = plus.webview.currentWebview();
	viewId = self.viewId;
	callbackFun = self.callbackFun;
	contactId = self.contactId;

	mui.init({
		beforeback: function() {
			if (viewId && callbackFun && isNeedRefresh) {
				var parent = plus.webview.getWebviewById(viewId);
				parent.evalJS(callbackFun + "();");
			}
		}
	});

	/**
	 * 加载用户详情
	 */
	loadDetail();

	//绑定修改事件
	document.querySelector("#edit").addEventListener("tap", function() {
		mui('#popover2').popover('toggle');
		mui.openWindow({
			url: "editcontact.html",
			id: "editcontact",
			extras: {
				contactId: self.contactId,
				viewId: plus.webview.currentWebview().id,
				callbackFun: "refreshDetail"
			}
		})
	});

	//绑定删除事件
	document.querySelector("#delete").addEventListener("tap", function() {
		mui('#popover2').popover('toggle');
		mui.confirm('确认删除吗？', null, null, function(e) {
			if (e.index == 0) {
				plus.nativeUI.showWaiting("等待中...");
				var param = {
					"_clientType": "wap",
					"userId": window.windowCommon.approveLoginId,
					"contactId": self.contactId
				};
				contactApi.deleteContact(param, function(data) {
					plus.nativeUI.closeWaiting();
					if (data == 1) {
						if (viewId && callbackFun) {
							var parent = plus.webview.getWebviewById(viewId);
							parent.evalJS(callbackFun + "();");
						}
						plus.webview.currentWebview().close();
					} else {
						mui.toast("操作失败");
					}
				}, function() {
					plus.nativeUI.closeWaiting();
				});
			} else if (e.index == 1) {
				console.log('取消');
			}
		});
	});
	//点击操作 弹出弹层
	mui("#operate")[0].addEventListener("tap", function() {
		mui("#popover2").popover("toggle");
	});
});

/**
 * 加载联系人详情
 */
function loadDetail() {
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"contactId": contactId
	}
	contactApi.getPerDetail(param, function(data) {
		var html = '';
		html += '<ul class="mui-table-view">';
		html += '<li class="mui-table-view-cell person_one special-active">';
		html += '<img src="' + window.windowCommon.photoUrl + data.photo + '" title="' + data.contactName + '" onerror="headError(this);" />';
		html += '<div class="top_text">';
		html += '<span class="pn1">' + data.contactName + '</span>';
		html += '</div>';
		var bumenjiazhiwu = data.groupName;
		if (bumenjiazhiwu == "") {
			bumenjiazhiwu += data.jobName;
		} else {
			if (data.jobName != "") {
				bumenjiazhiwu += "/" + data.jobName;
			}
		}
		html += '<span class="cn1">' + bumenjiazhiwu + '</span>';
		html += '</li>';
		html += '</ul>';

		html += '<ul class="mui-table-view live">';
		html += '<li class="mui-table-view-cell t1">联系方式</li>';
		html += '<li class="mui-table-view-cell t2">';
		html += '<span class="company_name">' + data.companyName + '</span>';
		html += '<span class="lei1">公司</span>';
		html += '</li>';

		$.each(data.telphoneArr, function(i, item) {
			html += '<li class="mui-table-view-cell t2 clearborder">';
			html += '<div class="left_part">';
			html += '<span class="company_name">' + item + '</span>';
			if (data.telphoneArr.length > 1) {
				html += '<span class="lei1">手机' + (i + 1) + '</span>';
			} else {
				html += '<span class="lei1">手机</span>';
			}
			html += '</div>';
			html += '<div class="right-part">';
			html += '<a href="tel:' + item + '">';
			html += '<img class="phone" src="../../images/perd-ico1_03.png" />';
			html += '</a>';
			html += '<a href="sms:' + item + '">';
			html += '<img class="message" src="../../images/perd-ico_05.png" />';
			html += '</a>';
			html += '</div>';
			html += '</li>';
		});

		$.each(data.phoneArr, function(i, item) {
			html += '<li class="mui-table-view-cell t2">';
			html += '<div class="left_part">';
			html += '<span class="company_name">' + item + '</span>';
			if (data.phoneArr.length > 1) {
				html += '<span class="lei1">座机' + (i + 1) + '</span>';
			} else {
				html += '<span class="lei1">座机</span>';
			}
			html += '</div>';
			html += '<div class="right-part1">';
			html += '<a href="tel:' + item + '">';
			html += '<img class="phone1" src="../../images/perd-ico1_03.png" />';
			html += '</a>';
			html += '</div>';
			html += '</li>';
		});

		html += '</ul>';

		html += '<ul class="mui-table-view live">';
		html += '<li class="mui-table-view-cell t1">更多信息</li>';

		$.each(data.emailArr, function(i, item) {
			html += '<li class="mui-table-view-cell t2">';
			html += '<span class="company_name">' + item + '</span>';
			if (data.emailArr.length > 1) {
				html += '<span class="lei1">邮箱' + (i + 1) + '</span>';
			} else {
				html += '<span class="lei1">邮箱</span>';
			}
			html += '</li>';
		});

		$.each(data.qqArr, function(i, item) {
			html += '<li class="mui-table-view-cell t2">';
			html += '<span class="company_name">' + item + '</span>';
			if (data.qqArr.length > 1) {
				html += '<span class="lei1">QQ' + (i + 1) + '</span>';
			} else {
				html += '<span class="lei1">QQ</span>';
			}
			html += '</li>';
		});

		html += '<li class="mui-table-view-cell t2">';
		html += '<span class="company_name">';
		if (data.sex == 0) {
			html += '女';
		} else {
			html += '男';
		}
		html += '</span>';
		html += '<span class="lei1">性别</span>';
		html += '</li>';
		html += '<li class="mui-table-view-cell t2">';
		var dateStr = ""
		if (data.birthday != undefined && data.birthday != "") {
			var d = new Date(data.birthday);
			var dateStr = d.getFullYear() + "年" + (d.getMonth() + 1) + "月" + d.getDate() + "日";
		}
		html += '<span class="company_name">' + dateStr + '</span>';
		html += '<span class="lei1">生日</span>';
		html += '</li>';
		html += '<li class="mui-table-view-cell t2">';
		html += '<span class="company_name">' + data.address + '</span>';
		html += '<span class="lei1">联系地址</span>';
		html += '</li>';
		html += '<li class="mui-table-view-cell t2">';
		html += '<span class="company_name">' + data.favorite + '</span>';
		html += '<span class="lei1">兴趣</span>';
		html += '</li>';
		html += '<li class="mui-table-view-cell t2">';
		html += '<span class="company_name">' + data.remark + '</span>';
		html += '<span class="lei1">备注</span>';
		html += '</li>';
		html += '</ul>';
		$("#content").append(html);
	});
}

//修改完毕后刷新详情
function refreshDetail() {
	isNeedRefresh = 1;
	$("#content").html('');
	loadDetail();
}