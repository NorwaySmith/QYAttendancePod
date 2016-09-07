//
//  QYDialogTool.h
//  IOSToolDemo
//
//  Created by 田 on 15/5/7.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYDialogTool : NSObject
/**
 *  @author 田鹏涛, 15-05-07 11:05:40
 *
 *  弹出UIAlertView
 *
 *  @param label 提示文字
 */
+ (void)showDlgAlert:(NSString *) label;

/**
 *  @author 田鹏涛, 15-05-07 11:05:07
 *
 *  弹出UIAlertView
 *
 *  @param label 提示文字
 *  @param str   取消按钮标题
 *  @param tips  标题
 */
+ (void)showDlgAlert:(NSString *) label cancelButtonTitle:(NSString *)str title:(NSString *)tips;

/**
 *  @author 田鹏涛, 15-05-07 11:05:43
 *
 *  显示hud,默认延迟两秒
 *
 *  @param label 提示语
 */
+ (void)showDlg:(NSString *)label;
/**
 *  @author 田鹏涛, 15-05-07 11:05:43
 *
 *  显示hud,默认延迟两秒
 *
 *  @param view  父view
 *  @param label 提示语
 */
+ (void)showDlg:(UIView *)view  withLabel:(NSString *)label;

/**
 *  @author 田鹏涛, 15-05-07 11:05:47
 *
 *  显示hud
 *
 *  @param view       父view
 *  @param label      提示语
 *  @param afterDelay 显示多少时间
 */
+ (void)showDlg:(UIView *)view  withLabel:(NSString *)label afterDelay:(NSTimeInterval)afterDelay;

@end
