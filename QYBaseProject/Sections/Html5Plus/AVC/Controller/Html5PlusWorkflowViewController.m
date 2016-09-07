//
//  ViewController.h
//  Pandora
//
//  Created by zhaotengfei on 15/9/24.
//  Copyright (c) 2015年 田. All rights reserved.//
//
#import "Html5PlusWorkflowViewController.h"
#import "IOSTool.h"
#import "QYAccount.h"
#import "QYAccountService.h"
#import "QYNavigationViewController.h"
#import "QYRedDotHelper.h"
#import "QYURLHelper.h"

#import "PDRCore.h"
#import "PDRCoreAppFrame.h"
#import "PDRCoreAppManager.h"

#import <MBProgressHUD.h>
#import <QYCommonNumber/QYCommonPhoneViewController.h>

#import "QYSandboxPath.h"
#import "UIImage+ToolExtend.h"
#import <QYAddressBook/QYAddressHeader.h>
#define kStatus_Height 20.0f
#define kNavigation_Height 44.0f
#define kDefault_Style_Color                                                   \
  [UIColor colorWithRed:123.0 / 255.0                                          \
                  green:190.0 / 255.0                                          \
                   blue:107.0 / 255.0                                          \
                  alpha:1.0]

@interface Html5PlusWorkflowViewController () <QYABProtocol> {
  MBProgressHUD *_hud;
  PDRCoreAppFrame *appFrame;
}

@end

@implementation Html5PlusWorkflowViewController
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
                                           selector:@selector(selectUsers:)
                                               name:@"callUserPicker"
                                             object:nil];

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
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(selectUsers:) name:@"callUserPicker" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(selectGroup:) name:@"PGSlecteGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(goBackDesk) name:@"goBackDesk" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(appReadyEvent) name:@"appReady" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
selector:@selector(PDRCoreAppFrameDidLoad)
name:PDRCoreAppFrameDidLoadNotificationKey object:nil];

    CGFloat top = 0.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *statusbarView = [[UIView alloc]
initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
self.view.bounds.size.width, kStatus_Height)];
        [statusbarView setBackgroundColor:kDefault_Style_Color];
        [self.view addSubview:statusbarView];
        top = kStatus_Height;
    }

    _pContainer = [[UIView alloc]
initWithFrame:CGRectMake(self.view.bounds.origin.x, top,
self.view.bounds.size.width, self.view.bounds.size.height - top)];
    [self.view addSubview:_pContainer];

    _navigationView = [[UIView alloc]
initWithFrame:CGRectMake(self.view.bounds.origin.x, top,
self.view.bounds.size.width, kNavigation_Height)];
    [_navigationView setBackgroundColor:kDefault_Style_Color];
    [_navigationView setAlpha:1.0];
    [self.view addSubview:_navigationView];

    UILabel *label = [[UILabel alloc] initWithFrame:_navigationView.bounds];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"审批"];
    [label setTextColor:[UIColor whiteColor]];
    [_navigationView addSubview:label];

    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];

    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        //正常启动runtime
        [[PDRCore Instance] setContainerView:_pContainer];
        [[PDRCore Instance] startAsAppClient];
        NSString *pWWWPath = [[[NSBundle mainBundle] bundlePath]
stringByAppendingPathComponent:@"Pandora/apps/workflow/www"];
        [[[PDRCore Instance] appManager] openAppAtLocation:pWWWPath
withIndexPath:@"logined/fixedflow/index.html" withArgs:nil withDelegate:nil];
    });
}
*/
- (void)showWebView {
  // 获取PDRCore句柄
  PDRCore *pCoreHandle = [PDRCore Instance];
  if (pCoreHandle != nil) {
    // 设置Core启动方式
    [[PDRCore Instance] startAsWebClient];

    //审批中的目录结构
    NSString *laterPath =
        @"Pandora/apps/workflowWebview/www/logined/fixedflow/index.html";
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

    appFrame = [[PDRCoreAppFrame alloc] initWithName:@"workflowWebView"
                                             loadURL:pFilePath
                                               frame:StRect];

    // 设置webview的Appframe
    [pCoreHandle.appManager.activeApp.appWindow registerFrame:appFrame];

    // 将AppFrame设置为当前View的Subview
    [self.view addSubview:appFrame];
  }
}

/*
- (void)appReadyEvent {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);

    dispatch_after(time, dispatch_get_main_queue(), ^{
//        [_navigationView setAlpha:0.0];
        [_hud hide:YES];
    });
}
*/

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
    [[QYRedDotHelper shared] allRedPointFromNetwork];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[PDRCore Instance].appManager.activeApp.appWindow closeFrame:appFrame];
    [PDRCore destoryEngine];
    [self.navigationController popViewControllerAnimated:YES];
  });
}

- (void)selectUsers:(NSNotification *)notification {
  __weak PGPlugin *plugin = (PGPlugin *)[notification object];
  NSString *callbackId = [[NSString alloc]
      initWithString:[[notification userInfo] objectForKey:@"callbackId"]];
  NSString *userIds = [[NSString alloc]
      initWithString:[[notification userInfo] objectForKey:@"userIds"]];

  NSMutableArray *users = [[NSMutableArray alloc] init];
  if (userIds) {
    [users addObjectsFromArray:[QYABDb groupUserWithUserIdstr:userIds]];
  }

  QYABPickerApi *picker = [[QYABPickerApi alloc]
      initSinglePickerWithDelegate:self
                     permitModules:@[ AddressBookUnits, AddressBookCommonUser ]
                isShowHiddenPerson:NO
                        moduleName:AddressBookPicker_Base];

  [picker setSelectedUsers:nil];
  [picker setLockedUsers:nil];
  [picker setCompleteCallback:^(NSArray *userArray) {
    if (plugin && callbackId) {
      NSMutableArray *personDetialDataArray = [[NSMutableArray alloc] init];
      for (QYABUserModel *userModel in userArray) {
        NSString *urlString =
            [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile"
                                            urlKey:@"headPictureView"];
        NSString *photoUrlString;
        if ([userModel.photo isNotNil]) {
          photoUrlString =
              [NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",
                                         urlString, userModel.photo];
        } else {
          photoUrlString = @"";
        }

        NSDictionary *dic = [[NSDictionary alloc]
            initWithObjects:[NSArray arrayWithObjects:userModel.userName,
                                                      userModel.userId,
                                                      photoUrlString, @"", nil]
                    forKeys:[NSArray arrayWithObjects:@"userName", @"userId",
                                                      @"userPhoto", @"picType",
                                                      nil]];
        [personDetialDataArray addObject:dic];
      }

      if (personDetialDataArray && personDetialDataArray.count > 0) {
        PDRPluginResult *result =
            [PDRPluginResult resultWithStatus:PDRCommandStatusOK
                               messageAsArray:personDetialDataArray];
        [plugin toCallback:callbackId withReslut:[result toJSONString]];
      } else {
        PDRPluginResult *result =
            [PDRPluginResult resultWithStatus:PDRCommandStatusNoResult
                               messageAsArray:personDetialDataArray];
        [plugin toCallback:callbackId withReslut:[result toJSONString]];
      }
    }
  }];
  [picker show:QYABPickerDisplayModePresent];
}

#pragma mark - QYABPickerDelegate
- (void)pickerDidFinishedSelectedWithUsers:(NSArray *)users {
}

@end
