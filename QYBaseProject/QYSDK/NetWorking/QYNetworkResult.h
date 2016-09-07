//
//  QYNetworkResult.h
//  QYBaseProject
//
//  Created by 田 on 15/6/12.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
////协议返回状态码定义
//#define NETWORK_ACCESSR_SUCCESS 100
////无数据,可能是错误提示
//#define NETWORK_ACCESSR_NODATA 101
////数据库错误
//#define NETWORK_ACCESSR_DBERROR 102
////未知错误
//#define NETWORK_ACCESSR_UNKNOWNERROR 999
////解析错误
//#define NETWORK_ACCESSR_DATAPARSEERROR 998

//状态码
typedef NS_ENUM(NSUInteger, NetworkResultStatusCode) {
    NetworkResultStatusCodeSuccess = 100,       //网络数据
    NetworkResultStatusCodeNoData = 101,        //无数据,可能是错误提示
    NetworkResultStatusCodeDBError = 102,       //数据库错误
    NetworkResultStatusCodeRelogin = 103,       //重新登录
    NetworkResultStatusCodeParseError = 998,    //解析错误
    NetworkResultStatusCodeUnknowError = 999,   //未知错误
};

typedef NS_ENUM(NSUInteger, NetworkResultType) {
    NetworkResultTypeNetwork = 0,               //网络数据
    NetworkResultTypeCache                      //缓存数据
};

@interface QYNetworkResult : NSObject
/**
 *  结果类型
 */
@property(assign,nonatomic) NetworkResultType resultType;
/**
 *  返回状态码
 */
@property(assign,nonatomic) NetworkResultStatusCode statusCode;
/**
 *  错误内容
 */
@property(strong,nonatomic) NSString *errMessage;
/**
 *  返回值
 */
@property(strong,nonatomic) id result;
/**
 *  扩展字段
 */
@property(strong,nonatomic) NSString *extra;

@end
