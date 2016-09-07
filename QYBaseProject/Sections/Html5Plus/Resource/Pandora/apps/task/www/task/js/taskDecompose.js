var taskId;
mui.plusReady(function(){
	
	taskId=plus.storage.getItem("taskId");
	//获取日程内容
	getTaskContent(taskId);
	
	//增加日程
	mui("#addChild")[0].addEventListener('tap', function() {
		var html = '<div class="child">';
			html += '<div>';
			var num = $(".child").length+1;
				html += '日程（'+num+'）';
				html += '<span name="delChild"><em class="del-icon"></em>删除</span>';
			html += '</div>';
			html += '<ul>';
				html += '<li class="pr b_bor">';
					html += '<span class="title">日程内容</span>';
					html += '<input name="scheduleContent" placeholder="请输入日程内容" type="text"/>';
				html += '</li>';
				html += '<li class="pr b_bor active">';
					html += '<span class="title">完成日期</span>';
					html += '<em class="lg-icon"></em>';
					html += '<span name="time" class="left">请选择</span>';
				html += '</li>';
			html += '</ul>';
		html += '</div>';
		
		$(".child").last().after(html);
	});
	//删除日程
	$("span[name='delChild']").live("click",function(){
		var obj = $(this).parent().parent();
		mui.confirm('确认删除吗？', null, null, function(e) {
			if (e.index == 0) {
				//移除整个日程子模块
				obj.remove();
				//模块排序显示 重新刷新
				var list = $(".child");
				for(var j=0;j<list.length;j++){
					if(j>0){
						list.eq(j).find("div").eq(0).html('日程（'+(j+1)+'）<span name="delChild"><em class="del-icon"></em>删除</span>');
					}
				}
			} else if (e.index == 1) {
				//console.log('取消');
			}
		});
	});
	
	
	//保存
	mui("#save")[0].addEventListener('tap', function() {
		save();
	});
	
	// 点击完成日期的方法
     $(".child span[name='time']").live("tap",function(){
		var obj = $(this);
		var param = {
			"timeL": null
		};
		_taskApi._selectDateTime(param, function(response){
			
			bTime = response.date;
			obj.html(bTime.split(" ")[0]);
		});
	});
            
              
              });


/**
 * 根据id获取任务详情
 * @param {Object} taskId
 */
function getTaskContent(taskId){
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId,
		"taskId" : taskId
	};
	_taskApi._taskContent(param,function(data){
		$("#content").html(data);
	})
}

/**
 * 保存分解任务
 */
function save(){
	var param = {
		"_clientType": "wap",
		"userId": window.windowCommon.approveLoginId
	};
	param['id']=taskId;
	var list = $("input[name='scheduleContent']");
	for(var i=0;i<list.length;i++){
		var value = list.eq(i).val();
		if(value!=null && value!="" && value.trim()!=""){
			param['scheduleList['+i+'].content'] = value;
		}else{
			mui.toast('日程内容不能为空！');
			return false;
		}
	}
	var list_time = $("span[name='time']");
	for(var j=0;j<list_time.length;j++){
		var value = list_time.eq(j).html();
		if(value!=null && value!="" && value.trim()!="" && value.trim()!="请选择"){
			param['scheduleList['+j+'].completeTime'] = value+' 23:59:59';
		}else{
			mui.toast('日程完成日期不能为空！');
			return false;
		}
	}
	plus.nativeUI.showWaiting('等待中...');
	console.log(JSON.stringify(param))
	_taskApi._taskDecompose(param,function(data){
		plus.nativeUI.closeWaiting();
		if(data==1){
			mui.toast('分解成功！');
			//设置不使用tabList页面缓存
    		setCacheEnd();
    		plus.storage.setItem("taskBackUrl","tabList.html");
			window.location.href = 'taskDecomposeSuccess.html';
		}else{
			mui.toast('分解失败！');
		}
	})
}
