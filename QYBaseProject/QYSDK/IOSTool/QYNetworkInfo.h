//
//  QYNetworkInfo.h
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"

//网络连接状态发生变化
extern NSString * const QYNetworkingReachabilityDidChangeNotification;
//网络状态
extern NSString * const QYNetworkingReachabilityNotificationStatusItem;


@interface QYNetworkInfo : NSObject
+ (QYNetworkInfo *)shared;
// 是否连接到网络
- (BOOL)connectedToNetwork;
// 是否连接到wifi
- (BOOL)connectedToWiFi;
// 是否连接到手机网络
- (BOOL)connectedToCellNetwork;
//开始监控网络状态
- (void)startMonitoring;
//停止监控网络状态
- (void)stopMonitoring;
@end
