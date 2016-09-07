//
//  Html5PlusRegisterViewController.m
//  QYBaseProject
//
//  Created by lin on 16/4/21.
//  Copyright © 2016年 田. All rights reserved.
//

#import "Html5PlusRegisterViewController.h"
#import "IOSTool.h"
#import "QYAccountService.h"
#import "QYNavigationViewController.h"
#import "QYURLHelper.h"

#import "PDRCore.h"
#import "PDRCoreAppFrame.h"
#import "PDRCoreAppManager.h"

#import <MBProgressHUD.h>
#import "QYLoginSwitchUnitViewController.h"
#import "QYLoginNetworkApi.h"
#import "QYInitUI.h"

#define kStatus_Height 20.0f
#define kNavigation_Height 44.0f
#define kDefault_Style_Color   [UIColor blackColor]


@interface Html5PlusRegisterViewController () {
    MBProgressHUD *_hud;
    PDRCoreAppFrame *appFrame;
}

@end

@implementation Html5PlusRegisterViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
/**
 *  webView已经加载完成
 */
- (void)PDRCoreAppFrameDidLoad {
    self.title = [appFrame.webView
                  stringByEvaluatingJavaScriptFromString:@"document.title"];
}
/**
 *  webView将要加载通知
 */
- (void)PDRCoreAppFrameWillLoad {
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
/**
 *  初始化左侧返回按钮
 */
- (void)setupBackBarButtonItem {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.titleLabel.font = [UIFont baseTextMiddle];
    [leftButton setImage:[UIImage imageNamed:@"base_navBack"]
                forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"base_navBackH"]
                forState:UIControlStateHighlighted];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton
     setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]
     forState:UIControlStateHighlighted];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton addTarget:self
                   action:@selector(leftButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 60, 30);
    UIBarButtonItem *operationLeftBar =
    [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
    if ([QYDeviceInfo systemVersion] >= 7.0) {
        negativeSpacer.width = -16;
    } else {
        negativeSpacer.width = -10;
    }
    
    self.navigationItem.leftBarButtonItems =
    @[ negativeSpacer, operationLeftBar ];
}
/**
 *  返回
 */
- (void)leftButtonClick {
    [appFrame stringByEvaluatingJavaScriptFromString:@"mui.back()"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goBackDesk)
                                                 name:@"goBackDesk"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appReadyEvent)
                                                 name:@"appReady"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeKeyboard)
                                                 name:@"closeKeyboard"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registerSuccessAndLogin:)
                                                 name:@"goLogin"
                                               object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(PDRCoreAppFrameDidLoad)
     name:PDRCoreAppFrameDidLoadNotificationKey
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(PDRCoreAppFrameWillLoad)
     name:PDRCoreAppFrameWillLoadNotificationKey
     object:nil];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    [self showWebView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *navImage = [UIImage imageWithColor:kDefault_Style_Color];
    [self.navigationController.navigationBar
     setBackgroundImage:navImage
     forBarMetrics:UIBarMetricsDefault];
}

- (void)showWebView {
    // 获取PDRCore句柄
    PDRCore *pCoreHandle = [PDRCore Instance];
    if (pCoreHandle != nil) {
        // 设置Core启动方式
        [[PDRCore Instance] startAsWebClient];
        
        //审批中的目录结构
        NSString *laterPath =
        @"Pandora/apps/serverWebview/www/register/index.html";
        NSString *pFilePath =
        [NSString stringWithFormat:@"file://%@/%@", [QYSandboxPath libraryPath],
         laterPath];
        //如果library中不存在h5文件，则加载bundle中的默认文件
        if (![[NSFileManager defaultManager] fileExistsAtPath:pFilePath]) {
            pFilePath = [NSString stringWithFormat:@"file://%@/%@",
                         [NSBundle mainBundle].bundlePath,
                         laterPath];
        }
        
        CGRect StRect = CGRectMake(0, 0, self.view.frame.size.width,
                                   [QYDeviceInfo screenHeight]-64);
        
        appFrame = [[PDRCoreAppFrame alloc] initWithName:@"serverWebview"
                                                 loadURL:pFilePath
                                                   frame:StRect];
        
        // 设置webview的Appframe
        [pCoreHandle.appManager.activeApp.appWindow registerFrame:appFrame];
        
        // 将AppFrame设置为当前View的Subview
        [self.view addSubview:appFrame];
    }
}

/**
 *  关闭键盘
 */
- (void)closeKeyboard {
    [self.view endEditing:YES];
}

- (void)appReadyEvent {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [_hud hide:YES];
    });
}

- (void)goBackDesk {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[PDRCore Instance].appManager.activeApp.appWindow closeFrame:appFrame];
        [PDRCore destoryEngine];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)registerSuccessAndLogin:(NSNotification *)notification {
    NSString *adminName = [[NSString alloc]
                            initWithString:[[notification userInfo] objectForKey:@"adminName"]];
    NSString *loginPwd = [[NSString alloc]
                         initWithString:[[notification userInfo] objectForKey:@"loginPwd"]];
    
    [QYLoginNetworkApi loginWithUserName:adminName password:loginPwd showHud:NO success:^(NSString *responseString){
        
        NSDictionary *resultArray = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        //账户数组
        NSMutableArray *accountArray = [[NSMutableArray alloc] init];
        for (NSDictionary *resultDic in resultArray) {
            QYAccount *account = [[QYAccount alloc] initWithDictionary:resultDic error:nil];
            account.password = loginPwd;
            [accountArray addObject:account];
        }
        //账户管理
        [[QYAccountService shared] createAccounts:accountArray];
        
        if ([resultArray count] >= 2){
            //多公司
            QYLoginSwitchUnitViewController *switchUnitViewController = [[QYLoginSwitchUnitViewController alloc] init];
            [self.navigationController pushViewController:switchUnitViewController animated:YES];
            switchUnitViewController.completBlock = ^ {
                //记录登录设备
                [self loginDone];
            };
        }
        else if([resultArray count] == 1){
            //单公司
            QYAccount *account = accountArray[0];
            [[QYAccountService shared] setDefaultAccount:account];
            //记录登录设备
            [self loginDone];
        }
    }passwordError:^(NSString *responseString)
     {
         //NSLog(@"密码错误");
     }networkError:^(NSString *alert)
     {
         //NSLog(@"其他错误");
     }];
}

/**
 *  登录完成，记录登录设备
 */
-(void)loginDone{
    QYAccount *account=[[QYAccountService shared] defaultAccount];
    [QYLoginNetworkApi rememberLoginDeviceWithUserId:account.userId success:^(NSString *responseString) {
        //初始化项目控制器，进入
        [[QYInitUI shared] initUI:nil];
    }failure:^(NSString *alert) {
        [QYDialogTool showDlg:NSLocalizedString(@"SSO_alertView_faildPrompt", nil)];
    }];
}

@end
