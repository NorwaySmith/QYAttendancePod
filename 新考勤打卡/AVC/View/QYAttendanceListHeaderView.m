//
//  QYAttendanceListHeaderView.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceListHeaderView.h"

//自动布局
#import "Masonry.h"

#import "QYDeviceInfo.h"

#import "QYAttendanceListModel.h"

#import "QYDialogTool.h"

#import "QYTheme.h"

#define  cicrleRadio (CGFloat)[QYDeviceInfo screenWidth]/320*240/2
@interface QYAttendanceListHeaderView()<CircularProgressDelegate>{
}
//时分
@property (nonatomic,strong)UILabel *timeLabel;

//日期
@property (nonatomic,strong)UILabel *dateLabel;

//签到
@property (nonatomic,strong)UIButton *signButton;

//签退
@property (nonatomic,strong)UIButton *signOutButton;

//位置信息提示
@property (nonatomic,strong)UILabel *localMessageLabel;


@end

@implementation QYAttendanceListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"AttendanceBundle.bundle/Contents/Resources/QYAttendance_list_header@2x.png"]];
    
    //背景锯齿状imageview
    UIImageView *sawToothBackGroundView = [[UIImageView alloc] init];
    sawToothBackGroundView.image=[UIImage imageNamed:@"AttendanceBundle.bundle/Contents/Resources/QYAttendance_list_juchi.png"];
    [self addSubview:sawToothBackGroundView];
    
    //外环
    _circularProgress = [[QYCircularProgressView alloc] init];
    _circularProgress.delegate = self;
//    [_circularProgress setTotalSecondTime:0];
    _circularProgress.backgroundColor=[UIColor clearColor];
    [self addSubview:_circularProgress];
    
    //时分
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font=[UIFont systemFontOfSize:30.0];
    _timeLabel.textAlignment=NSTextAlignmentCenter;
    _timeLabel.textColor=[UIColor whiteColor];
    _timeLabel.backgroundColor=[UIColor clearColor];
    [_circularProgress addSubview:_timeLabel];
    
    //日期
    _dateLabel=[[UILabel alloc] init];
    _dateLabel.font=[UIFont systemFontOfSize:14.0];
    _dateLabel.textAlignment=NSTextAlignmentCenter;
    _dateLabel.textColor=[UIColor whiteColor];
    _dateLabel.backgroundColor=[UIColor clearColor];
    [_circularProgress addSubview:_dateLabel];
    
    //签到
    _signButton=[[UIButton alloc] init];
    _signButton.tag=101;
    [_signButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    [_signButton setBackgroundImage:[UIImage imageNamed:@"AttendanceBundle.bundle/Contents/Resources/QYAttendance_header_signInN@2x"] forState:UIControlStateNormal];
    _signButton.userInteractionEnabled=NO;
    [self addSubview:_signButton];
    
    _toWorkTimeLabel = [[UILabel alloc] init];
    _toWorkTimeLabel.font=[UIFont systemFontOfSize:12.0];
    _toWorkTimeLabel.textAlignment=NSTextAlignmentCenter;
    _toWorkTimeLabel.textColor=[UIColor whiteColor];
    _toWorkTimeLabel.text=@"08:45";
    _toWorkTimeLabel.hidden=YES;
    [self addSubview:_toWorkTimeLabel];
    
    //签退
    _signOutButton=[[UIButton alloc] init];
     _signOutButton.tag=102;
    [_signOutButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    [_signOutButton setBackgroundImage:[UIImage imageNamed:@"AttendanceBundle.bundle/Contents/Resources/QYAttendance_header_signOutN.png"] forState:UIControlStateNormal];
    _signOutButton.userInteractionEnabled=NO;
    [self addSubview:_signOutButton];
    
    _offWorkTimeLabel = [[UILabel alloc] init];
    _offWorkTimeLabel.font=[UIFont systemFontOfSize:12.0];
    _offWorkTimeLabel.textAlignment=NSTextAlignmentCenter;
    _offWorkTimeLabel.textColor=[UIColor whiteColor];
    _offWorkTimeLabel.text=@"18:15";
    _offWorkTimeLabel.hidden=YES;
    [self addSubview:_offWorkTimeLabel];

    // 地理图标
    UIImageView *locationImage = [[UIImageView alloc] init];
    locationImage.image=[UIImage imageNamed:@"AttendanceBundle.bundle/Contents/Resources/QYAttendance_point_header.png"];
    [self addSubview:locationImage];

    //位置信息
    _localMessageLabel =[[UILabel alloc] init];
    _localMessageLabel.backgroundColor=[UIColor clearColor];

    _localMessageLabel.text=@"正在获取地理位置信息...";
    _localMessageLabel.textColor=[UIColor whiteColor];
    _localMessageLabel.font=[UIFont baseTextMiddle];
    _localMessageLabel.numberOfLines=2;
    _localMessageLabel.textAlignment=NSTextAlignmentLeft;
//    _localMessageLabel.backgroundColor=[UIColor yellowColor];
    [self addSubview:_localMessageLabel];
    
    _reLocationButton = [[UIButton alloc] init];
    [_reLocationButton setImage:[UIImage imageNamed:@"QYAttendance_list_refreshLocationN"] forState:UIControlStateNormal];
    [_reLocationButton setTitle:@"重定位" forState:UIControlStateNormal];
    [_reLocationButton setTitleColor:[UIColor colorWithRed:32.0/255.0 green:130.0/255.0 blue:111.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [_reLocationButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_reLocationButton addTarget:self action:@selector(relocationClick) forControlEvents:UIControlEventTouchUpInside];
    _reLocationButton.titleLabel.font=[UIFont baseTextLarge];
    _reLocationButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    _reLocationButton.hidden=YES;
    [self addSubview:_reLocationButton];
    
    [self refreshTimeAndDate];
    //------------------------------------------------布局---------------------------------------
    CGFloat rightSaw = ((CGFloat)[QYDeviceInfo screenWidth]-90-cicrleRadio)/3;

    [sawToothBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(rightSaw);
        make.bottom.equalTo(self.mas_bottom).offset(-55);
        make.width.equalTo(@(cicrleRadio));
        make.height.equalTo(@(cicrleRadio));
    }];
    
    [_circularProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sawToothBackGroundView.mas_centerX);
        make.centerY.equalTo(sawToothBackGroundView.mas_centerY);
//        make.left.equalTo(sawToothBackGroundView.mas_left);
//        make.bottom.equalTo(sawToothBackGroundView.mas_bottom);
        make.width.equalTo(@(cicrleRadio+2));
        make.height.equalTo(@(cicrleRadio+2));
        
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_circularProgress.mas_left);
        make.bottom.equalTo(_circularProgress.mas_centerY);
//        make.top.equalTo(_circularProgress.mas_top).offset(40);
        make.width.equalTo(_circularProgress.mas_width);
        make.height.equalTo(@(30));
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_circularProgress.mas_left);
//        make.top.equalTo(_circularProgress.mas_top).offset(70);
        make.bottom.equalTo(_circularProgress.mas_centerY).offset(20);
        make.width.equalTo(_circularProgress.mas_width);
        make.height.equalTo(@(15));
    }];
    //NSLog(@"此屏幕下的右间距:%f",rightFloat);
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_circularProgress.mas_centerY).offset(-35);
        make.right.equalTo(self.mas_right).offset(-rightSaw);
        make.width.equalTo(@(90));
        make.height.equalTo(@(38));
    }];
    
    [_toWorkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_signButton.mas_centerX);
        make.centerY.equalTo(_signButton.mas_centerY).offset(25);
        make.width.equalTo(@(100));
        make.height.equalTo(@(10));
    }];
    
    [_signOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_circularProgress.mas_centerY).offset(35);
        make.right.equalTo(self.mas_right).offset(-rightSaw);
        make.width.equalTo(@(90));
        make.height.equalTo(@(38));
    }];
    
    [_offWorkTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_signOutButton.mas_centerX);
        make.centerY.equalTo(_signOutButton.mas_centerY).offset(25);
        make.width.equalTo(@(100));
        make.height.equalTo(@(10));
    }];

    [locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(_localMessageLabel.mas_top).offset(1);
        make.width.equalTo(@(10));
        make.height.equalTo(@(13));
    }];
    [_localMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImage.mas_right).offset(10);
        make.top.equalTo(_circularProgress.mas_bottom).offset(7);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
//        make.height.equalTo(@(45));
    }];

    [_reLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_localMessageLabel.mas_top);
        make.centerY.equalTo(_localMessageLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.equalTo(@(70));
        make.height.equalTo(@(14));
    }];
    //-------------------------------------------------end---------------------------------------
    
}

-(void)sign:(id)sender{
    UIButton *button = (id)sender;
    if (button.tag==101) {
        //不进行位置判断，只进行可打卡次数判断
        if ([_dataDictionary[@"signIn"] intValue]>0) {
            _buttonClick(QYUSerSignStateSignIn);
        }
    }else if (button.tag==102){
        if ([_dataDictionary[@"signOut"] intValue]>0) {
            _buttonClick(QYUSerSignStateSignOut);
        }
    }
}
//定时器走完，暂时不用
#pragma CircularProgressDelegate
- (void)CircularProgressEnd{
}
-(void)refreshTimeAndDate{
    NSDictionary *dataDictionary = [QYAttendanceListModel getDayWeek];
    _timeLabel.text=dataDictionary[@"time"];
    _dateLabel.text=dataDictionary[@"day"];
    
    NSString *secondString = dataDictionary[@"seconds"];
    int seconds = [secondString intValue];
    _circularProgress.firstNumber=seconds;
    [_circularProgress setTotalSecondTime:60];
    [_circularProgress startTimer];

}
/**
 *  地理位置信息更新
 */
-(void)localMessageChangedCanLocation:(BOOL)change location:(NSString *)location{
    _isInRange = change;
    [_reLocationButton setTitle:@"重定位" forState:UIControlStateNormal];
    if (_isHavePlan) {
        if (change) {
            //打卡设置的位置
//            _localMessageLabel.text=[NSString stringWithFormat:@"%@（您已进入考勤范围）",location];

//            if ([_dataDictionary[@"location"] isNil] ) {
//                _localMessageLabel.text=[NSString stringWithFormat:@"您已进入考勤范围"];
//            }else{
//                _localMessageLabel.text=[NSString stringWithFormat:@"您已进入考勤范围（%@）",_dataDictionary[@"location"]];
//            }
            NSString *localMessage =[NSString stringWithFormat:@"%@ （在考勤区）",location];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:localMessage];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:4];//调整行间距
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [localMessage length])];
            _localMessageLabel.attributedText = attributedString;
        }else{
            //当前位置
            NSString *localMessage;
            if ([location isNil]) {
                localMessage=[NSString stringWithFormat:@"不在考勤区"];
            }else{
                localMessage=[NSString stringWithFormat:@"%@ （不在考勤区）",location];
            }
            
//            NSString *localMessage =[NSString stringWithFormat:@"%@（您已进入考勤范围）",location];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:localMessage];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:4];//调整行间距
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [localMessage length])];
            _localMessageLabel.attributedText = attributedString;

        }
    }else{
        _localMessageLabel.text=[NSString stringWithFormat:@"暂无考勤地点"];
    }

//    [_localMessageLabel sizeToFit];
}
-(void)setIsHavePlan:(BOOL)isHavePlan{
    _isHavePlan=isHavePlan;
    if (_isHavePlan==YES) {
        _localMessageLabel.text=[NSString stringWithFormat:@"正在获取地理位置信息..."];
    }else{
        _localMessageLabel.text=[NSString stringWithFormat:@"暂无考勤地点"];
    }
}
-(void)setDataDictionary:(NSDictionary *)dataDictionary{
    _dataDictionary=dataDictionary;
    if ([dataDictionary[@"signIn"] intValue]>0) {
        _toWorkTimeLabel.text=dataDictionary[@"onTime"];
    }else{
        _toWorkTimeLabel.text=dataDictionary[@""];
    }
    
    if ([dataDictionary[@"signOut"] intValue]>0) {
        _offWorkTimeLabel.text=dataDictionary[@"offTime"];
    }else{
        _offWorkTimeLabel.text=dataDictionary[@""];
    }
}
/**
 *  签到签退状态更新
 */
-(void)signOrsignOutStateChanged{
    
}
#pragma CircularProgressDelegate
- (void)CircularProgressOneCircle{
    [self refreshTimeAndDate];
}

-(void)setSignInStatueChanged:(BOOL)signInStatueChanged{
    if (signInStatueChanged) {
        [_signButton setBackgroundImage:[UIImage imageNamed:@"QYAttendance_header_signInE"] forState:UIControlStateNormal];
        _signButton.userInteractionEnabled=YES;
    }else{
        [_signButton setBackgroundImage:[UIImage imageNamed:@"QYAttendance_header_signInN"] forState:UIControlStateNormal];
        _signButton.userInteractionEnabled=NO;
    }
}
-(void)setSignOutStatueChanged:(BOOL)signOutStatueChanged{
    if (signOutStatueChanged) {
        [_signOutButton setBackgroundImage:[UIImage imageNamed:@"QYAttendance_header_signOutE"] forState:UIControlStateNormal];
        _signOutButton.userInteractionEnabled=YES;
    }else{
        [_signOutButton setBackgroundImage:[UIImage imageNamed:@"QYAttendance_header_signOutN"] forState:UIControlStateNormal];
        _signOutButton.userInteractionEnabled=NO;
    }

}
-(void)relocationClick{
    [_reLocationButton setTitle:@"定位中" forState:UIControlStateNormal];

    _reLocation(@"重新定位");
}
-(void)dealloc{
    //NSLog(@"111");
}
@end
