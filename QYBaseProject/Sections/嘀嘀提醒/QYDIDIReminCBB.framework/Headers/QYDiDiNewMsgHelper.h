//
//  QYDiDiNewMsgHelper.h
//  QYBaseProject
//
//  Created by 小海 on 15/9/6.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *NewAlertSuccessForDIDI = @"NewAlertSuccessForDIDI";

@interface QYDiDiNewMsgHelper : NSObject

+ (QYDiDiNewMsgHelper *)shared;

/**
 *  创建推送的监控
 */
- (void)openPushMonitoring;

/**
 *  收到新提醒推送时调用
 */
- (void)ConfirmReminderNoticeForDIDI;

/**
 *  获得本地存储的最新提醒
 *
 *  @return 新提醒对象，以字典形式返回
 */
- (NSDictionary *)getDataForNewRemind;

/**
 *  删除本地存储的最新提醒
 */
- (void)removeDataForNewRemind;

/**
 *  获取最新提醒的请求
 *
 *  @param content <#content description#>
 */
- (void)getTheLatestNews:(void (^) (NSDictionary *content))content;

@end
