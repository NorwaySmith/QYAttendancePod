//
//  QYNewsNotificationMonitor.h
//  QYBaseProject
//
//  Created by 小海 on 15/9/17.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  最新新闻储存成功后调用
 */
static NSString *LatestNewsSuccessForNEW = @"LatestNewsSuccessForNEW";

@interface QYNewsNotificationMonitor : NSObject

+ (instancetype)shared;

/**
 *  创建推送的监控
 */
- (void)openTheNewsNotificationMonitor;

/**
 *  收到新新闻推送时调用
 */
- (void)ConfirmReminderNoticeForNEW;

/**
 *  获得本地存储的最新新闻
 *
 *  @return 新闻对象，以字典形式返回
 */
- (NSDictionary *)getDataForNewRemind;

/**
 *  删除本地存储的最新新闻
 */
- (void)removeDataForNewRemind;

@end
