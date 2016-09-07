//
//  QYH5Api.m
//  QYBaseProject
//
//  Created by 田 on 15/8/14.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYH5Api.h"
#import <AFNetworking.h>
#import "QYNetworkJsonProtocol.h"
#import "QYAccount.h"
#import "QYAccountService.h"

//协议的分割字符串

@implementation QYH5Api

+(void)upLoadImage:(NSData *)fileData
         urlString:(NSString *)urlString
        moduleCode:(NSString *)moduleCode
           success:(void (^)(NSString *responseString))success
           failure:(void (^)(NSString *alert))failure
    UpLoadproGress:(void(^)(float progress))UpLoadproGress
{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    [networkHelper showHUDAtView:nil message:@"正在上传图片"];
    
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    NSString *fileName = @"fileupload";
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    [mutableString appendFormat:@"%@?",urlString];
    [mutableString appendFormat:@"companyId=%@&",account.companyId];
    [mutableString appendFormat:@"moduleCode=%@&",moduleCode];
    [mutableString appendFormat:@"userId=%@&origin=app",account.userId];
    
    [networkHelper upload:mutableString fileData:fileData fileName:fileName mimeType:@"image/png" parameters:nil success:^(QYNetworkResult *result)
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
            failure(errMessage);
        }
    }
    proGress:^(float progress)
    {
        UpLoadproGress(progress);
    }];
}



@end
