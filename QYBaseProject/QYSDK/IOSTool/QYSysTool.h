//
//  QYSysTool.h
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//


#import  "IOSTool.h"
@interface QYSysTool : NSObject
+ (QYSysTool *)sharedInstance;
///////////////////////
//发送邮件
+ (void)sendMail:(NSString *)mail;
//打电话
+ (void)makePhoneCall:(NSString *)tel;
//发短信
+ (void)sendSMS:(NSString *)tel;
//打开URL
+ (void)openURLWithSafari:(NSString *)url;

@end
