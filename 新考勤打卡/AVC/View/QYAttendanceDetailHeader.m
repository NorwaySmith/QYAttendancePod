//
//  QYAttendanceDetailHeader.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceDetailHeader.h"
//自动布局
#import "Masonry.h"

#import "QYDeviceInfo.h"

#import "UIColor+QYColorToHtmlColor.h"

#import "QYDeviceInfo.h"

#import "QYAttendanceDetailOnCellView.h"

#define ViewWidth self.frame.size.width
#define ViewHeight (CGFloat)[QYDeviceInfo screenWidth]/320*54

#define ButtonHeight 42
#define  SpaceToButtom 5
#define  listHeaderHeight 40

@interface QYAttendanceDetailHeader()
@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;

//月份
@property (nonatomic, strong)UILabel *monthLabel;

//正常考勤
@property (nonatomic, strong)UILabel *normalAttendanceLabel;

//迟到
@property (nonatomic, strong)UILabel *lateLabel;

//早退
@property (nonatomic, strong)UILabel *leaveEarlyLabel;

//未打卡
@property (nonatomic, strong)UILabel *notPunchLabel;

//list的头部
@property (nonatomic, strong)QYAttendanceDetailOnCellView *tableHeaderView;
@end

@implementation QYAttendanceDetailHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
//-(void)configureHeaderView{
//    _tableHeaderView = [[QYAttendanceDetailOnCellView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
//    _tableHeaderView.type=QYAttendanceDetailOnCellViewTypeHeader;
//    _tableView.tableHeaderView=_tableHeaderView;
//    
//}

-(void)setupUI{
    self.backgroundColor=[UIColor cImSeetingBackgroundColor];
    _leftButton = [[UIButton alloc] init];
    [_leftButton setImage:[UIImage imageNamed:@"QYAttendance_detail_headerLeft"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
//    _leftButton.backgroundColor=[UIColor yellowColor];
    [self addSubview:_leftButton];
    
    _rightButton = [[UIButton alloc] init];
    [_rightButton setImage:[UIImage imageNamed:@"QYAttendance_detail_headerRight"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
//    _rightButton.backgroundColor=[UIColor yellowColor];
    [self addSubview:_rightButton];

    _monthLabel = [[UILabel alloc] init];
    _monthLabel.font=[UIFont systemFontOfSize:16.0];
    _monthLabel.text=@"2016年5月";
    _monthLabel.textColor=[UIColor blackColor];
    _monthLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_monthLabel];
    
    UIImageView *mainView =[[UIImageView alloc] init];
    mainView.image=[UIImage imageNamed:@"QYAttendance_detail_headerCenter"];
    [self addSubview:mainView];
    
    //正常考勤
    _normalAttendanceLabel =[[UILabel alloc] init];
    _normalAttendanceLabel.text=@"0 天";
    _normalAttendanceLabel.textAlignment=NSTextAlignmentCenter;
    _normalAttendanceLabel.textColor=[UIColor blackColor];
    _normalAttendanceLabel.font=[UIFont systemFontOfSize:14.0];
    [self addSubview:_normalAttendanceLabel];
    
    //迟到
    _lateLabel =[[UILabel alloc] init];
    _lateLabel.text=@"0 次";
    _lateLabel.textAlignment=NSTextAlignmentCenter;
    _lateLabel.textColor=[UIColor blackColor];
    _lateLabel.font=[UIFont systemFontOfSize:14.0];
    [self addSubview:_lateLabel];

    //早退
    _leaveEarlyLabel =[[UILabel alloc] init];
    _leaveEarlyLabel.text=@"0 次";
    _leaveEarlyLabel.textAlignment=NSTextAlignmentCenter;
    _leaveEarlyLabel.textColor=[UIColor blackColor];
    _leaveEarlyLabel.font=[UIFont systemFontOfSize:14.0];
    [self addSubview:_leaveEarlyLabel];

    //未打卡
    _notPunchLabel =[[UILabel alloc] init];
    _notPunchLabel.text=@"0 次";
    _notPunchLabel.textAlignment=NSTextAlignmentCenter;
    _notPunchLabel.textColor=[UIColor blackColor];
    _notPunchLabel.font=[UIFont systemFontOfSize:14.0];
    [self addSubview:_notPunchLabel];

    //list头部
    _tableHeaderView = [[QYAttendanceDetailOnCellView alloc] init];
    _tableHeaderView.type=QYAttendanceDetailOnCellViewTypeHeader;
    [self addSubview:_tableHeaderView];

    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_centerX).offset(-50);
        make.width.equalTo(@(50));
        make.height.equalTo(@(ButtonHeight));
    }];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_centerX).offset(50);
        make.width.equalTo(@(50));
        make.height.equalTo(@(ButtonHeight));
    }];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(100));
        make.height.equalTo(@(32));
    }];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(ButtonHeight);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(ViewWidth));
        make.height.equalTo(@(ViewHeight));
    }];
    [_normalAttendanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_left);
        make.bottom.equalTo(mainView.mas_bottom).offset(-10);
        make.width.equalTo(@(ViewWidth/4));
        make.height.equalTo(@(20));

    }];
    [_lateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainView.mas_centerX);
        make.bottom.equalTo(mainView.mas_bottom).offset(-10);
        make.width.equalTo(@(ViewWidth/4));
        make.height.equalTo(@(20));

    }];
    [_leaveEarlyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView.mas_centerX);
        make.bottom.equalTo(mainView.mas_bottom).offset(-10);

        make.width.equalTo(@(ViewWidth/4));
        make.height.equalTo(@(20));

    }];
    [_notPunchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainView.mas_right);
        make.bottom.equalTo(mainView.mas_bottom).offset(-10);
        make.width.equalTo(@(ViewWidth/4));
        make.height.equalTo(@(20));

    }];

    [_tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(listHeaderHeight));
    }];
}
-(void)lastMonth{
    if ([_headerDelegate respondsToSelector:@selector(lastMonthClick)]) {
        [_headerDelegate lastMonthClick];
    }
}
-(void)nextMonth{
    if ([_headerDelegate respondsToSelector:@selector(nextMonthClick)]) {
        [_headerDelegate nextMonthClick];
    }
}

-(void)setCurrentDictionary:(NSDictionary *)currentDictionary{
    _currentDictionary=currentDictionary;
    //@"localKey", @"dataKey"
    //选择月份控件更新
    _monthLabel.text=[NSString stringWithFormat:@"%@年%@月",currentDictionary[@"localKey"][@"year"],currentDictionary[@"localKey"][@"month"]];
    
    // 详细数据更新
    NSDictionary *detailDictionary = currentDictionary[@"dataKey"];
    NSString *normalString =[NSString stringWithFormat:@"%@ 天",detailDictionary[@"normalCounts"]?detailDictionary[@"normalCounts"]:@"0"];
    NSMutableAttributedString *mutableAtrributeNormalString = [[NSMutableAttributedString alloc] initWithString:normalString];
    [mutableAtrributeNormalString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, normalString.length-1)];
    _normalAttendanceLabel.attributedText=mutableAtrributeNormalString;
    
    NSString *lateLabel =[NSString stringWithFormat:@"%@ 次",detailDictionary[@"lateCounts"]?detailDictionary[@"lateCounts"]:@"0"];
    NSMutableAttributedString *mutableAtrributeLateLabel = [[NSMutableAttributedString alloc] initWithString:lateLabel];
    [mutableAtrributeLateLabel addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, lateLabel.length-1)];
//    [mutableAtrributeLateLabel addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, lateLabel.length-1)];

    _lateLabel.attributedText=mutableAtrributeLateLabel;

    NSString *leaveEarly =[NSString stringWithFormat:@"%@ 次",detailDictionary[@"leaveCounts"]?detailDictionary[@"leaveCounts"]:@"0"];
    NSMutableAttributedString *mutableAtrributeLeaveEarly = [[NSMutableAttributedString alloc] initWithString:leaveEarly];
    [mutableAtrributeLeaveEarly addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, leaveEarly.length-1)];
//    [mutableAtrributeLeaveEarly addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, leaveEarly.length-1)];
    _leaveEarlyLabel.attributedText=mutableAtrributeLeaveEarly;

    NSString *notPunch =[NSString stringWithFormat:@"%@ 次",detailDictionary[@"lackCounts"]?detailDictionary[@"lackCounts"]:@"0"];
    NSMutableAttributedString *mutableAtrributeNotPunch = [[NSMutableAttributedString alloc] initWithString:notPunch];
    [mutableAtrributeNotPunch addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, notPunch.length-1)];
//    [mutableAtrributeNotPunch addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:56.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0f] range:NSMakeRange(0, notPunch.length-1)];
    _notPunchLabel.attributedText=mutableAtrributeNotPunch;

//    _normalAttendanceLabel.text=[NSString stringWithFormat:@"%@天",detailDictionary[@"normal"]];
//    _lateLabel.text=[NSString stringWithFormat:@"%@次",detailDictionary[@"late"]];
//    _leaveEarlyLabel.text=[NSString stringWithFormat:@"%@次",detailDictionary[@"early"]];
//    _notPunchLabel.text=[NSString stringWithFormat:@"%@次",detailDictionary[@"noSign"]];
}
+(CGFloat)getHoleViewHeight{
    return ButtonHeight+ViewHeight+SpaceToButtom+listHeaderHeight;
}
@end
