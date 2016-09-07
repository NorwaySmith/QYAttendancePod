//
//  AppDelegate.m
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "AppDelegate.h"
#import "QYInitUI.h"
#import "QYInitData.h"
#import "QYNetworkInfo.h"
#import "QYVersionHelper.h"
#import "QYURLHelper.h"
#import "QYPushHelper.h"
#import "QYMapHelper.h"
#import "QYCrashHelper.h"
#import "QYUMSocialHelper.h"
#import "QYAccountService.h"
#import "QYLoginNetworkApi.h"
//IM
#import <NewIM/QYIMReceiveMsgHelper.h>
//红点
#import "QYRedDotHelper.h"
#import "QYDialogTool.h"
#import <QYAddressBook/QYABDb.h>
#import "MobClick.h"
#import <QYDIDIReminCBB/QYDiDiRemindHeader.h>

#import <NewsCenter/QYNewsNotificationMonitor.h>
#import "QYRedDotHelper.h"
#import "QYShakeHelper.h"
#import "QYApplicationConfig.h"

#import "QYLaunchScreenViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
 *  百度地图key，乐工作
 */
//static NSString *BaiduMapKey=@"1HlCytmL9InpD02ly6Asydfq";
/**
 *  百度地图key，通讯助理
 */
//static NSString *BaiduMapKey=@"GDQ2omvzBlu9I5Z36glbwRBh";
@interface AppDelegate ()<QYLaunchScreenViewControllerDelegate>

@end

@implementation AppDelegate
#pragma mark - AppDelegate



/**
 *  程序已经启动
 *
 *  @param application   应用程序对象
 *  @param launchOptions 启动配置
 *
 *  @return 未知
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //初始化接口配置化，  需要最先配置
    [[QYURLHelper shared] initURLHelper];
	NSError *error = nil;
	
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
	[[AVAudioSession sharedInstance] setActive:YES error:&error];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"appPaths----------%@",paths);

    QYLaunchScreenViewController *launchScreenVC = [[QYLaunchScreenViewController alloc] initWithLaunchOptions:launchOptions duration:3.0 launchScreenUpdataType:QYLaunchScreenUpdataImage];
    launchScreenVC.delegate = self;
    self.window.rootViewController = launchScreenVC;
    
    //NSLog(@"测试too");
    //开启推送，需配置pushConfig中的APPKey
    [[QYPushHelper shared] configPush:launchOptions];
//    //设置状态栏样式
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//
//    //设置能够检测摇一摇事件
//    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
//    
//    //初始化摇一摇
//    [[QYShakeHelper shared] initShake];
//    
//    //开启网络监测
//    [[QYNetworkInfo shared] startMonitoring];
//    
//    //初始化接口配置化
//    [[QYURLHelper shared] initURLHelper];
//    
////    //初始化rootViewController
////    [[QYInitUI shared] initUI:launchOptions];
//    
//    //检测新版本
//    [[QYVersionHelper shared] update];
//    
//    //开启推送，需配置pushConfig中的APPKey
//    [[QYPushHelper shared] configPush:launchOptions];
//    
//    //开启百度地图，乐工作
//    [[QYMapHelper shared] configBaiduMap:kBaiduMapKey];
//    
//    //配置分享，需在QYUMSocialHelper中配置
//    [[QYUMSocialHelper shared] configUMSocial];
//    
//    //监测接收消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:QYPushHelperDidReceiveRemoteNotification object:nil];
//    
//    //创建DIDI推送监控
//    [[QYDiDiNewMsgHelper shared] openPushMonitoring];
//    
//    //创建分享号推送监控
//    [[QYNewsNotificationMonitor shared] openTheNewsNotificationMonitor];

    [self.window makeKeyAndVisible];
    
    return YES;
}
/**
 *  接收推送消息
 *
 *  @param notification NSNotification对象
 */
-(void)receiveRemoteNotification:(NSNotification *)notification{
    //如果defaultAccount为空，说明用户未登录，收到推送不作处理
    if (![[QYAccountService shared] defaultAccount]) {
        return;
    }    QYPushResult *pushResult = [notification object];
    
    // 后台情况下不请求新消息，否则影响红点
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground){
        [[QYIMReceiveMsgHelper shared] receiveMsg];
    }
    //应用中心模块红点更新
    if (pushResult.extras != nil && [pushResult.extras isKindOfClass:[NSDictionary class]]){
        QYAccount *account = [QYAccountService shared].defaultAccount;
        NSString *modeName = pushResult.extras[@"mt"];
        
       if ([modeName isEqualToString:@"redPoint"]){
            //收到嘀嘀推送，刷新嘀嘀列表
            if ([[pushResult.extras allKeys] containsObject:@"didiReplyUnReadCount"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:DiDi_GetNewReplyNoticeForDIDI object:nil];
            }
      
        }else if ([modeName isEqualToString:@"columnNews"]){
            //收到企业内刊推送，刷新企业内刊红点
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@_newsUnReadRed",account.userId]];
        }else if ([modeName isEqualToString:@"meeting"]){
            //会议监控
            UILocalNotification *noti = [[UILocalNotification alloc] init];
            //推送声音
            noti.soundName = UILocalNotificationDefaultSoundName;
            //内容
            noti.alertBody = @"会议已开始，进入乐工作查看参会人员";
            //添加推送到uiapplication
            UIApplication *app = [UIApplication sharedApplication];
            [app scheduleLocalNotification:noti];
        }else if ([modeName isEqualToString:@"moduleChange"]) {
            //工作模块变化
            [self updateAccountUserRoleMap];
        }
    }
}


/**
 *  程序已经进入后台
 *
 *  @param application 应用程序对象
 */
- (void)applicationDidEnterBackground:(UIApplication *)application{
    //接收IM消息
    [[QYIMReceiveMsgHelper shared] receiveMsg];
    //配置程序角标
    [self configApplicationIconBadgeNumber];
}


/**
 *  程序已经变为活跃状态
 *
 *  @param application 应用程序对象
 */
- (void)applicationDidBecomeActive:(UIApplication *)application{
//    [[QYInitUI shared] setTagsAndAlias:NO];

    //当前登录账户
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    //如果未登录、return
    if(!account){
        return;
    }
    //获取所有红点数
    [[QYRedDotHelper shared] allRedPointFromNetwork];
    //接收IM消息
    [[QYIMReceiveMsgHelper shared] receiveMsg];
    //清空极光中的未读数
    [[QYPushHelper shared] setBadge:0];
}

/**
 *  程序已经结束
 *
 *  @param application 应用程序对象
 */
- (void)applicationWillTerminate:(UIApplication *)application{
    //配置程序角标
    [self configApplicationIconBadgeNumber];
}

#pragma mark - Push
/**
 *  注册远程通知用设备Token
 *
 *  @param application 应用程序对象
 *  @param deviceToken 设备Token
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //向jpush注册deviceToken
    [[QYPushHelper shared] registerDeviceToken:deviceToken];
}

/**
 *  接收远程通知, tips:不要在此处监听新消息，用QYPushHelperDidReceiveRemoteNotification在自己模块中监听
 *
 *  @param application 应用程序对象
 *  @param userInfo    扩展内容
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Required
    [[QYPushHelper shared] handleRemoteNotification:userInfo];
}


/**
 *  IOS7接收远程通知, tips:不要在此处监听新消息，用QYPushHelperDidReceiveRemoteNotification在自己模块中监听
 *
 *  @param application 应用程序对象
 *  @param userInfo    扩展内容
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //如果defaultAccount为空，说明用户未登录，收到推送不作处理
    if (![[QYAccountService shared] defaultAccount]) {
        return;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // IOS 7 Support Required
    [[QYPushHelper shared] handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


/**
 *  处理开放的URL
 *
 *  @param application 应用程序对象
 *  @param url         url
 *
 *  @return 是否能够打开
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    //友盟分享
    return  [UMSocialSnsService handleOpenURL:url];
}

/**
 *  处理开放的URL
 *
 *  @param application       应用程序对象
 *  @param url               url
 *  @param sourceApplication 来源程序
 *  @param annotation        扩展字段
 *
 *  @return @return 是否能够打开
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    NSString *handleUrl = [url absoluteString];
    //跳转到嘀嘀
    if ([handleUrl isEqualToString:@"LGZTodayExtensionApp://action=GotoDidi"]) {
        [[QYShakeHelper shared] motionEnded];
        return YES;
    }
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - private methods
/**
 *  配置程序角标
 */
-(void)configApplicationIconBadgeNumber{
    //查询所有红点
    QYRedDotModel *redDotModel=[[QYRedDotHelper shared] redDotModelWithModuleCode:QYRedDotStorageLework];
    //进入后台，红点交由极光控制
    [[QYPushHelper shared] setBadge:redDotModel.redPointNum];
    //设置程序角标未读数
    [UIApplication sharedApplication].applicationIconBadgeNumber = redDotModel.redPointNum;
}

/**
 *  @author 杨峰, 16-04-13 10:04:10
 *
 *  更新用户的工作模块权限
 */
- (void)updateAccountUserRoleMap {
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    [QYLoginNetworkApi updateAccountUserRoleMapWithCompanyId:account.companyId success:^(NSString *responseString) {
        NSDictionary *userRoleMap = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [[QYAccountService shared] setDefaultAccountUserRoleMap:userRoleMap];
        //通知工作模块重新初始化数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moduleChange" object:nil];
    } failure:^(NSString *alert) {
        
    }];
}

#pragma mark - QYLaunchScreenViewControllerDelegate

- (void)launchScreenViewControllerViewDidAppear {
    //设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //设置能够检测摇一摇事件
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];

    
    //初始化摇一摇
    [[QYShakeHelper shared] initShake];
    
    //开启网络监测
    [[QYNetworkInfo shared] startMonitoring];
    
    //检测新版本
    [[QYVersionHelper shared] update];
    
    //开启百度地图，乐工作
    [[QYMapHelper shared] configBaiduMap:kBaiduMapKey];
    
    //配置分享，需在QYUMSocialHelper中配置
    [[QYUMSocialHelper shared] configUMSocial];
    
    //监测接收消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:QYPushHelperDidReceiveRemoteNotification object:nil];
    
    //创建DIDI推送监控
    [[QYDiDiNewMsgHelper shared] openPushMonitoring];
    
    //创建分享号推送监控
    [[QYNewsNotificationMonitor shared] openTheNewsNotificationMonitor];
}

- (void)launchScreenViewControllerViewDidDisappearWithLaunchOptions:(NSDictionary *)launchOptions {
    //初始化rootViewController
    [[QYInitUI shared] initUI:launchOptions];
}

@end
