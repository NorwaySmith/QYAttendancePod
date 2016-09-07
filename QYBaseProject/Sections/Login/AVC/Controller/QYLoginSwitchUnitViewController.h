//
//  QYLoginSwitchUnitViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/6/3.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  多单位切换viewController
 */
#import "QYTableViewController.h"

@interface QYLoginSwitchUnitViewController : QYTableViewController
/**
 *  切换完成回调
 */
@property(nonatomic,copy)void(^completBlock)();

@end
