//
//  QYNetworkIMJsonProtocol.m
//  QYBaseProject
//
//  Created by lin on 15/8/27.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYNetworkIMJsonProtocol.h"
#import "IOSTool.h"

//协议的分割字符串
static  NSString  *separateString = @"#￥^&";
static  NSString  *reLoginSeparateString = @"||";

@implementation QYNetworkIMJsonProtocol

- (QYNetworkResult *)convertResultData:(NSData*)resultData
                            resultType:(NetworkResultType)resultType
{
    
    NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    QYNetworkResult *networkResult = [[QYNetworkResult alloc] init];
    networkResult.resultType = resultType;
    if ([result isNil]){
        networkResult.errMessage = @"服务端返回数据格式有误";
        networkResult.statusCode = NetworkResultStatusCodeParseError;
        return networkResult;
    }

    NSArray * array = [result componentsSeparatedByString:separateString];
    //如果im分隔符不能分隔成功，就用||分隔
    if ([array count]==1) {
        array = [result componentsSeparatedByString:reLoginSeparateString];
    }

    if (array.count < 2)
    {
        networkResult.statusCode = NetworkResultStatusCodeParseError;
        networkResult.errMessage = @"服务端返回数据格式有误";
        return networkResult;
    }
    networkResult.statusCode = [array[0] intValue];
    if ([array[1] isEqualToString:@"[]"])
    {
        networkResult.statusCode = NetworkResultStatusCodeNoData;
        networkResult.errMessage = @"无数据";
        return networkResult;
    }
    //解决json中有||问题
    NSMutableString *retString = [[NSMutableString alloc] init];
    for (int i = 1; i < [array count]; i++)
    {
        NSString *item = array[i];
        [retString appendString:item];
    }
    networkResult.result = retString;
    if (networkResult.statusCode != NetworkResultStatusCodeSuccess)
    {
        networkResult.errMessage = array[1];
    }
    return networkResult;
}

@end
