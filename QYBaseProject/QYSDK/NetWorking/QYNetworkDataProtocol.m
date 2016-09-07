//
//  QYNetworkDataProtocol.m
//  QYBaseProject
//
//  Created by 田 on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYNetworkDataProtocol.h"

@implementation QYNetworkDataProtocol

- (QYNetworkResult *)convertResultData:(NSData *)resultData
                            resultType:(NetworkResultType)resultType
{
    QYNetworkResult *networkResult = [[QYNetworkResult alloc] init];
    networkResult.resultType = resultType;
    if (!resultData)
    {
        networkResult.errMessage = @"服务端返回数据格式有误";
        networkResult.statusCode = NetworkResultStatusCodeParseError;
        return networkResult;
    }
    networkResult.statusCode = NetworkResultStatusCodeSuccess;
    networkResult.result = resultData;
    return networkResult;
}

@end
