//
//  QYUMSocialHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/26.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYUMSocialHelper.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialData.h"

#import "MobClick.h"
#import "QYApplicationConfig.h"


@implementation QYUMSocialHelper

+ (QYUMSocialHelper *)shared
{
    static dispatch_once_t pred;
    static QYUMSocialHelper *sharedInstance = nil;
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)configUMSocial
{
    [self configCrash:kUMKey];

    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUMKey];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWXAppId appSecret:kWXAppSecret url:@"http://www.le-work.com/"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppKey url:@"http://www.le-work.com/"];
    
    //设置支持没有客户端情况下使用SSO授权
//    [UMSocialQQHandler setSupportWebView:YES];
    
//    打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址,需要 #import "UMSocialTencentWeiboHandler.h"
//        [UMSocialTencentData openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //打开人人网SSO开关,需要 #import "UMSocialRenrenHandler.h"
//    [UMSocialRenrenHandler openSSO];
    
    //设置易信Appkey和分享url地址,注意需要引用头文件 #import UMSocialYixinHandler.h
//    [UMSocialYixinHandler setYixinAppKey:@"yx35664bdff4db42c2b7be1e29390c1a06" url:@"http://www.umeng.com/social"];
    
    //设置来往AppId，appscret，显示来源名称和url地址，注意需要引用头文件 #import "UMSocialLaiwangHandler.h"
//    [UMSocialLaiwangHandler setLaiwangAppId:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" appDescription:@"友盟社会化组件" urlStirng:@"http://www.umeng.com/social"];
    
}
-(void)configCrash:(NSString*)key{
    //友盟
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];
    
    //BATCH:程序变为激活状态时上传
    [MobClick startWithAppkey:key reportPolicy:BATCH  channelId:@"蒲公英发布版"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}





@end
