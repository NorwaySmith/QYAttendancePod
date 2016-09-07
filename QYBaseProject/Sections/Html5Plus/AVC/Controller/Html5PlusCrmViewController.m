//
//  Html5PlusCrmViewController.m
//  QYBaseProject
//
//  Created by 董卓琼 on 15/11/20.
//  Copyright © 2015年 田. All rights reserved.
//

#import "Html5PlusCrmViewController.h"

#import "PDRCoreAppFrame.h"
#import "PDRCore.h"
#import "PDRCoreAppManager.h"


#import <MBProgressHUD.h>
#import "QYNavigationViewController.h"
#import "QYSandboxPath.h"
#define kStatus_Height              20.0f
#define kNavigation_Height          44.0f
#define kDefault_Style_Color        [UIColor colorWithRed:37.0/255.0 green:182.0/255.0 blue:237.0/255.0 alpha:1.0]


@interface Html5PlusCrmViewController ()
{
    MBProgressHUD           *_hud;
    __block UIView          *_navigationView;
    __block UIView          *_pContainer;
}
@end

@implementation Html5PlusCrmViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.hidesBottomBarWhenPushed = YES;
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectGroup:) name:@"PGSlecteGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackDesk) name:@"goBackDesk" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReadyEvent) name:@"appReady" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDRCoreAppFrameDidLoad) name:PDRCoreAppFrameDidLoadNotificationKey object:nil];
    
    CGFloat top = 0.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIView *statusbarView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, kStatus_Height)];
        [statusbarView setBackgroundColor:kDefault_Style_Color];
        [self.view addSubview:statusbarView];
        top = kStatus_Height;
    }
    
    _pContainer = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, top, self.view.bounds.size.width, self.view.bounds.size.height - top)];
    [self.view addSubview:_pContainer];
    
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, top, self.view.bounds.size.width, kNavigation_Height)];
    [_navigationView setBackgroundColor:kDefault_Style_Color];
    [_navigationView setAlpha:1.0];
    [self.view addSubview:_navigationView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:_navigationView.bounds];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"首页"];
    label.font = [UIFont systemFontOfSize:18.0];
    [label setTextColor:[UIColor whiteColor]];
    [_navigationView addSubview:label];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [_hud show:YES];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^
                   {
                       //正常启动runtime
                       [[PDRCore Instance] setContainerView:_pContainer];
                       [[PDRCore Instance] startAsAppClient];
                       NSString *pWWWPath = [[QYSandboxPath libraryPath] stringByAppendingPathComponent:@"Pandora/apps/crm/www"];
                       //如果library中不存在h5文件，则加载bundle中的默认文件
                       if (![[NSFileManager defaultManager] fileExistsAtPath:pWWWPath]) {
                           pWWWPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Pandora/apps/crm/www"];
                       }
                       
                       [[[PDRCore Instance] appManager] openAppAtLocation:pWWWPath withIndexPath:@"crm/html/index.html" withArgs:nil withDelegate:nil];
                   });
    
}

- (void)appReadyEvent
{
    //    //NSLog(@"appReadyEvent");
    //    //NSLog(@"container: %@\n window manager: %@",_pContainer, [_pContainer subviews]);
    if ([_pContainer subviews] == nil || [[_pContainer subviews] count] == 0)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^
                       {
                           UIView *v = (UIView *)[[PDRCore Instance] coreWindow];
                           [_pContainer addSubview:v];
                           [_navigationView setAlpha:0.0];
                           [_hud hide:YES];
                       });
    }
    else
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^
                       {
                           [_navigationView setAlpha:0.0];
                           [_hud hide:YES];
                       });
    }
}

-(void)goBackDesk
{
    //NSLog(@"%d", [NSThread currentThread].isMainThread);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [PDRCore destoryEngine];
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)PDRCoreAppFrameDidLoad
{
    //NSLog(@"PDRCoreAppFrameDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
