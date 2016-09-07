//
//  QYMoreSearchNetWorkApi.m
//  QYBaseProject
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreSearchNetWorkApi.h"
#import "QYURLHelper.h"
#import "QYNetworkHelper.h"
#import "QYNetworkJsonProtocol.h"

@implementation QYMoreSearchNetWorkApi

+(void)loadListWithsearchName:(NSString *)searchName pageIndex:(int)pageIndex success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"findCompanyList"];
    NSDictionary *parameters = @{@"searchName":searchName,
                               @"pageSize":@"10",
                               @"_clientType":@"wap",
                               @"pageIndex":[NSString stringWithFormat:@"%d", pageIndex]};
    [networkHelper POST:urlString parameters:parameters
                success:^(QYNetworkResult *result)
    {
        if(result.statusCode == NetworkResultStatusCodeSuccess)
        {
            success(result.result);
        }
        else if(result.statusCode == NetworkResultStatusCodeNoData)
        {
            failure(result.errMessage);
        }
        else
        {
            failure(result.errMessage);
        }
    }
    failure:^(NetworkErrorType errorType)
    {
        if (errorType == NetworkErrorTypeNoNetwork)
        {
            failure(ErrorNoNetworkAlert);
        }
        if (errorType == NetworkErrorType404)
        {
            NSString *errMessage = [NSString stringWithFormat:@"%s :404",__FUNCTION__];
            failure(Error404Alert);
        }
    }];
}

@end
