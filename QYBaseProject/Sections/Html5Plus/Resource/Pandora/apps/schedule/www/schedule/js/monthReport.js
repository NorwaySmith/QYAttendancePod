

/**
 *  当前年
 */
var year = 0;
/**
 *  当前月份 
 */
var month = 0;
/**
 * 当前天
 */
var day = 0;

mui.plusReady(function() {
	//getScheduleList();
	//上个月
	var date = new Date();
	var month = date.getMonth() + 1;
	var year=date.getFullYear();
	var yearMonth = year+'-'+month;
	if(month<10){
		yearMonth = year+'-0'+month;
	}
	getScheduleList(yearMonth);
	$(".time").html('<em class="left_ico"></em>'+year+'年'+month+'月<em class="rigth_ico"></em></em>');
	$(".left_ico").live("tap",function(){
		console.log(month);
		if(month==1){
			month = 12;
			year = parseInt(year)-1;
		}else{			
			month = parseInt(month)-1;
			console.log(month);
		}
		console.log(month);
		$(".time").html('<em class="left_ico"></em>'+year+'年'+month+'月<em class="rigth_ico"></em></em>');	
		var yearMonth = year+'-'+month;
		if(month<10){
			yearMonth = year+'-0'+month;
		}
		getScheduleList(yearMonth);
	})
	//下个月
	$(".rigth_ico").live("tap",function(){
		if(month==12){
			month = 1;
			year = parseInt(year)+1;
		}else{
			month = parseInt(month)+1;
		}
		$(".time").html('<em class="left_ico"></em>'+year+'年'+month+'月<em class="rigth_ico"></em>');
		var yearMonth = year+'-'+month;
		if(month<10){
			yearMonth = year+'-0'+month;
		}
		getScheduleList(yearMonth);
	})
});


function getScheduleList(yearMonth){
	console.log()
	//var time=$("#time").text();
	var userId=window.windowCommon.approveLoginId;
	console.log(time);
	console.log(userId);
	var param={
		"completeMonth":yearMonth,
		"userId":userId
	}
	_scheduleApi._getScheduleListes(param,function(data){	
		console.log(window.windowCommon.basePath);
		console.log(data.list);
		var num=0;
		if(data.count[0].totalCount!=0){
			num=parseInt(data.count[0].doneCount)*100/parseInt(data.count[0].totalCount);
            console.log(num.toFixed(2));		
			num=num.toFixed(2);
		}
		$("#totalCount").html(data.count[0].totalCount);
	 	$("#doneCount").html(data.count[0].doneCount);
		$("#percent").html(num+"%");
		if(data.list==0){		
	 	    $("#list").html("");
		}else{  
	 	     var html=" ";
	 	     var day = '';
	 	     $.each(data.list,function(i,task){	
	 	     	
	 	     	if(day != task.time){
	 	     		if(data.today == task.time){
	 	     			html+="<div class='completeTime' id='completeTime' >今天</div>"
	 	     		}else {
	 	     			html+="<div class='completeTime' id='completeTime' >"+task.time+"</div>"
	 	     		}
	 	     		
	 	     		day = task.time;
	 	     	}
		 		 
		 		 html+="<ul class='content' >";
		 		 html+="<li class='pr b_bor'><span class='pr'>"+task.content+"</span></li>";
		 		 html+="</ul>";
		 		
	 	     });
	 	     $("#list").html(html);
		}	   
	 	
	 	
	});
}
