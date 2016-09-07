//
//  QYNetworkInfo.m
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYNetworkInfo.h"
NSString * const QYNetworkingReachabilityDidChangeNotification = @"com.quanya.networking.reachability.change";
NSString * const QYNetworkingReachabilityNotificationStatusItem = @"QYNetworkingReachabilityNotificationStatusItem";
@interface QYNetworkInfo()
/**
 *  网络监控是否开启
 */
@property(nonatomic,assign)BOOL isMonitoring;
@end
@implementation QYNetworkInfo
+ (QYNetworkInfo *)shared
{
    static dispatch_once_t pred;
    static QYNetworkInfo *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
// 是否连接到网络
- (BOOL)connectedToNetwork{
    /**
     * 如果未开启网络状态监测，则认为网络畅通
     */
    if (!_isMonitoring) {
        return YES;
    }
    AFNetworkReachabilityStatus networkReachabilityStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (networkReachabilityStatus==AFNetworkReachabilityStatusUnknown||
        networkReachabilityStatus==AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}
// 是否连接到wifi
- (BOOL)connectedToWiFi{
  return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}
// 是否连接到手机网络
- (BOOL)connectedToCellNetwork{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;

}
//开始监控网络状态
- (void)startMonitoring{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _isMonitoring=YES;
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:QYNetworkingReachabilityDidChangeNotification object:nil userInfo:@{ AFNetworkingReachabilityNotificationStatusItem: @(status) }];
        });

    }];
}
//停止监控网络状态
- (void)stopMonitoring{
  [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
@end
