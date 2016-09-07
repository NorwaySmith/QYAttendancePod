//
//  QYVersionHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/10.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  有新版本会发这个通知
 */
static NSString *const HaveNewVersionNotification = @"com.quanya.haveNewVersionNotification";

@interface QYVersionHelper : NSObject

+ (QYVersionHelper *)shared;
/**
 *  是否有新版本
 */
@property(nonatomic,assign)BOOL isHaveVersion;
/**
 *  后台被动检测更新
 */
- (void)update;
/**
 *  用户主动更新
 */
- (void)initiativeUpdate;
//当前版本号
-(NSString*)currVersion;

//当前build号
-(NSString*)currBuild;

@end
