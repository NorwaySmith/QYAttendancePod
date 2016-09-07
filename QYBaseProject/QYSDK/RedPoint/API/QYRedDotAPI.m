//
//  QYRedDotAPI.m
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYRedDotAPI.h"
#import "QYURLHelper.h"
#import "QYNetworkHelper.h"
#import "QYAccountService.h"
#import "QYNetworkJsonProtocol.h"

@implementation QYRedDotAPI

+(void)allRedPointSuccess:(void (^)(NSString *responseString))success
                  failure:(void (^)(NSString *alert))failure
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    if(!account)
    {
        return;
    }
    
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:@"redPoint" urlKey:@"unRead"];
    
    NSDictionary *parameters = @{@"userId":account.userId,
                                 @"companyId":account.companyId,
                                 @"columnId":@"35",
                                 @"_clientType":@"wap"};
    
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
             failure(Error404Alert);
         }
    }];
}

@end
