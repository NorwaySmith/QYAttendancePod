

#import "QYNavigationViewController.h"
#import "QYTheme.h"

@interface QYNavigationViewController ()

@end

@implementation QYNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization
        //标题样式
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],NSForegroundColorAttributeName,
                                                   [UIFont themeBoldNavTitleFont],NSFontAttributeName,nil];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        self.interactivePopGestureRecognizer.enabled = NO;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage themeNavBg] forBarMetrics:UIBarMetricsDefault];
      //去黑线
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    // 禁用 iOS7 返回手势
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    } 
//}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


- (NSString *)getFrontViewControllerTitle {
    NSInteger index = self.viewControllers.count - 2;
    if (index >= 0) {
        UIViewController *viewController = self.viewControllers[index];
        if (viewController.title) {
            return viewController.title;
        }else if (viewController.navigationItem.title)
        {
            return viewController.navigationItem.title;
        }
    }
    return @"返回";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
