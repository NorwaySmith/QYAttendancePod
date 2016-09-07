//
//  QYCrashHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/26.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYCrashHelper.h"
#import "MobClick.h"
@implementation QYCrashHelper
+ (QYCrashHelper *)shared{
    static dispatch_once_t pred;
    static QYCrashHelper *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
//-(void)configCrash:(NSString*)key{
//    //友盟
//    
//    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:YES];
//    [MobClick startWithAppkey:key reportPolicy:REALTIME  channelId:@"蒲公英发布版"];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
//    [MobClick updateOnlineConfig];  //在线参数配置
//}

@end
