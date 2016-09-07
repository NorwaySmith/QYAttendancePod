//
//  QYSMSMobanHelper.h
//  QYBaseProject
//
//  Created by lin on 16/1/30.
//  Copyright (c) 2016年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const SMS_MobanModel          = @"sms_mobanModel";

@interface QYSMSMobanHelper : NSObject

+ (QYSMSMobanHelper *)shared;

/**
 *  更新下载语音通知模板数据
 */
- (void)checkoutSMSMobanModel;

/**
 *  重置语音通知模板数据
 */
-(void)resetSMSMobanData;

@end
