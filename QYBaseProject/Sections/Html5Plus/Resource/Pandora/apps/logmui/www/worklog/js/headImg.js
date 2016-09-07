function letterCode(name){
	var colorCode="0";
	var num = 0;
	for (var i = 0; i < name.length; i++) {
		num += parseInt(name[i].charCodeAt(0));
	}
	return (parseInt(num) % 10) + 1;
}
function headError(obj){
	var name = $(obj).attr("title");
	name = name.replace(" ","");
	if(name.length>2){
		name = name.substring(name.length-2,name.length);
	}
	var html = '<div class="rect head-bg-'+letterCode(name)+'">'+name+'</div>';
	$(obj).after(html);
	$(obj).remove();
}


function headRectError(obj){
	var name = $(obj).attr("title");
	name = name.replace(" ","");
	if(name.length>2){
		name = name.substring(name.length-2,name.length);
	}
	var html = '<div class="rect head-bg-'+letterCode(name)+'">'+name+'</div>';
	$(obj).after(html);
	$(obj).remove();
}

function head42RectError(obj){ 
	var name = $(obj).attr("title");
	name = name.replace(" ","");
	if(name.length>2){
		name = name.substring(name.length-2,name.length);
	}
	var html = '<div class="rect42 head-bg-'+letterCode(name)+'">'+name+'</div>';
	$(obj).after(html);
	$(obj).remove();
}

