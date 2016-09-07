//
//  QYNewPopViewController.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/7/20.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYNewPopViewController.h"

#import "QYTheme.h"

#import "QYDeviceInfo.h"
#import "Masonry.h"
@interface QYNewPopViewController ()

//我知道了
@property (nonatomic,strong) UIButton *noButton;

//线
@property (nonatomic,strong) UIView *lineView;

//中心view
@property (nonatomic, strong)UIImageView *whiteView;

//时间段
@property (nonatomic, strong)UILabel *dateState;

//打卡成功时间
@property (nonatomic, strong)UILabel *dateTime;

//打卡成功提示
@property (nonatomic, strong)UILabel *dateAssignTime;

//打卡成功时间
@property (nonatomic, strong)UILabel *agreeLabel;

//中心颜色块
@property (nonatomic, strong)UIImageView *centerView;

//后
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation QYNewPopViewController

#pragma mark - define

#define BTN_MARGIN_BOTOOM 10 //按钮底部边距
#define BTN_MARGIN_LR 10 //按钮左右边距
#define BTN_MARGIN_MIDDLE 20 //按钮中间边距
#define BTN_HEIGHT 54 //按钮高度

#pragma mark - 懒加载初始化

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - 控件创建
//
//#pragma mark - getter / setter
//- (void)addContentView {
//    
//    self.contentView = [[UIView alloc] init];
//    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
//    self.contentView.center = self.view.center;
//    self.contentView.layer.masksToBounds = YES;
//    self.contentView.layer.cornerRadius = 5;
//    [self.view addSubview:self.contentView];
//    
//    self.lineView = [[UIView alloc] init];
//    self.lineView.backgroundColor=[UIColor themeSeparatorLineColor];
//    [self.contentView addSubview:self.lineView];
//
//    /*
//     *  底部按钮
//     */
//    self.noButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.noButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.noButton addTarget:self action:@selector(hidden:) forControlEvents:UIControlEventTouchUpInside];
//    [self.noButton setTitle:@"我知道了" forState:UIControlStateNormal];
//    self.noButton.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
//    [self.contentView addSubview:self.noButton];
//    
////    上部
//    self.whiteView = [[UIImageView alloc] init];
//    self.whiteView.image=[UIImage imageNamed:@"QYAttendance_PunchSucceed"];
//    [self.contentView addSubview:self.whiteView];
//    
//    self.dateState = [[UILabel alloc] init];
//    self.dateState.font = [UIFont systemFontOfSize:17];
//    self.dateState.textAlignment = NSTextAlignmentCenter;
//    self.dateState.textColor=[UIColor whiteColor];
//    self.dateState.text=@"上午";
//    [self.whiteView addSubview:self.dateState];
//    
//    self.dateTime = [[UILabel alloc] init];
//    self.dateTime.font = [UIFont systemFontOfSize:27];
//    self.dateTime.textAlignment = NSTextAlignmentCenter;
//    self.dateTime.text=@"08:15";
//    self.dateTime.textColor=[UIColor whiteColor];
//    [self.whiteView addSubview:self.dateTime];
//    
//    self.agreeLabel = [[UILabel alloc] init];
//    self.agreeLabel.font = [UIFont systemFontOfSize:16];
//    self.agreeLabel.textAlignment = NSTextAlignmentCenter;
//    self.agreeLabel.text=@"^_^为今天的努力点个赞！";
//    self.agreeLabel.textColor=[UIColor baseTextGreyLight];
//    [self.whiteView addSubview:self.agreeLabel];
//    
//    if (_dataDictionary) {
//        self.dateState.text = _dataDictionary[@"dateState"];
//        self.dateTime.text =_dataDictionary[@"dateTime"];
//    }
//    //打卡的状态值 1正常2迟到3早退
//    switch ([_attState intValue]) {
//        case 1:
//            self.agreeLabel.text=@"^_^为自己的努力点个赞！";
//            break;
//        case 2:
//            self.agreeLabel.text=@"你迟到了，下次来早点哦";
//            break;
//        case 30:
//            self.agreeLabel.text=@"坚持自己所坚持的";
//            break;
//            
//        default:
//            break;
//    }
//    [self setAnimation];
//}
//
////出现的动画
//- (void)setAnimation {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.contentView.frame = CGRectMake(0, 0, self.contentViewSize.width, self.contentViewSize.height);
//        self.contentView.center = self.view.center;
//        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
//    } completion:^(BOOL finished) {
//        self.dateState.frame = CGRectMake(0, 22, CGRectGetWidth(self.contentView.frame), 15);
//        self.dateTime.frame=CGRectMake(0, CGRectGetMaxY(self.dateState.frame)+10, CGRectGetWidth(self.contentView.frame), 30);
//        self.whiteView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)+1 ,CGRectGetHeight(self.contentView.frame)-55);
//        self.lineView.frame=CGRectMake(0, CGRectGetMaxY(self.whiteView.frame), CGRectGetWidth(self.contentView.frame), 1);
//        self.noButton.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame) , CGRectGetWidth(self.contentView.frame), BTN_HEIGHT);
//        self.agreeLabel.frame=CGRectMake(0, CGRectGetHeight(self.whiteView.frame)-30, CGRectGetWidth(self.contentView.frame), 15);
//    }];
//    
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    [window addSubview:self.view];
//    [window.rootViewController addChildViewController:self];
//}
//
//
////消失动画
//- (void)hidden {
//    [self.view removeFromSuperview];
//}
//#pragma mark - 点击事件
////取消
//-(void)hidden:(UIButton *)button {
//    //消失动画
//    [self hidden];
//}


#pragma mark - 控件创建

#pragma mark - getter / setter
- (void)addContentView {
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    self.contentView.center = self.view.center;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    [self.view addSubview:self.contentView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor=[UIColor themeSeparatorLineColor];
    [self.contentView addSubview:self.lineView];
    
    /*
     *  底部按钮
     */
    self.noButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.noButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.noButton addTarget:self action:@selector(hidden:) forControlEvents:UIControlEventTouchUpInside];
    [self.noButton setTitle:@"我知道了" forState:UIControlStateNormal];
    self.noButton.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [self.contentView addSubview:self.noButton];
    
    //    上部
//    self.whiteView = [[UIImageView alloc] init];
//    self.whiteView.image=[UIImage imageNamed:@"QYAttendance_PunchSucceed"];
//    [self.contentView addSubview:self.whiteView];
    
    self.imageView=[[UIImageView alloc] init];
    self.imageView.image=[UIImage imageNamed:@"QYAttendance_topRight"];
    [self.contentView addSubview:self.imageView];

    self.dateAssignTime = [[UILabel alloc] init];
    self.dateAssignTime.font = [UIFont systemFontOfSize:25];
    self.dateAssignTime.text=@"打卡成功";
    self.dateAssignTime.textColor=[UIColor blackColor];
    self.dateAssignTime.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:self.dateAssignTime];
    
    self.centerView = [[UIImageView alloc] init];
    self.centerView.image=[UIImage imageNamed:@"QYAttendance_timeBackColor"];
    [self.contentView addSubview:self.centerView];
    
    self.dateState = [[UILabel alloc] init];
    self.dateState.font = [UIFont systemFontOfSize:16];
    self.dateState.textColor=[UIColor whiteColor];
    self.dateState.text=@"上班";
    self.dateState.numberOfLines=2;
    [self.centerView addSubview:self.dateState];

    self.dateTime = [[UILabel alloc] init];
    self.dateTime.font = [UIFont systemFontOfSize:30];
    self.dateTime.textColor=[UIColor whiteColor];
    self.dateTime.text=@"11:36";

    [self.centerView addSubview:self.dateTime];
    
    self.agreeLabel = [[UILabel alloc] init];
    self.agreeLabel.font = [UIFont systemFontOfSize:16];
    self.agreeLabel.textAlignment = NSTextAlignmentCenter;
    self.agreeLabel.text=@"^_^为今天的努力点个赞！";
    self.agreeLabel.textColor=[UIColor baseTextGreyLight];
    [self.contentView addSubview:self.agreeLabel];
    
    if (_dataDictionary) {
        self.dateState.text = _dataDictionary[@"dateState"];
        self.dateTime.text =_dataDictionary[@"dateTime"];
    }
    //打卡的状态值 1正常2迟到3早退
    switch ([_attState intValue]) {
        case 1:
            self.agreeLabel.text=@"^_^为自己的努力点个赞！";
            break;
        case 2:
            self.agreeLabel.text=@"你迟到了，下次来早点哦";
            break;
        case 3:
            self.agreeLabel.text=@"坚持自己所坚持的";
            break;
            
        default:
            break;
    }
    [self setAnimation];
}

//出现的动画
- (void)setAnimation {
    CGFloat centerViewWidth = (float)[QYDeviceInfo screenWidth]/320*170;
    CGFloat centerViewHeight = (float)[QYDeviceInfo screenWidth]/320*65;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.equalTo(@(self.contentViewSize.width));
            make.height.equalTo(@(self.contentViewSize.height));
        }];
        
//        self.contentView.frame = CGRectMake(0, 0, self.contentViewSize.width, self.contentViewSize.height);
//        self.contentView.center = self.view.center;
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    } completion:^(BOOL finished) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX).offset(-28*2.5-3);
            make.top.equalTo(@(50));
            make.width.equalTo(@(28));
            make.height.equalTo(@(32));
        }];
        [self.dateAssignTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(10);
            make.top.equalTo(self.imageView.mas_top);
            make.width.equalTo(@(CGRectGetWidth(self.contentView.frame)-100));
            make.height.equalTo(@(30));
        }];
        
        [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(centerViewWidth));
            make.height.equalTo(@(centerViewHeight));
        }];
        CGFloat dateStatesLeft =(float)[QYDeviceInfo screenWidth]/320*33;
        
        [self.dateState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerView.mas_left).offset(dateStatesLeft);
            make.centerY.equalTo(self.centerView.mas_centerY);
            make.width.equalTo(@(20));
            make.height.equalTo(@(40));
        }];
        
        [self.dateTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateState.mas_right).offset(10);
            make.centerY.equalTo(self.centerView.mas_centerY);
            make.width.equalTo(@(200));
            make.height.equalTo(@(35));
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-55);
            make.height.equalTo(@(1));
        }];

        [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@(BTN_HEIGHT));
        }];
        
        [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.centerView.mas_bottom).offset(20);
            make.height.equalTo(@(15));
        }];
//        self.imageView.frame=CGRectMake(CGRectGetWidth(self.contentView.frame)/2-28*2.5-3, 50, 28, 32);
//        self.dateAssignTime.frame=CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, 50, CGRectGetWidth(self.contentView.frame)-100, 30);
//        self.centerView.frame=CGRectMake(self.contentViewSize.width/2-centerViewWidth/2, self.contentViewSize.height/2-centerViewHeight/2.0, centerViewWidth, centerViewHeight);
//        //        self.whiteView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)+1 ,CGRectGetHeight(self.contentView.frame)-55);
//        self.dateState.frame=CGRectMake((float)[QYDeviceInfo screenWidth]/320*33, (CGRectGetHeight(self.centerView.frame)-40)/2, 20, 40);
//        self.dateTime.frame=CGRectMake(CGRectGetMaxY(self.dateState.frame)+10,(CGRectGetHeight(self.centerView.frame)-35)/2,200,35);
//        self.lineView.frame=CGRectMake(0, CGRectGetHeight(self.contentView.frame)-55, CGRectGetWidth(self.contentView.frame), 1);
//        self.noButton.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame)-55 , CGRectGetWidth(self.contentView.frame), BTN_HEIGHT);
//        self.agreeLabel.frame=CGRectMake(0, CGRectGetMaxY(self.centerView.frame)+20, CGRectGetWidth(self.contentView.frame), 15);
    }];


//    [UIView animateWithDuration:0.3 animations:^{
//        self.contentView.frame = CGRectMake(0, 0, self.contentViewSize.width, self.contentViewSize.height);
//        self.contentView.center = self.view.center;
//        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
//    } completion:^(BOOL finished) {
//        self.imageView.frame=CGRectMake(CGRectGetWidth(self.contentView.frame)/2-28*2.5-3, 50, 28, 32);
//        self.dateAssignTime.frame=CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, 50, CGRectGetWidth(self.contentView.frame)-100, 30);
//        self.centerView.frame=CGRectMake(self.contentViewSize.width/2-centerViewWidth/2, self.contentViewSize.height/2-centerViewHeight/2.0, centerViewWidth, centerViewHeight);
////        self.whiteView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)+1 ,CGRectGetHeight(self.contentView.frame)-55);
//        self.dateState.frame=CGRectMake((float)[QYDeviceInfo screenWidth]/320*33, (CGRectGetHeight(self.centerView.frame)-40)/2, 20, 40);
//        self.dateTime.frame=CGRectMake(CGRectGetMaxY(self.dateState.frame)+10,(CGRectGetHeight(self.centerView.frame)-35)/2,200,35);
//        self.lineView.frame=CGRectMake(0, CGRectGetHeight(self.contentView.frame)-55, CGRectGetWidth(self.contentView.frame), 1);
//        self.noButton.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame)-55 , CGRectGetWidth(self.contentView.frame), BTN_HEIGHT);
//        self.agreeLabel.frame=CGRectMake(0, CGRectGetMaxY(self.centerView.frame)+20, CGRectGetWidth(self.contentView.frame), 15);
//    }];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
}


//消失动画
- (void)hidden {
    [self.view removeFromSuperview];
}
#pragma mark - 点击事件
//取消
-(void)hidden:(UIButton *)button {
    //消失动画
    [self hidden];
}

@end
