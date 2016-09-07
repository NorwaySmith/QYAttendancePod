/**
 * 客户统计报表jsAPI
 */
var customerStatisticalReportAPI =
    {
		//订单回款金额统计
		_paycustomerStatisticalReport : function(param,successCallback){
			var url = window.windowCommon.basePath + 'crm/customerStatistics/getCustomerStatistics.c';
			mui.ajax(url, {
				data: param,
				dataType: 'json',
				type: 'post', //HTTP请求类型
				timeout: 10000, //超时时间设置为10秒；
				crossDomain: true,
				success: function(result){
					if(successCallback){
						successCallback(result);
					}
				}
			});
		}
    };