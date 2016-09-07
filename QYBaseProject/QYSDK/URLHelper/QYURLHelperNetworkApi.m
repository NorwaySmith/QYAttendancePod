//
//  QYURLHelperNetworkApi.m
//  QYBaseProject
//
//  Created by 田 on 15/6/11.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYURLHelperNetworkApi.h"
#import "QYURLHelper.h"
#import "QYNetworkJsonProtocol.h"

//http://218.206.244.202:38080/interface/ClientServlet?_clientType=wap&lastVisitTime=&projectName=ydzjcbb&surrounding=beta
//http://101.200.31.143/interface/ClientServlet?_clientType=wap&lastVisitTime=&projectName=ydzjcbb&surrounding=beta

static NSString  *decollator       = @"||";
static NSString  *ModelCode        = @"ydzjMobile";

static NSString  *urlString        = @"http://101.200.31.143/interface/ClientServlet";
//static NSString *urlString         = @"http://218.206.244.202:38080/interface/ClientServlet";

@implementation QYURLHelperNetworkApi

+(void)allUrlWithProjectName:(NSString *)projectName
                 surrounding:(NSString *)surrounding
               lastVisitTime:(NSString *)lastVisitTime
                     success:(void (^)(NSString *responseString))success
                     failure:(void (^)(NSString *alert))failure
{
    NSDictionary *parameters = @{@"projectName":projectName,
                                 @"surrounding":surrounding,
                                 @"lastVisitTime":lastVisitTime,
                                 @"_clientType":@"wap"
                                 };
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
    {
        if(result.statusCode == NetworkResultStatusCodeSuccess)
        {
            success(result.result);
        }
        else if(result.statusCode == NetworkResultStatusCodeNoData)
        {
            success(result.result);
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
