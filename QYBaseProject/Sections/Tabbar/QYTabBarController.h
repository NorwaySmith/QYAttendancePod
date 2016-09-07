//
//  QYTabBarController.h
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  程序登录完成tab页
 */
#import <UIKit/UIKit.h>

@interface QYTabBarController : UITabBarController

/**
 *  得到当前tabbar
 *
 *  @return 当前程序tabbar
 */
+ (QYTabBarController*)currTabBar;

/**
 *  更新红点状态
 */
- (void)updateNotificationBadgeVisibility;

@end
