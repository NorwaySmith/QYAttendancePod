//
//  QYCrashHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/26.
//  Copyright (c) 2015年 田. All rights reserved.
//  开启Crash日志收集

#import <Foundation/Foundation.h>

@interface QYCrashHelper : NSObject
+ (QYCrashHelper *)shared;

//需废弃
/**
 * 开启Crash日志收集
 *
 *  @param key 友盟key
 */
//-(void)configCrash:(NSString*)key;

@end
