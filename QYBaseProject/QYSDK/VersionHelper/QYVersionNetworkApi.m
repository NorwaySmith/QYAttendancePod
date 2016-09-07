//
//  QYVersionNetworkApi.m
//  QYBaseProject
//
//  Created by 田 on 15/6/10.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYVersionNetworkApi.h"
#import "QYURLHelper.h"
#import "QYNetworkJsonProtocol.h"
#import "QYApplicationConfig.h"
//static NSString  *uploadVersionUrl          = @"http://218.206.244.202:38080/ydzjcbb/ydzjMobile/getNewVersion.action";
static NSString  *decollator       = @"||";
static NSString  *ModelCode          = @"ydzjMobile";
@implementation QYVersionNetworkApi
//更新版本
+(void)updateVersion:(NSInteger)versionCode
              userId:(NSString*)userId
           companyId:(NSString*)companyId
             showHud:(BOOL)showHud
             success:(void (^)(NSString *responseString))success
             failure:(void (^)(NSString *alert))failure{
    
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"getNewVersion"];
//    NSString *urlString = @"http://101.200.31.143/ydzjMobile/getNewVersion.action?";
    NSDictionary *parameters = @{@"versionCode":@(versionCode),
                                 @"userId":userId,
                                 @"companyId":companyId,
                                 @"type":@(VersionType),
                                 @"_clientType":@"wap"};

    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    if (showHud)
    {
        [networkHelper showHUDAtView:nil message:@"正在检测新版本"];
    }
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
    {
        if(result.statusCode == NetworkResultStatusCodeSuccess)
        {
            success(result.result);
        }
        else if(result.statusCode == NetworkResultStatusCodeNoData)
        {
            failure(result.result);
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
