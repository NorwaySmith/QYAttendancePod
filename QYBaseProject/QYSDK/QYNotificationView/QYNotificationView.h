//
//  QYNotificationView.h
//  QYNotificationViewTest
//
//  Created by 田 on 16/1/26.
//  Copyright © 2016年 田. All rights reserved.
//
/**
 *  弹出的QYNotificationView
 */
#import <UIKit/UIKit.h>
@class QYNotificationView;
/**
 *  点击回调block
 */
typedef void (^QYNotificationViewTap)(QYNotificationView *notificationView);

@interface QYNotificationView : UIView
/**
 *  显示几秒钟
 */
@property(nonatomic,assign)NSTimeInterval duration;
/**
 *  扩展字段
 */
@property(nonatomic,strong)id extend;

/**
 *  弹出QYNotificationView
 *
 *  @param text     标题
 *  @param detail   内容
 *  @param image    左侧图标
 *  @param duration 延时多长时间
 *  @param tapBlock 点击回调
 *
 *  @return QYNotificationView对象
 */
+ (QYNotificationView *) showWithText:(NSString*)text
                               detail:(NSString*)detail
                                image:(UIImage*)image
                             duration:(NSTimeInterval)duration
                           tapBlock:(QYNotificationViewTap)tapBlock;
@end
