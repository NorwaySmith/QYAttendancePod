//
//  QYAttendanceListCell.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//
//rowHeight 65
#import "QYAttendanceListCell.h"
#import "UIColor+QYColorToHtmlColor.h"
#import "QYTheme.h"
//自动布局
#import "Masonry.h"

#import "QYDeviceInfo.h"

#import "QYAttendanceListModel.h"

@interface QYAttendanceListCell()
 //时间和状态09:00(迟到)
@property (nonatomic, strong) UILabel *timeAndState;
 //位置信息
@property (nonatomic, strong) UILabel *localMessageLabel;

//位置信息
@property (nonatomic, strong) UIButton *signOutOrIn;

//考勤区域label
@property (nonatomic, strong) UILabel *normalLabel;

//外勤区域label
@property (nonatomic, strong) UILabel *unNormalLabel;

//迟到
@property (nonatomic, strong) UILabel *latelLabel;

//迟到
@property (nonatomic, strong) UILabel *earyLabel;

//查看备注
@property (nonatomic, strong) UIButton *remarkButton;

@end
@implementation QYAttendanceListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self configureUI];
    }
    return self;
}
-(void)configureUI{
    self.backgroundColor=[UIColor clearColor];

    //背景白色view
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor=[UIColor whiteColor];
    mainView.layer.cornerRadius=5;
    mainView.layer.borderColor=[UIColor cLightGrayColor].CGColor;
    mainView.layer.borderWidth=0.5;
    [self addSubview:mainView];
    
    //时间和状态09:00(迟到)
    _timeAndState = [[UILabel alloc] init];
    _timeAndState.textColor=[UIColor baseTextGreyLight];
    _timeAndState.font=[UIFont baseTextMiddle];
    _timeAndState.text=@"09:00(迟到)";
    [mainView addSubview:_timeAndState];
    
    //定位图标
    UIImageView *locationImage = [[UIImageView alloc] init];
    locationImage.image=[UIImage imageNamed:@"AttendanceBundle.bundle/Contents/Resources/QYAttendance_point_list@2x.png"];
    [mainView addSubview:locationImage];
    
    //位置信息
    _localMessageLabel =[[UILabel alloc] init];
    _localMessageLabel.backgroundColor=[UIColor clearColor];
    _localMessageLabel.text=@"东风路花园路交叉口向西200米世袭中心";
    _localMessageLabel.textColor=[UIColor baseTextGreyLight];
    _localMessageLabel.font=[UIFont baseTextMiddle];
    _localMessageLabel.textAlignment=NSTextAlignmentLeft;
    [mainView addSubview:_localMessageLabel];
    
    //签到签退图标
    _signOutOrIn = [[UIButton alloc] init];
//    [_signOutOrIn setBackgroundImage:[UIImage imageNamed:@"QYAttendance_list_refreshRemarkN"] forState:UIControlStateNormal];
    _signOutOrIn.backgroundColor=[UIColor clearColor];
    _signOutOrIn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_signOutOrIn setTitle:@"重新打卡" forState:UIControlStateNormal];
    [_signOutOrIn setTitleColor:[UIColor colorWithRed:0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    _signOutOrIn.titleLabel.font=[UIFont baseTextMiddle];
    [_signOutOrIn addTarget:self action:@selector(rePushCard) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:_signOutOrIn];
    
    _normalLabel = [[UILabel alloc] init];
    _normalLabel.text=@"考勤区";
    _normalLabel.font=[UIFont baseTextMiddle];
    _normalLabel.textAlignment=NSTextAlignmentCenter;
    _normalLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0  blue:153.0/255.0 alpha:1.0f];
    _normalLabel.layer.cornerRadius=2;
    _normalLabel.layer.borderColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0  blue:153.0/255.0 alpha:1.0f].CGColor;
    _normalLabel.layer.borderWidth=0.5;
    _normalLabel.layer.masksToBounds=YES;
    _normalLabel.hidden=YES;
    [mainView addSubview:_normalLabel];
    
    _unNormalLabel = [[UILabel alloc] init];
    _unNormalLabel.text=@"外勤";
    _unNormalLabel.font=[UIFont baseTextMiddle];
    _unNormalLabel.textAlignment=NSTextAlignmentCenter;
    _unNormalLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0  blue:153.0/255.0 alpha:1.0f];
    _unNormalLabel.layer.cornerRadius=2;
    _unNormalLabel.layer.borderColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0  blue:153.0/255.0 alpha:1.0f].CGColor;
    _unNormalLabel.layer.borderWidth=0.5;
    _unNormalLabel.layer.masksToBounds=YES;
    _unNormalLabel.hidden=YES;
    [mainView addSubview:_unNormalLabel];
    
    _latelLabel = [[UILabel alloc] init];
    _latelLabel.text=@"迟到";
    _latelLabel.font=[UIFont baseTextMiddle];
    _latelLabel.textAlignment=NSTextAlignmentCenter;
    _latelLabel.layer.cornerRadius=2;
    _latelLabel.textColor=[UIColor colorWithRed:213.0/255.0 green:116.0/255.0  blue:116.0/255.0 alpha:1.0f];
    _latelLabel.layer.borderColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0  blue:153.0/255.0 alpha:1.0f].CGColor;
    _latelLabel.layer.borderWidth=0.5;
    _latelLabel.layer.masksToBounds=YES;
    _latelLabel.hidden=YES;
    [mainView addSubview:_latelLabel];
    
    _earyLabel = [[UILabel alloc] init];
    _earyLabel.text=@"早退";
    _earyLabel.font=[UIFont baseTextMiddle];
    _earyLabel.textAlignment=NSTextAlignmentCenter;
    _earyLabel.layer.cornerRadius=2;
    _earyLabel.textColor=[UIColor colorWithRed:213.0/255.0 green:116.0/255.0  blue:116.0/255.0 alpha:1.0f];
    _earyLabel.layer.borderColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0  blue:153.0/255.0 alpha:1.0f].CGColor;
    _earyLabel.layer.masksToBounds=YES;
    _earyLabel.layer.borderWidth=0.5;
    _earyLabel.hidden=YES;
    [mainView addSubview:_earyLabel];

    _remarkButton = [[UIButton alloc] init];
    _remarkButton.backgroundColor=[UIColor clearColor];
    _remarkButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_remarkButton setTitle:@"查看备注" forState:UIControlStateNormal];
    [_remarkButton addTarget:self action:@selector(lookRemark) forControlEvents:UIControlEventTouchUpInside];
    [_remarkButton setTitleColor:[UIColor colorWithRed:0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    _remarkButton.titleLabel.font=[UIFont baseTextMiddle];
    [mainView addSubview:_remarkButton];

    //NSLog(@"width:%f  height:%f",self.frame.size.width,self.frame.size.height);
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@(85));
    }];
    [_timeAndState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_left).offset(12);
        make.top.equalTo(mainView.mas_top).offset(14);
        make.right.equalTo(mainView.mas_right).offset(-12);
        make.height.equalTo(@(14));
    }];
    [locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeAndState.mas_left);
        make.bottom.equalTo(mainView.mas_bottom).offset(-36);
        make.width.equalTo(@(10));
        make.height.equalTo(@(13));
    }];
    [_signOutOrIn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(mainView.mas_top).offset(33);
        make.top.equalTo(locationImage.mas_bottom).offset(8);
        make.right.equalTo(mainView.mas_right).offset(-10);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];

    [_localMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImage.mas_right).offset(5);
        make.right.equalTo(_signOutOrIn.mas_left).offset(-10);
        make.bottom.equalTo(locationImage.mas_bottom);
        make.height.equalTo(@(12));
    }];
    
    [_normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImage.mas_left);
        make.top.equalTo(locationImage.mas_bottom).offset(8);
        make.width.equalTo(@(45));
        make.height.equalTo(@(20));
    }];
    [_unNormalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImage.mas_left);
        make.top.equalTo(locationImage.mas_bottom).offset(8);
        make.width.equalTo(@(30));
        make.height.equalTo(@(20));
    }];

    [_latelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_normalLabel.mas_right).offset(8);
        make.top.equalTo(locationImage.mas_bottom).offset(8);
        make.width.equalTo(@(30));
        make.height.equalTo(@(20));
    }];
    [_earyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_normalLabel.mas_right).offset(8);
        make.top.equalTo(locationImage.mas_bottom).offset(8);
        make.width.equalTo(@(30));
        make.height.equalTo(@(20));
    }];

    [_remarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_latelLabel.mas_right).offset(8);
        make.top.equalTo(locationImage.mas_bottom).offset(8);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
}
-(void)setModel:(QYAttendanceListModel *)model{
}
/*
 private Integer attId; //考勤
 
 @Column(name="create_user_id")
 private Integer createUserId; //创建人
 
 @Column(name="create_time")
 private Timestamp createTime;//创建时间
 
 @Column(name="position")
 private String position; //位置或IP
 
 @Column(name="longitude")
 private String longitude; //经度
 
 @Column(name="latitude")
 private String latitude; //纬度
 
 @Column(name="att_Source")
 private Integer attSource; //打卡来源 1 pc端 2 手机端
 
 @Column(name="att_type")
 private Integer attType;//打卡类型  10上午上班签到   11下午上班签到   20上午下班签退 21下午下班签退
 @Column(name="att_state")
 private Integer attState;//打卡状态 1正常 2迟到 3早退 4外勤 7加班
 
 @Column(name="memo")
 private String memo;//备注

 */
-(void)setDataDictionary:(NSDictionary *)dataDictionary{
    _normalLabel.hidden=YES;
    _unNormalLabel.hidden=YES;
    _latelLabel.hidden=YES;
    _earyLabel.hidden=YES;
    _remarkButton.hidden=YES;
    _dataDictionary=dataDictionary;
    
    NSString *attType;
    if ([dataDictionary[@"attType"] intValue]==10) {
        //上午打卡
        attType=[NSString stringWithFormat:@"（计划上班时间%@）",dataDictionary[@"settingTime"]];
    }else{
        attType=[NSString stringWithFormat:@"（计划下班时间%@）",dataDictionary[@"settingTime"]];
    }
    NSString *timeString = [QYAttendanceListModel formatWithData:dataDictionary[@"createTime"]];
    NSString *newTimeString = [NSString stringWithFormat:@"打卡时间 %@",timeString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",newTimeString,attType]];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont baseTextLarge] range:NSMakeRange(0, newTimeString.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, newTimeString.length)];
    _timeAndState.attributedText=attributeString;
    if ([dataDictionary[@"outOfRange"] intValue]==0) {
        //内勤
        _normalLabel.hidden=NO;
        if ([dataDictionary[@"attState"] intValue]==1) {
            //正常（布局考勤和）
            if ([dataDictionary[@"memo"] isNotNil]) {
                _remarkButton.hidden=NO;
                [_remarkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_normalLabel.mas_right).offset(8);
                }];
            }else{
                _remarkButton.hidden=YES;
            }
        }else if ([dataDictionary[@"attState"] intValue]==2){
            //迟到
            _latelLabel.hidden=NO;
            [_latelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_normalLabel.mas_right).offset(8);
            }];
            if ([dataDictionary[@"memo"] isNotNil]) {
                _remarkButton.hidden=NO;
                [_remarkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_latelLabel.mas_right).offset(8);
                }];
            }else{
                _remarkButton.hidden=YES;
            }

        }else if ([dataDictionary[@"attState"] intValue]==3){
            //早退
            _earyLabel.hidden=NO;
            [_earyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_normalLabel.mas_left).offset(8+45);
            }];

            if ([dataDictionary[@"memo"] isNotNil]) {
                _remarkButton.hidden=NO;
                [_remarkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_earyLabel.mas_right).offset(8);
                }];
            }else{
                _remarkButton.hidden=YES;
            }
        }
    }else if ([dataDictionary[@"outOfRange"] intValue]==1){
        //外勤
        _unNormalLabel.hidden=NO;
        if ([dataDictionary[@"attState"] intValue]==1) {
            //正常
            if ([dataDictionary[@"memo"] isNotNil]) {
                _remarkButton.hidden=NO;
                [_remarkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_unNormalLabel.mas_right).offset(8);
                }];
            }else{
                _remarkButton.hidden=YES;
            }

        }else if ([dataDictionary[@"attState"] intValue]==2){
            //迟到
            _latelLabel.hidden=NO;
            [_latelLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_unNormalLabel.mas_right).offset(8);
            }];

            if ([dataDictionary[@"memo"] isNotNil]) {
                _remarkButton.hidden=NO;
                [_remarkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_latelLabel.mas_right).offset(8);
                }];
            }else{
                _remarkButton.hidden=YES;
            }

        }else if ([dataDictionary[@"attState"] intValue]==3){
            //早退
            _earyLabel.hidden=NO;
            [_earyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_unNormalLabel.mas_left).offset(8+30);
            }];

            if ([dataDictionary[@"memo"] isNotNil]) {
                _remarkButton.hidden=NO;
                [_remarkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_earyLabel.mas_right).offset(8);
                }];
            }else{
                _remarkButton.hidden=YES;
            }

        }

    }
    _localMessageLabel.text=dataDictionary[@"position"];

}

-(void)lookRemark{
    _gotoDetail(_dataDictionary[@"memo"],_dataDictionary[@"createTime"],_dataDictionary[@"position"]);
}
-(void)rePushCard{
    _refreshAttention(_dataDictionary[@"attType"]);
}

@end
