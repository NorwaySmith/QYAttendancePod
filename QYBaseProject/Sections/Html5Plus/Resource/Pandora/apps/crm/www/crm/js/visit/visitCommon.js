
/**
 *取消点赞
 * @param {Object} obj
 */
function delPraise(obj) {
	var num = "";
	if ($(obj).children().html() != "") {
		num = parseInt($(obj).children().html()) - parseInt(1);
	}
	if(num==0){
		num="";
	}
	var visitdetailId = $(obj).attr("visitdetailId");
	var param = {
		"_clientType": "wap",
		"visitdetailId":visitdetailId,
		"userId":window.windowCommon.approveLoginId
	}
	visitApi.delvisitPraise(param,function(data){
		$(obj).children().text(num);
		$(obj).removeClass("good").addClass("nogood");
	},function(){
		//异常处理；
		console.log(errorThrown);
	});

}

/**
 * 删除拜访记录
 * @param {Object} visitdetailId
 */
function del(visitdetailId) {
	mui.confirm("确定要删除吗？",null,null,function(e){
		if(e.index == 0) {
			var param = {
				"_clientType": "wap",
				"visitdetailId": visitdetailId,
				"userId": window.windowCommon.approveLoginId
			}
			visitApi._delRecord(param,function(data){
				if(data==1){
					mui.toast("删除成功");
					refreshChildData();
				}else if(data==2){
					mui.toast("没有删除权限");
				}
			},function(){
				//异常处理；
				mui.toast("删除失败");
				console.log(errorThrown);
			})
		}else if(e.index == 1) {
			console.log('取消');
		}
	});
}


/**
 *点赞
 * @param {Object} obj
 */
function praise(obj) {
	var num = "";
	if ($(obj).children().html() == "") {
		num = 1;
	} else {
		num = parseInt($(obj).children().html()) + parseInt(1);
	}
	var visitdetailId = $(obj).attr("visitdetailId");
	var param = {
		"_clientType": "wap",
		"visitdetailId":visitdetailId,
		"userId":window.windowCommon.approveLoginId
	}
	visitApi.savevisitPraise(param,function(data){
		$(obj).children().text(num);
		$(obj).removeClass("nogood").addClass("good");
	},function(){
		//异常处理；
		console.log(errorThrown);
	});
	
}