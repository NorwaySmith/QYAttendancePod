//
//  QYPushHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/25.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYPushHelper.h"
#import "APService.h"

@interface QYPushHelper()

@property (nonatomic , copy) QYPushHelperSetTagSuccess setTagSuccess;
@property (nonatomic , copy) QYPushHelperSetTagFailure setTagFailure;

@end

@implementation QYPushHelper

NSString *const QYPushHelperDidReceiveRemoteNotification = @"com.quanya.QYPushHelper.RemoteNotification";


+ (QYPushHelper *)shared
{
    static dispatch_once_t pred;
    static QYPushHelper *sharedInstance = nil;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//配置推送
-(void)configPush:(NSDictionary *)launchOptions
{
    [self configJPush:launchOptions];
}


-(void)configJPush:(NSDictionary *)launchOptions;
{
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        //可以添加自定义categories (注册远程通知)
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else
    {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


#pragma mark - PushNotification

- (void)networkDidSetup:(NSNotification *)notification
{
    //NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification
{
    //NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification
{
    //NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification
{
    //NSLog(@"已登录");
}

/**
 *  非APNS消息
 *
 *  @param notification
 */
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    QYPushResult *pushResult = [[QYPushResult alloc] init];
    pushResult.pushType = QYPushTypeMessage;
    pushResult.content = userInfo[@"content"];
    pushResult.extras = userInfo[@"extras"];
    
    [self didReceiveRemoteNotification:pushResult];
}

#pragma mark - Push
-(void)registerDeviceToken:(NSData *)deviceToken
{
    // Required
    [APService registerDeviceToken:deviceToken];
}

/**
 *  APNS消息
 *
 *  @param notification
 */
- (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    // Required
    [APService handleRemoteNotification:remoteInfo];
    
    QYPushResult *pushResult = [[QYPushResult alloc] init];
    pushResult.pushType = QYPushTypeAPNS;
    pushResult.msgid = [remoteInfo[@"_j_msgid"] longLongValue];
    pushResult.content = remoteInfo[@"aps"][@"alert"];
    
    NSMutableDictionary *extras = [[NSMutableDictionary alloc] init];
    [remoteInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if (![key isEqualToString:@"aps"]&&![key isEqualToString:@"_j_msgid"])
        {
            [extras setObject:obj forKey:key];
        }
    }];
    
    pushResult.extras = extras;
    pushResult.badge = [remoteInfo[@"aps"][@"badge"] integerValue];
    pushResult.sound = remoteInfo[@"aps"][@"sound"];
    
    [self didReceiveRemoteNotification:pushResult];
}

- (BOOL)setBadge:(NSInteger)value
{
    return [APService setBadge:value];
}

/**
 *  处理接收的推送消息
 *
 *  @param userInfo 接收的推送消息
 */
-(void)didReceiveRemoteNotification:(QYPushResult*)pushResult
{
    [[NSNotificationCenter defaultCenter] postNotificationName:QYPushHelperDidReceiveRemoteNotification object:pushResult userInfo:nil];
}

- (void)setTags:(NSSet *)tags alias:(NSString *)alias
{
    [APService setTags:tags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}

- (void)setTags:(NSSet *)tags alias:(NSString *)alias success:(QYPushHelperSetTagSuccess)success failure:(QYPushHelperSetTagFailure)failure
{
    self.setTagSuccess = success;
    self.setTagFailure = failure;
    
    [self setTags:tags alias:alias];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    //NSLog(@"设置tag Error： rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
    switch (iResCode)
    {
        case 0:
            if (_setTagSuccess)
            {
                _setTagSuccess();
            }
            break;
        case 6001:
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"无效的设置，tag/alias 不应参数都为 null");
            }
            break;
        case 6002:
            [self setTags:tags alias:alias];
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"设置超时，正在重试");
            }
            break;
        case 6003:
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"alias 字符串不合法\n有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。");
            }
            break;
        case 6004:
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"alias超长。最多 40个字节");
            }
            break;
        case 6005:
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"某一个 tag 字符串不合法");
            }
            break;
        case 6006:
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"某一个 tag 超长。一个 tag 最多 40个字节");
            }
            break;
        case 6007:
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"tags 数量超出限制。最多 100个");
            }
            break;
        case 6008:
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"tag/alias 超出总长度限制");
            }
            break;
        case 6011:
            if (_setTagFailure)
            {
                _setTagFailure(iResCode,@"10s内设置tag或alias大于10次");
            }
            break;
        default:
            break;
    }
}


@end
