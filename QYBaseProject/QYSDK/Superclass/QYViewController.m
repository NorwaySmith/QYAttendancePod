

#import "QYViewController.h"
#import "QYShakeHelper.h"
#import "QYNoNetworkView.h"
#import "QYNetworkInfo.h"
@interface QYViewController ()
<QYNoNetworkViewDelegate>
/**
 *  无网络view
 */
@property(nonatomic,strong)QYNoNetworkView *noNetworkView;
/**
 *  是否监测网络
 */
@property(nonatomic,assign)BOOL isMonitorNetwork;
@end

@implementation QYViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //标题样式
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],NSForegroundColorAttributeName,
                                                   [UIFont themeBoldNavTitleFont],NSFontAttributeName,nil];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //返回按钮
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:self.title
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:nil];
    UIImage *img = [UIImage themeBackButton];
    [backButton setBackButtonBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width topCapHeight:img.size.height/2.0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backButton setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor themeBackButtonColor], NSForegroundColorAttributeName,
                                        [UIFont themeBackButtonFont], NSFontAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = backButton;
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //摇一摇我可以被响应
    [[QYShakeHelper shared] becomeFirstResponder];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(networkingReachabilityDidChange:)
     name:QYNetworkingReachabilityDidChangeNotification
     object:nil];
    if (_isMonitorNetwork) {
        [self configNoNetworkViewByNetworkStatus];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:QYNetworkingReachabilityDidChangeNotification
     object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 无网络
/**
 *  显示无网络view
 */
-(void)showNoNetworkView{
	[self addNoNetworkView];

}
/**
 *  隐藏无网络view
 */
-(void)hideNoNetworkView{
	[self removeNoNetworkView];
}
/**
 *  网络状态变化监测
 *
 *  @param notification 通知字典
 */
-(void)networkingReachabilityDidChange:(NSNotification *)notification {
    if (!_isMonitorNetwork) {
        return;
    }
    [self configNoNetworkViewByNetworkStatus];
}

/**
 * 开启网络监控后，无网络默认显示无网络view
 */
-(void)openNetworkMonitor {
    self.isMonitorNetwork = YES;
    [self configNoNetworkViewByNetworkStatus];
}

/**
 *  根据网络状态删除或者添加无数据页
 */
-(void)configNoNetworkViewByNetworkStatus {
    if ([[QYNetworkInfo shared] connectedToNetwork]) {
        [self removeNoNetworkView];
        [self networkReachable];
    } else {
        [self addNoNetworkView];
        [self networkNotReachable];
    }
}
/**
 *  删除无网络页面
 */
-(void)removeNoNetworkView{
    if (_noNetworkView) {
        [_noNetworkView removeFromSuperview];
        self.noNetworkView = nil;
    }
}


/**
 *  添加无网络页面
 */

-(void)addNoNetworkView {
    if (!_noNetworkView) {
        self.noNetworkView = [self customNoNetworkView];
        _noNetworkView.delegate = self;
        [self.view addSubview:_noNetworkView];
        [self.view bringSubviewToFront:_noNetworkView];
    } else {
        [self.view addSubview:_noNetworkView];
        [self.view bringSubviewToFront:_noNetworkView];
    }
}

/**
 *  不定制则显示默认无网络view。
 *  如需要定制无网络view，请在子类实现此函数。
 *  继承父类QYNoNetworkView来自定义无网络view
 *
 *  @return 无网络view
 */
-(QYNoNetworkView *)customNoNetworkView {
    QYNoNetworkView *noNetworkView = [[QYNoNetworkView alloc] initWithFrame:[self noNetworkViewFrame]];
    return noNetworkView;
}

/**
 *  无网络view frame，默认和self.view一样大。
 *  要改变无网络view大小，请在子类覆盖此函数
 *
 *  @return
 */

-(CGRect)noNetworkViewFrame {
    return self.view.bounds;
}

/**
 *  网络可以连接。要处理变为无网络时的状态，请在子类覆盖此函数
 */
-(void)networkReachable {
    
}

/**
 *  网络不可连接。要处理变为无网络时的状态，请在子类覆盖此函数
 */
-(void)networkNotReachable {

}

/**
 *  无网络view点击回调。要处理点击无网络页面事件，请在子类覆盖此函数
 */
-(void)didClickNoNetworkView {

}

@end
