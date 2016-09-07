//
//  QYRDPushMonitoring.m
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYRDPushMonitoring.h"
#import "QYAccountService.h"
#import "QYRedDotStorage.h"
#import "QYRedDotHelper.h"

@implementation QYRDPushMonitoring

+ (QYRDPushMonitoring *)shared
{
    static dispatch_once_t pred;
    static QYRDPushMonitoring *sharedInstance = nil;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QYPushHelperDidReceiveRemoteNotification object:nil];
}

/**
 *  打开红点推送监听
 */
-(void)openPushMonitoring
{
    //监测消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:QYPushHelperDidReceiveRemoteNotification object:nil];
}
/**
 *  监测推送消息
 *
 *  @param notification 通知对象
 */
-(void)receiveRemoteNotification:(NSNotification *)notification
{
    
    QYPushResult *pushResult = [notification object];
    //    NSString *mt = pushResult.extras[@"mt"];

    //如果defaultAccount为空，说明用户未登录，收到推送不作处理
    if (![[QYAccountService shared] defaultAccount])
    {
        return;
    }

    
    if (pushResult.extras[@"mt"]&&[pushResult.extras isKindOfClass:[NSDictionary class]]) {
        NSString *mt = pushResult.extras[@"mt"];
        if ([mt isEqualToString:@"redPoint"])
        {
            for (NSString *key in [pushResult.extras allKeys])
            {
                if (![key isEqualToString:@"ios"] && ![key isEqualToString:@"mt"])
                {
                    [[QYRedDotStorage shared] storageRedPointNum:[pushResult.extras[key] integerValue] moduleCode:key];
                    [self postLocalNotification:key];
                }
            }
        }
    }
}

-(void)postLocalNotification:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYRedDotChangeNotification object:object];
}


@end
