mui.plusReady(function() {
    // var type=plus.storage.getItem("type");
     findDetail();
     findTransferTask();
     $("#notFinshReason").hide();
     $("#reason").hide();
    $("#twoButton").hide();
	$("#fourButton").hide();
	$("#schedule").hide();
	$("#finshNum").hide();
   $("#receive").click(function(){
   	  
		var taskId=plus.storage.getItem("taskId");
		   console.log(taskId);
	    var param={"taskId":taskId};
		_taskApi._updateTaskStatus(param,function(response){
			if(response.num==1){
	    		mui.toast('领取失败！');
	    }else{
	    		mui.toast('领取成功！');	    
				//设置不使用tabList页面缓存
    			setCacheEnd();
	    		window.location.href='receiveTask.html';
	    	}
		}) 
   });
   
     
     //绑定分解操作
     mui("#decompose")[0].addEventListener('tap', function() {
     	window.location.href='taskDecompose.html';
     });
     
     // 绑定撤销操作
     mui("#cancelButton")[0].addEventListener('tap', function() {
     	console.log('撤销操作');
     	// 第二个参数是标题
     	mui.confirm('确认要撤销该任务吗？', null, null, function(e) {
			if (e.index == 0) {
				console.log('点击确定');
		     	var param={
		     		"taskId":plus.storage.getItem("taskId"), 
		     		"userId":window.windowCommon.approveLoginId,
		     		"taskStatus":4
		     	};
		     	
				_taskApi._taskStatusChange(param,function(response){
					var code = response.code;
					if(code == 1){
						console.log('操作成功');
						//设置不使用tabList页面缓存
    					setCacheEnd();
						window.location.href='tabList.html';
					}
				});
			} else if (e.index == 1) {
				console.log('点击取消');
			}
		});

     });
     
     // 绑定未完成操作
     mui("#stopButton")[0].addEventListener('tap', function() {
     	console.log('未完成操作');
     	window.location.href = "UnDoneReason.html";
     });
     
     // 绑定完成操作
     mui("#completeButton")[0].addEventListener('tap', function() {
     	console.log('完成操作');
     	mui.confirm('确定该任务已完成了吗？', null, null, function(e) {
			if (e.index == 0) {
				console.log('点击确定');
		     	var param={
		     		"taskId":plus.storage.getItem("taskId"), 
		     		"userId":window.windowCommon.approveLoginId,
		     		"taskStatus":2
		     	};
				_taskApi._taskStatusChange(param,function(response){
					var code = response.code;
					if(code == 1){
						console.log('操作成功');
						//设置不使用tabList页面缓存
    					setCacheEnd();
						window.location.href='tabList.html';
					}
				});
			} else if (e.index == 1) {
				console.log('点击取消');
			}
		});

     });
     
     //绑定转交操作
     mui("#transferButton")[0].addEventListener('tap', function() {
     	window.location.href='TransferReason.html';
     });
  
});

	var findDetail= function(){
	  var taskId=plus.storage.getItem("taskId");
		console.log(taskId);
		var param={"taskId":taskId};
		_taskApi._getDetail(param,function(response){
			
			plus.storage.setItem("creatName",response.creatName);
			$("#taskContent").html(response.taskContent);
			if(response.undoneReason!=""){
				$("#notFinshReason").show();
				$("#completeReason").html("<em class='jiantou_ico'></em>"+response.undoneReason);
			}			
			$("#finshTime").html("<em class='time_ico'></em>完成日期："+response.finshTime);
			$("#fromTask").html("<em class='source_ico'></em>任务来源："+response.creatName);
			console.log(response.underTakerName);

			$("#accept").html("<em class='jieshou_ico'></em>承办人员："+response.underTakerName);
			$("#accept").hide();
            $("#jieshouren").html("<em class='jieshou_ico'></em>接收人员："+response.underTakerName);
			$("#jieshouren").hide();
			$("#completeCount").html("已完成："+response.num+"/"+response.count);
			$.each(response.list,function(i,schedule){
		         console.log(schedule.scheduleContent);
				var html='<ul class="pr b_bor">';
					html +='<li class="pr b_bor">';
					html +='<div class="schedule_list_each">';
					html +='<span class="schedule_each_content text_hide">'+schedule.scheduleContent+'</span>';
					if(schedule.scheduleStatus==0){
						html +='<span class="schedule_each_status text_hide">进行中</span>';
					}
					if(schedule.scheduleStatus==1){
						html +='<span class="schedule_each_status text_hide">已完成</span>';
					}
					if(schedule.scheduleStatus==2){
						html +='<span class="schedule_each_status text_hide">未完成</span>';
					}
					
					html +='</div>';
					html +='</li>';
					html +='</ul>';
					$("#schedule").append(html);
			});
			
			console.log(response.decompose);
			
			var type=plus.storage.getItem("type");
			if(type==2){
				$("#fromTask").hide();
				$("#accept").show();
			}
			if(type==3){			
				$("#jieshouren").show();
			}
			//未分解
			if(response.decompose==0){ 
				// $("#schedule").hide();
				// $("#finshNum").hide();
				
				console.log(taskId)
				console.log(response.taskStatus); 
				 if(response.undertaker==window.windowCommon.approveLoginId){
				 	//$("#accept").hide();
				 	    //进行中
				 	      
				 	    if(response.taskStatus==1){ 
				 	    	  
				 	     	  // $("#twoButton").hide();
				 	     	   $("#fourButton").show();
				 	     }
				 	    //代领取
				 	     if(response.taskStatus==0){
				 	     	   //$("#fourButton").hide();
				 	     	   $("#twoButton").show();
				 	     }
				 }else{
				 	  
				 	    //$("#twoButton").hide();
				 	    //$("#fourButton").hide();
				 }
			}
			//已分解
			else{
				$("#schedule").show();
				$("#finshNum").show();
				
				//$("#twoButton").hide();
				//$("#fourButton").hide();
				
			}
			
			
		});
	}
	
	var findTransferTask= function(){
		var type=plus.storage.getItem("type");
    	var taskId=plus.storage.getItem("taskId");
    	console.log(taskId);
	    var userId=window.windowCommon.approveLoginId;
	    console.log(userId);
	    var param={
		"taskId":taskId,
	    "userId":userId,   
	    "type":type,
	    };

        _taskApi._findTransfer(param,function(response){
        	console.log(response);
        	
			if(response.split("|")[0]==0){
				$("#reason").hide();			
				$("#accept").hide();
			}else{	
				console.log(response.split("|")[1]);
				plus.storage.setItem("zhuanjiao",response.split("|")[1])
				$("#reason").show();
				$("#tranReason").html("<em class='jiantou_ico'></em>"+response.split("|")[1]);
				console.log(response.split("|")[1]);
				$("#accept").html("<em class='accept_ico'></em>承办人员："+response.split("|")[2]);
				//$("#accept").hide();
			}
			
		});
	}
