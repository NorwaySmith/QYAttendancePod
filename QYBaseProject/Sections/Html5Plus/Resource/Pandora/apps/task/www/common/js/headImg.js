function letterCode(name){
	var colorCode="0";
	var num = 0;
	for (var i = 0; i < name.length; i++) {
		num += parseInt(name[i].charCodeAt(0));
	}
	return parseInt(parseInt(num) % 10)+1;
}
function headError(obj){
	var name = $(obj).attr("title");
	name = name.replace(" ","");
	if(name.length>2){
		name = name.substring(name.length-2,name.length);
	}
	var html = '<div class="round head-bg-'+letterCode(name)+'">'+name+'</div>';
	$(obj).after(html);
	$(obj).remove();
}
