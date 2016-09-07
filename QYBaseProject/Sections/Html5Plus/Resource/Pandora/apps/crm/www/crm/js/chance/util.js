/**
 * 去除前后特殊字符
 * @param {Object} str 操作字符串
 * @param {Object} c 特殊字符， 不传时，默认是英文逗号
 */
var trim = function(str, c) {
	if(!c){
		c = ',';
	}
	if( str ){
		if( c == str.charAt(0) ){
			if(str.length > 1){
				str = str.substring(1);
			}else {
				return undefined;
			}
		}
		if( c == str.charAt(str.length-1) ){
			str = str.substring(0, str.length-1);
		}
		return str;
	}else {
		return undefined;
	}
}

/**
 * 验证一个数字的小数位数
 * @param {Object} num Number类型，将要验证的数字
 * @param {Object} fl Number类型，正整数，最大小数位数
 * @returns {Boolean} false 表示验证不通过， true 表示验证通过
 */
var verifyPoints = function (num, fl){
	
	if( num*Math.pow(10, fl+1)%10 != 0 ){
		return false;
	}else {
		return true;
	}
}

// 说明：添加、移除、检测 className
var hasClass = function (element, className) {
	var reg = new RegExp('(\\s|^)'+className+'(\\s|$)');
	return element.className.match(reg);
}
var addClass = function (element, className) {
	if (!this.hasClass(element, className)) {
		element.className += " "+className;
	}
}
var removeClass = function (element, className) {
	if (hasClass(element, className)) {
		var reg = new RegExp('(\\s|^)'+className+'(\\s|$)');
		element.className = element.className.replace(reg,' ');
	}
}


/**
 * 把数字转成千分位
 */
function commNum(num) {
	num = num.toFixed(2) +"";
	var re=/(-?\d+)(\d{3})/
	while(re.test(num)){
		num=num.replace(re,"$1,$2");
	}
	return num;
}