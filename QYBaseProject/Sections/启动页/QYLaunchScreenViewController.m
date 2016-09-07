//
//  QYLaunchScreenViewController.m
//  QYBaseProject
//
//  Created by lin on 16/3/29.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYLaunchScreenViewController.h"
#import "QYInitUI.h"
#import "QYTheme.h"
#import "Masonry.h"
#import "IOSTool.h"
#import "UIImageView+WebCache.h"
#import "QYNetworkHelper.h"
#import "QYNetworkJsonProtocol.h"
#import "QYURLHelper.h"

#define klaunchScreenImageUrl                   @"http://101.200.31.143/fileServer/download?"
#define klaunchScreenTextUrl                    @"http://218.206.244.202:39988/jzoa/productionSchedule/getSafeDaysForWap.action?"

#define klaunchScreenForText                    @"launchScreenForText"   //本地存储日期信息的标记

//主题文字的颜色值
#define klaunchScreenThemeTextColor             [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0]
//天数的颜色值
#define klaunchScreenNumTextColor               [UIColor colorWithRed:255.0/255.0 green:238.0/255.0 blue:88.0/255.0 alpha:1.0]

// 主题文字距离下边距的间隔
#define klaunchScreenThemeTextToBottom          300
// 新的闪屏图片距离下边距的间隔
#define klaunchScreenStartPageImageViewToBottom ([QYDeviceInfo screenHeight]*140)/667.0

@interface QYLaunchScreenViewController ()

/**
 *  启动时的配置
 */
@property (nonatomic, strong) NSDictionary              *launchOptions;
/**
 *  闪屏显示的时间
 */
@property (nonatomic, assign) NSInteger                 duration;
/**
 *  更换闪屏的类型
 */
@property (assign) QYLaunchScreenUpdataType             launchScreenUpdataType;

@property (nonatomic, strong) UIImage                   *launchImage;
@property (nonatomic, strong) UIImageView               *launchImageView;

/**
 *  新的闪屏图片imageView
 */
@property (nonatomic, strong) UIImageView               *startPageImageView;

@end

@implementation QYLaunchScreenViewController

#pragma mark - life cycle
- (id)initWithLaunchOptions:(NSDictionary *)launchOptions
                   duration:(NSInteger)duration
     launchScreenUpdataType:(QYLaunchScreenUpdataType)launchScreenUpdataType {
    self = [super init];
    if (self) {
        _launchOptions = launchOptions;
        if (duration <= 1) {
            _duration = 1;
        }else{
            _duration = duration;
        }
        _launchScreenUpdataType = launchScreenUpdataType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //闪屏显示一定时长时执行
    [self performSelector:@selector(launchScreenDidDismiss) withObject:nil afterDelay:_duration];
    
    [self configLaunchScreenImageView];
    
    //下载更新新的数据、信息
    if (_launchScreenUpdataType == QYLaunchScreenUpdataText) {
        //判断本地是否已得到当天的天数
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:klaunchScreenForText];
        if (dic) {
            NSDate *nowDate = [NSDate date];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"yyyy年MM月dd日";
            NSString *nowDateString = [format stringFromDate:nowDate];
            if ([nowDateString isEqualToString:[dic objectForKey:@"curDate"]]) {
                //当天的已请求到
                [self configLaunchScreenTextWithDateDic:dic];
            }else{
                [self loadLaunchScreenText];
            }
        }else{
            [self loadLaunchScreenText];
        }
    }else if(_launchScreenUpdataType == QYLaunchScreenUpdataImage) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"klaunchScreenForStartpageDic"];
        //判断是否需要显示
        if ([[dic objectForKey:@"isExpire"] integerValue] == 0 || [[dic objectForKey:@"startpageUsed"] integerValue] == 0) {
            //无需替换新的图片
        }else{
            //加载新的图片
            [self configStartPageImageViewWithStartpageDic:dic];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchScreenViewControllerViewWillAppear)]) {
        [self.delegate launchScreenViewControllerViewWillAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchScreenViewControllerViewDidAppear)]) {
        [self.delegate launchScreenViewControllerViewDidAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchScreenViewControllerViewWillDisappear)]) {
        [self.delegate launchScreenViewControllerViewWillDisappear];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
/**
 *  加载页面的主背景图（默认闪屏）
 */
- (void)configLaunchScreenImageView {
    _launchImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([QYDeviceInfo screenHeight] == 480) {
        //4s手机
        _launchImage = [UIImage imageNamed:@"640*960"];
    }else if ([QYDeviceInfo screenHeight] == 568) {
        //5、5s手机
        _launchImage = [UIImage imageNamed:@"640*1136"];
    }else if ([QYDeviceInfo screenHeight] == 667) {
        //iphone6
        _launchImage = [UIImage imageNamed:@"750*1334"];
    }else if ([QYDeviceInfo screenHeight] == 736) {
        //iPhone6 Plus
        _launchImage = [UIImage imageNamed:@"1242*2208"];
    }
    _launchImageView.image = _launchImage;
    [self.view addSubview:_launchImageView];
}
/**
 *  加载闪屏的文字信息
 */
- (void)configLaunchScreenTextWithDateDic:(NSDictionary *)dateDic {
    UILabel *themeLabel = [[UILabel alloc] init];
    themeLabel.textAlignment = NSTextAlignmentCenter;
    themeLabel.textColor = klaunchScreenThemeTextColor;
    themeLabel.font = [UIFont systemFontOfSize:25.0];
    themeLabel.text = @"乐工作已安装";
    [self.launchImageView addSubview:themeLabel];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.launchImageView addSubview:bottomView];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.textColor = klaunchScreenNumTextColor;
    numLabel.font = [UIFont systemFontOfSize:80.0];
    numLabel.text = [NSString stringWithFormat:@"%@", [dateDic objectForKey:@"diff"]];
    [bottomView addSubview:numLabel];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.textColor = klaunchScreenThemeTextColor;
    dayLabel.font = [UIFont systemFontOfSize:25.0];
    dayLabel.text = @"天";
    [bottomView addSubview:dayLabel];
    
    [themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_launchImageView.mas_left);
        make.right.equalTo(_launchImageView.mas_right);
        make.bottom.equalTo(_launchImageView.mas_bottom).offset(-klaunchScreenThemeTextToBottom);
        make.height.equalTo(@([themeLabel.font lineHeight]));
    }];
    
    //计算时间的size
    CGSize numSize = [numLabel.text getStringSizeForFont:numLabel.font maxSize:CGSizeMake(MAXFLOAT, [numLabel.font lineHeight])];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(themeLabel.mas_bottom).offset(10);
        make.centerX.equalTo(_launchImageView.mas_centerX);
        make.height.equalTo(@([numLabel.font lineHeight]));
        make.width.equalTo(@(numSize.width+5+20+25));
    }];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.width.equalTo(@(numSize.width+5));
    }];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLabel.mas_right).offset(20);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-15);
        make.width.equalTo(@(25));
    }];
}

/**
 *  加载闪屏的图片
 */
- (void)configStartPageImageViewWithStartpageDic:(NSDictionary *)startpageDic {
    _startPageImageView = [[UIImageView alloc] init];
    _startPageImageView.backgroundColor = [UIColor clearColor];
    NSString *urlString = [NSString stringWithFormat:@"%@filePath=%@", klaunchScreenImageUrl, [startpageDic objectForKey:@"startpagePhoto"]];
    [_startPageImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"defaultLaunchScreenImage"]];
    [_launchImageView addSubview:_startPageImageView];
    
    [_startPageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_launchImageView.mas_top);
        make.left.equalTo(_launchImageView.mas_left);
        make.right.equalTo(_launchImageView.mas_right);
        make.bottom.equalTo(_launchImageView.mas_bottom).offset(-klaunchScreenStartPageImageViewToBottom);
    }];
}

#pragma mark - CustomDelegate

#pragma mark - event response
/**
 *  闪屏消失时，初始化rootViewController
 */
- (void)launchScreenDidDismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchScreenViewControllerViewDidDisappearWithLaunchOptions:)]) {
        [self.delegate launchScreenViewControllerViewDidDisappearWithLaunchOptions:_launchOptions];
    }
}

#pragma mark - private methods
/**
 *  网络请求得到闪屏需要显示的文字信息
 */
- (void)loadLaunchScreenText {
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [[QYNetworkJsonProtocol alloc] init];
    NSDictionary *parameters = @{@"_clientType":@"wap", @"userId":@(1), @"type":@(2)};
    
    [networkHelper POST:klaunchScreenTextUrl parameters:parameters success:^(QYNetworkResult *result) {
        if(result.statusCode == NetworkResultStatusCodeSuccess) {
            // 请求成功处理
            NSDictionary *dic = [self JSONObjectData:[result.result dataUsingEncoding:NSUTF8StringEncoding]];
            //NSLog(@"dic:%@---curDate:%@===diff:%@", dic, [dic objectForKey:@"curDate"], [dic objectForKey:@"diff"]);
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:klaunchScreenForText];
            //加载显示日期
            [self configLaunchScreenTextWithDateDic:dic];
        }else{
            // 文字信息请求失败
            /**
             *  失败后暂不处理，不更新本地
             */
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
#pragma mark - getters and setters



@end
