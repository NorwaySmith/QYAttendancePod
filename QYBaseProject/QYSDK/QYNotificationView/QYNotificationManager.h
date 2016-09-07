//
//  QYNotificationManager.h
//  QYNotificationViewTest
//
//  Created by 田 on 16/1/26.
//  Copyright © 2016年 田. All rights reserved.
//
/**
 *  管理当前弹出的QYNotificationView
 */
#import <Foundation/Foundation.h>
@class QYNotificationView;
@interface QYNotificationManager : NSObject
/**
 *  单例
 *
 *  @return QYNotificationManager对象
 */
+(QYNotificationManager*)shared;

/**
 *  向队列中添加notificationView
 *
 *  @param notificationView 弹出view
 */
-(void)addNotificationView:(QYNotificationView*)notificationView;

/**
 *  从队列中删除notificationView
 *
 *  @param notificationView 删除view
 */
-(void)removeNotificationView:(QYNotificationView*)notificationView;

@end
