//
//  QYPushHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/25.
//  Copyright (c) 2015年 田. All rights reserved.
//  推送二次封装

#import <UIKit/UIKit.h>
#import "QYPushResult.h"
/**
 *  监测APNS消息和自定义消息，
 *  QYPushResult *pushResult=[notification object];
 */
extern NSString *const QYPushHelperDidReceiveRemoteNotification;


typedef void (^QYPushHelperSetTagSuccess)();
typedef void (^QYPushHelperSetTagFailure)(int code, NSString *log);
@interface QYPushHelper : NSObject

+ (QYPushHelper *)shared;
/**
 *  配置推送，不掉用则此项目不使用推送
 *
 *  @param launchOptions
 */
-(void)configPush:(NSDictionary *)launchOptions;

/**
 *  设置标签和(或)别名（若参数为nil，则忽略；若是空对象，则清空；)
 *
 *  @param tags    标签
 *  @param alias   别名
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)setTags:(NSSet *)tags alias:(NSString *)alias success:(QYPushHelperSetTagSuccess)success failure:(QYPushHelperSetTagFailure)failure;

/**
 *  向服务器上报Device Token
 *
 *  @param deviceToken
 */
-(void)registerDeviceToken:(NSData *)deviceToken;


/**
 *  处理收到的APNS消息，向服务器上报收到APNS消息
 *
 *  @param remoteInfo
 */
- (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

/**
 *  set setBadge
 *  @param value 设置JPush服务器的badge的值
 *  本地仍须调用UIApplication:setApplicationIconBadgeNumber函数,来设置脚标
 */
- (BOOL)setBadge:(NSInteger)value;



@end
