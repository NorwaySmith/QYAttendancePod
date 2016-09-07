mui.plusReady(function(){
	function initParams(){
		window.windowCommon={
			basePath:plus.storage.getItem("basePath"),
			baseUrl:plus.storage.getItem("baseUrl")
		};
	}
	initParams();
});