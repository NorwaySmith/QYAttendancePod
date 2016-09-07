//
//  QYInitUI.m
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYInitUI.h"
#import "QYNavigationViewController.h"
#import "QYLoginViewController.h"
#import "QYTabBarController.h"
#import "AppDelegate.h"
#import "QYAccountService.h"
#import "QYURLHelper.h"
#import "QYNetworkJsonProtocol.h"
#import "QYVersionHelper.h"
#import <QYAddressBook/QYABBasicDataHelper.h>
#import <QYAddressBook/QYABDb.h>
#import "QYRedDotHelper.h"
#import "QYPushHelper.h"
#import "QYLoginNetworkApi.h"
#import "QYUserRoleHelper.h"
#import <QYDIDIReminCBB/QYDiDiNewMsgHelper.h>
#import <NewsCenter/QYNewsNotificationMonitor.h>
#import "QYH5ViewController.h"
#import "Html5PlusWorkflowViewController.h"
#import <NoticeCBB/QYNoticeListViewController.h>
#import <NoticeCBB/QYNoticeDetailsViewController.h>
#import "QYGuidePageViewController.h"
#import <NewIM/QYIMInitGroupHelper.h>
#import <NewIM/QYIMReceiveMsgHelper.h>
#import <NewIM/QYIMConstant.h>
#import <NoticeMsgCBB/QYSMSMobanHelper.h>
#import <Meeting/QYMeetingMonitorViewController.h>
#import <Meeting/QYMeetingMemoryBallManager.h>


//重新登录提示tag
static NSInteger ReloginAlertViewTag = 1;

#define klaunchScreenLoadImageDicUrl       @"http://101.200.31.143/zq-kxh/mobile/getSetting.action?"

@interface QYInitUI()
/**
 *  是否显示重新登录提示
 */
@property(nonatomic,assign)BOOL isShowReloginAlert;
/**
 *  需要在登录页面显示的手机号
 */
@property(nonatomic,copy)NSString *phone;

@end

@implementation QYInitUI
/**
 *  获取QYInitUI单例对象
 *
 *  @return QYInitUI单例对象
 */
+ (QYInitUI *)shared
{
    static QYInitUI *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
    {
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(instancetype)init{
    self = [super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(basicDataDone) name:kABBasicDataDoneNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(basicDataDone) name:kABBasicDataFaildNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRelogin) name:kReloginNotification object:nil];
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
/**
 *  初始化rootViewController。如果默认账户为空，则初始化登录，否则初始化tabbar
 *
 *  @param launchOptions 入口类中启动配置
 */
- (void)initUI:(NSDictionary *)launchOptions
{
    //判断是否是第一打开使用
//    NSUserDefaults *fristInstall = [NSUserDefaults standardUserDefaults];
//    if ([[fristInstall objectForKey:@"fristInstall"] boolValue] == NO){
//        //加载欢迎页
//        QYGuidePageViewController *guidePageVC = [[QYGuidePageViewController alloc] init];
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        app.window.rootViewController = guidePageVC;
//        
//        [fristInstall setObject:@"1" forKey:@"fristInstall"];
//        [fristInstall synchronize];
//    }else{
         //如果已登录
        //NSLog(@"-----------011111判断登录状态");
        if ([[QYAccountService shared] defaultAccount]){
            //NSLog(@"-----------022222已登录");

            //设置推送tag和别名
            [self setTagsAndAlias:NO];

            //初始化tabBar
            QYTabBarController *tabBarController = [[QYTabBarController alloc] init];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.window.rootViewController = tabBarController;
            [[QYTabBarController currTabBar] setSelectedIndex:0];
            
            //隐藏登录
//            [self hideLoginIsClearOldData:NO];
            
            //开始监控悬浮球推送
            [[QYMeetingMemoryBallManager shared] startMonitorPush];
            [[QYMeetingMemoryBallManager shared] checkCurrentMeetingStatus];
            
            //获取所有红点
            [[QYRedDotHelper shared] allRedPointFromNetwork];
            //加载基础数据
            [self loadData];

            //判断本地是否保存最新新闻，如果没有，获取最新新闻
            if (![[QYNewsNotificationMonitor shared] getDataForNewRemind]){
                [[QYNewsNotificationMonitor shared] ConfirmReminderNoticeForNEW];
            }
            
            //点击推送后跳转
            if ([launchOptions isKindOfClass:[NSDictionary class]] && launchOptions != nil){
                NSDictionary *remoteLaunchOption = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
                if (remoteLaunchOption){
                    NSString *mtString = [remoteLaunchOption objectForKey:@"mt"];
                    
                    //审批跳转
                    if ([mtString isEqualToString:@"addWait"]){
                        [[QYTabBarController currTabBar] setSelectedIndex:2];
                        
                        Html5PlusWorkflowViewController *WorkflowVC = [[Html5PlusWorkflowViewController alloc] init];
                        
                        UINavigationController *navController = [[QYTabBarController currTabBar].viewControllers objectAtIndex:2];
                        [navController pushViewController:WorkflowVC animated:NO];
                    }
                    //通知公告跳转
                    else if ([mtString isEqualToString:@"notice"]){
                        NSString *recordId = [remoteLaunchOption objectForKey:@"recordId"];

                        NSDictionary *noticeDic;
                        NSString *attmentIds = [remoteLaunchOption objectForKey:@"attmentIds"];
                        if ([attmentIds isNotNil])
                        {
                            noticeDic = [NSDictionary dictionaryWithObjects:@[recordId, attmentIds] forKeys:@[@"notifyId", @"attmentIds"]];
                        }
                        else
                        {
                            noticeDic = [NSDictionary dictionaryWithObjects:@[recordId] forKeys:@[@"notifyId"]];
                        }
                        
                        [[QYTabBarController currTabBar] setSelectedIndex:2];
                        UINavigationController *navController = [[QYTabBarController currTabBar].viewControllers objectAtIndex:2];
                        
                        NSMutableArray *viewController = [NSMutableArray arrayWithArray:navController.viewControllers];
                        
                        QYNoticeListViewController *noticeListVC = [[QYNoticeListViewController alloc] init];
                        QYNoticeDetailsViewController *noticeVC = [[QYNoticeDetailsViewController alloc] init];
                        noticeVC.noticeData = noticeDic;
                        
                        [viewController addObject:noticeListVC];
                        [viewController addObject:noticeVC];
                        [navController setViewControllers:viewController animated:NO];
                        
                    }
                    //问卷跳转
                    else if ([mtString isEqualToString:@"addQuestion"]){
                        [[QYTabBarController currTabBar] setSelectedIndex:2];
                        
                        QYAccount *account = [[QYAccountService shared] defaultAccount];
                        
                        NSString *webURL = [[QYURLHelper shared] getUrlWithModule:@"question" urlKey:@"question"];
                        
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@userId=%@&companyId=%@&_clientType=wap",webURL,account.userId,account.companyId]];
                        
                        QYH5ViewController *h5ViewController = [[QYH5ViewController alloc] initWithUrl:url];
                        
                        UINavigationController *navController = [[QYTabBarController currTabBar].viewControllers objectAtIndex:2];
                        [navController pushViewController:h5ViewController animated:YES];
                    }
                    else if([mtString isEqualToString:@"DiDi"]){
                        //嘀嘀跳转
                        [[QYTabBarController currTabBar] setSelectedIndex:1];
                    }
                    else if ([mtString isEqualToString:@"meeting"]){
                        //电话会议监控推送
                        [[QYTabBarController currTabBar] setSelectedIndex:2];
                        NSString *meetingId = [remoteLaunchOption objectForKey:@"meetingId"];
                        QYMeetingMonitorViewController *monitorViewController = [[QYMeetingMonitorViewController alloc] init];
                        monitorViewController.meetingId = meetingId;
                        UINavigationController *navController = [[QYTabBarController currTabBar].viewControllers objectAtIndex:2];

                        [navController pushViewController:monitorViewController animated:NO];
                    }
                    else if ([mtString isEqualToString:@"moduleChange"]) {
                        //工作模块变化
                        [self updateAccountUserRoleMap];
                    }
                }
            }
            
            //发送从数据库读取 IM列表数据通知
            [[NSNotificationCenter defaultCenter] postNotificationName:IM_IMInitGroupSuccess object:nil];
            
            /**
             *  @author yang, 16-04-01 10:03:30
             *
             *  自定义闪屏更换需求，每次都请求接口
             */
            [self updataStartpageDic];
        }
        //如果未登录
        else{
            //---有疑问待解决
//            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//            if ([userDefault objectForKey:@"RecordPhone"]&&[userDefault objectForKey:@"password"]){
//                [self hideLoginIsClearOldData:YES];
//                return;
//            }
            QYLoginViewController *loginViewController = [[QYLoginViewController alloc] init];
            QYNavigationViewController *navigationViewController = [[QYNavigationViewController alloc] initWithRootViewController:loginViewController];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.window.rootViewController = navigationViewController;
            loginViewController.phone = _phone;
        }
//    }
}

#pragma mark - 数据更新
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

/**
 *  更新通讯录基础数据 语音通知模板
 */
-(void)check{
    [[QYSMSMobanHelper shared] checkoutSMSMobanModel];
    
    [[QYABBasicDataHelper shared] checkBasicData:QYABBasicDataModeBigData];
}

/**
 *  更新IM数据
 */
-(void)basicDataDone{
    [[QYIMInitGroupHelper shared] initGroup];
}

/**
 *  设置别名和tag
 *
 *  @param isTextServer 是否测试服务器
 */
-(void)setTagsAndAlias:(BOOL)isTextServer{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    
    //测试版加test_
    if (isTextServer == YES){
        [[QYPushHelper shared] setTags:
         [NSSet setWithObjects:
          [NSString stringWithFormat:@"test_company_%@",account.companyId],
          [NSString stringWithFormat:@"test_company_ios_%@",account.companyId],
          [NSString stringWithFormat:@"test_ios_user_%@",account.userId],
          [NSString stringWithFormat:@"test_user_ios_%@",account.userId],
          [NSString stringWithFormat:@"%@",account.phone],[NSString stringWithFormat:@"test_user_phone_%@",account.phone],
          [NSString stringWithFormat:@"test_notice_user_%@",account.userId],
          [NSString stringWithFormat:@"test_ios_user_%@",account.userId],nil]
                                 alias:[NSString stringWithFormat:@"i%@",account.userId] success:^
         {
         }failure:^(int code, NSString *log)
         {
         }];
    }
    //发布正式版请将test_去掉
    else{
        [[QYPushHelper shared] setTags:
         [NSSet setWithObjects:[NSString stringWithFormat:@"company_%@",account.companyId],
          [NSString stringWithFormat:@"company_ios_%@",account.companyId],
          [NSString stringWithFormat:@"ios_user_%@",account.userId],
          [NSString stringWithFormat:@"user_ios_%@",account.userId],
          [NSString stringWithFormat:@"%@",account.phone],
          [NSString stringWithFormat:@"user_phone_%@",account.phone],
          [NSString stringWithFormat:@"notice_user_%@",account.userId],
          [NSString stringWithFormat:@"ios_user_%@",account.userId],nil]
                                 alias:[NSString stringWithFormat:@"i%@",account.userId] success:^
         {
             //NSLog(@"#else===成功");
         }
         failure:^(int code, NSString *log)
         {
             //NSLog(@"#else===失败");
         }];
    }
}

/**
 *  隐藏登录并清空覆盖安装时的老数据
 *
 *  @param isClear isClear 是否为版本更新，清空覆盖安装时的老数据
 */
-(void)hideLoginIsClearOldData:(BOOL)isClear{
    NSString *userName;
    NSString *password;
    NSString *companyId;
    NSString *userId;
    
    if (isClear == YES){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        userName = [userDefault objectForKey:@"RecordPhone"];
        password = [userDefault objectForKey:@"password"];
        companyId = [userDefault objectForKey:@"companyId"];
        userId = [userDefault objectForKey:@"userId"];
    }
    else
    {
        QYAccount *account = [[QYAccountService shared] defaultAccount];
        userName = account.phone;
        password = account.password;
        companyId = account.companyId;
    }
    
    [QYLoginNetworkApi loginWithUserName:userName password:password showHud:NO success:^(NSString *responseString){
         if (isClear==YES){
             //清空数据库
             [QYABDb removeDb];
             [self removeIMDbWithUserId:userId];
             
             NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
             [userDefault removeObjectForKey:@"userId"];
             [userDefault removeObjectForKey:@"RecordPhone"];
             [userDefault removeObjectForKey:@"password"];
             [userDefault removeObjectForKey:@"companyId"];
             [userDefault synchronize];
         }
         NSError *error = nil;
         
         NSDictionary *resultArray = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
         
         //账户数组
         NSMutableArray *accountArray = [[NSMutableArray alloc] init];
         //权限数组
         NSMutableArray *userRoleArray = [[NSMutableArray alloc] init];
         
         for (NSDictionary *resultDic in resultArray)
         {
             QYAccount *account = [[QYAccount alloc] initWithDictionary:resultDic error:&error];
             account.password = password;
             [accountArray addObject:account];
             //权限数组
             NSMutableDictionary *userRoleMap = [[NSMutableDictionary alloc]initWithDictionary:resultDic[@"userRoleMap"]];
             [userRoleMap setObject:account.companyId forKey:@"companyId"];
             [userRoleArray addObject:userRoleMap];
         }
         //账户管理
         [[QYAccountService shared] createAccounts:accountArray];
         //用户权限管理
         [[QYUserRoleHelper shared] createUserRoles:userRoleArray];
         
         if ([resultArray count] >= 2){
             //多公司
             for (QYAccount *account in accountArray){
                 if ([account.companyId longLongValue] == [companyId longLongValue])
                 {
                     [[QYAccountService shared] setDefaultAccount:account];
                 }
             }
         }
         else if([resultArray count] == 1){
             //单公司
             QYAccount *account = accountArray[0];
             [[QYAccountService shared] setDefaultAccount:account];
         }
         else{
             
         }
         [self loadData];
         if (isClear == YES)
         {
             QYTabBarController *tabBarController = [[QYTabBarController alloc] init];
             AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
             app.window.rootViewController = tabBarController;
             [[QYTabBarController currTabBar] setSelectedIndex:0];
         }

     }
     passwordError:^(NSString *responseString)
     {
         [self popLogin];
     }
     networkError:^(NSString *alert)
     {
         [self loadData];
     }];
}
-(void)networkRelogin{
    if (_isShowReloginAlert) {
        return;
    }
    _isShowReloginAlert = YES;
    self.phone=[[QYAccountService shared] defaultAccount].phone;
    UIAlertView *alertView=[[UIAlertView alloc]
                            initWithTitle:nil
                            message:NSLocalizedString(@"SSO_alertView_prompt", @"")
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:NSLocalizedString(@"SSO_alertView_ok", @""), nil];
    alertView.tag=ReloginAlertViewTag;
    [alertView show];
}
/**
 *  弹出登录
 */
-(void)popLogin{
    [[QYAccountService shared] removeAllAccount];
    [[QYInitUI shared] initUI:nil];
}

/**
 *  隐藏登陆完成时，加载数据
 */
-(void)loadData{
    //更新版本
    [[QYVersionHelper shared] update];
    //请求历史消息
    [[QYIMReceiveMsgHelper shared] receiveMsg];
    //更新基础数据
    [self performSelector:@selector(check) withObject:nil afterDelay:0.2];
    
}

/**
 *  @author 16-04-01 10:04:43
 *
 *  自定义闪屏更新相关数据
 */
- (void)updataStartpageDic {
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [[QYNetworkJsonProtocol alloc] init];
    NSDictionary *parameters = @{@"_clientType":@"wap", @"companyId":account.companyId};
    [networkHelper POST:klaunchScreenLoadImageDicUrl parameters:parameters success:^(QYNetworkResult *result) {
        if(result.statusCode == NetworkResultStatusCodeSuccess) {
            // 请求成功处理
            NSDictionary *dic = [self JSONObjectData:[result.result dataUsingEncoding:NSUTF8StringEncoding]];
            //NSLog(@"dic:%@---isExpire:%@===startpageUsed:%@---startpagePhoto:%@===startpageUrl:%@===companyId:%@", dic, [dic objectForKey:@"isExpire"], [dic objectForKey:@"startpageUsed"], [dic objectForKey:@"startpagePhoto"], [dic objectForKey:@"startpageUrl"], [dic objectForKey:@"companyId"]);
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"klaunchScreenForStartpageDic"];
        }
    } failure:^(NetworkErrorType errorType) {
        // 文字信息请求失败
    }];
}

/**
 *  序列化JSON数据为对象模型
 *
 *  @param data JSON数据流
 *
 *  @return 序列化后的对象模型
 */
-(id)JSONObjectData: (NSData*)data{
    @try {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (jsonObject == nil && error) {
            return nil;
        }
        return jsonObject;
    }
    @catch (NSException *exception) {
        //NSLog(@"exception: %@", exception);
        return nil;
    }
}

#pragma mark - 老版本兼容
/**
 *  老版本im数据库路径
 */
-(NSString *)imDbFilePathWithUserId:(NSString *)userId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *userfilePaths = [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"%@",
                             userId]];
    return userfilePaths;
}

/**
 *  删除老版本IM数据库
 */
-(void)removeIMDbWithUserId:(NSString *)userId{
      [[NSFileManager defaultManager] removeItemAtPath:[self imDbFilePathWithUserId:userId] error:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==ReloginAlertViewTag) {
        _isShowReloginAlert=NO;
        [self popLogin];
    }
}


@end

