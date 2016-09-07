//
//  QYABProtocol.h
//  QYBaseProject
//
//  Created by lin on 15/7/8.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  通讯录对外提供协议
 */
#import <Foundation/Foundation.h>
#import "QYABUserModel.h"
#import "QYABEnum.h"
#import <UIKit/UIKit.h>
@protocol QYABProtocol <NSObject>
@optional

/**
 *  新选择人员，完成选择
 *
 *  @param users 本次选择的人员
 */
- (void)pickerDidFinishedSelectedWithUsers:(NSArray *)users;
/**
 *  im 聊天
 */
- (void)chatWithUserModel:(QYABUserModel *)userModel;

/**
 *   邀请下载乐工作
 */
- (void)sendAsk;

/**
 *  查看通话记录
 */
- (void)lookCallRecordWithPhone:(NSString *)phone;

/**
 *  goto拨号页面
 */
- (void)gotoCallNumViewController;


/**
 *  goto消息
 *
 *  @param userModel 人员
 */
- (void)gotoIMWithUserModel:(QYABUserModel *)userModel;

/**
 *  跳转到新增嘀嘀页面
 *
 *  @param userModel 人员
 */
- (void)gotoDIDIOnlyOneWithUserModel:(QYABUserModel *)userModel nav:(UINavigationController *)nav;



@end
