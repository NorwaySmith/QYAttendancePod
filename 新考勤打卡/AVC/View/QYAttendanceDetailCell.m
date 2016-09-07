//
//  QYAttendanceDetailCell.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceDetailCell.h"
#import "QYAttendanceDetailOnCellView.h"
#import "QYDeviceInfo.h"
#import "Masonry.h"
#import "UIColor+QYColorToHtmlColor.h"
#import "QYAttendanceListModel.h"
#import "QYTheme.h"

@interface QYAttendanceDetailCell()
@property (nonatomic, strong)QYAttendanceDetailOnCellView *mainViw;


//日期
@property (nonatomic, strong)UILabel *dateLabel;

//上午
@property (nonatomic, strong)UILabel *beforeNoon;

//下午
@property (nonatomic, strong)UILabel *afterNoon;

//头部线，只有header的时候才显示
@property (nonatomic, strong)UIView *topLineView;

//底部线
@property (nonatomic, strong)UIView *bottomLineView;

//beforeNoon查看备注详情
@property (nonatomic, strong)UIButton *beforeNoonButton;

//afterNoon查看备注详情
@property (nonatomic, strong)UIButton *afterNoonButton;

@end

@implementation QYAttendanceDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self configureUI];
    }
    return self;
}
-(void)configureUI{
    self.backgroundColor=[UIColor clearColor];
//    _mainViw= [[QYAttendanceDetailOnCellView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], self.frame.size.height)];
//    _mainViw.center=self.center;
//    _mainViw.type=QYAttendanceDetailOnCellViewTypeCell;
//    _mainViw.backgroundColor=[UIColor whiteColor];
//    [self addSubview:_mainViw];
    
    _bottomLineView= [[UIView alloc] init];
    _bottomLineView.backgroundColor=[UIColor cSeparatorLineColor];
    [self addSubview:_bottomLineView];
    
    _dateLabel=[[UILabel alloc] init];
    _dateLabel.font=[UIFont baseTextMiddle];
    _dateLabel.textAlignment=NSTextAlignmentCenter;
    _dateLabel.textColor=[UIColor blackColor];
    _dateLabel.text=@"5月11日";
    _dateLabel.backgroundColor=[UIColor clearColor];
//    _dateLabel.backgroundColor=[UIColor colorWithRed: arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0f];
    [self addSubview:_dateLabel];
    
    _beforeNoon=[[UILabel alloc] init];
    _beforeNoon.font=[UIFont baseTextMini];
    _beforeNoon.textAlignment=NSTextAlignmentCenter;
    _beforeNoon.textColor=[UIColor whiteColor];
    _beforeNoon.numberOfLines=2;
    _beforeNoon.text=@"未打卡";
//    _beforeNoon.backgroundColor=[UIColor colorWithRed: arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0f];
    
    [self addSubview:_beforeNoon];
    
    _afterNoon=[[UILabel alloc] init];
    _afterNoon.font=[UIFont baseTextMini];
    _afterNoon.textAlignment=NSTextAlignmentCenter;
    _afterNoon.textColor=[UIColor whiteColor];
    _afterNoon.numberOfLines=2;
    _afterNoon.text=@"正常";
//    _afterNoon.backgroundColor=[UIColor colorWithRed: arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0f];
    [self addSubview:_afterNoon];
    
    _beforeNoonButton = [[UIButton alloc] init];
    [_beforeNoonButton setBackgroundImage:[UIImage imageNamed:@"QYAttendance_detail_memo"] forState:UIControlStateNormal];
    _beforeNoonButton.tag=101;
    [_beforeNoonButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_beforeNoonButton];
    
    _afterNoonButton = [[UIButton alloc] init];
    [_afterNoonButton setBackgroundImage:[UIImage imageNamed:@"QYAttendance_detail_memo"] forState:UIControlStateNormal];
    _afterNoonButton.tag=102;
    [_afterNoonButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_afterNoonButton];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(0.5));
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(80));
        make.height.equalTo(@(20));
    }];
    [_beforeNoon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(@(50));
        make.height.equalTo(@(40));
        make.left.greaterThanOrEqualTo(self.mas_left).offset(30);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-30);
    }];
    
    [_afterNoon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-30);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(@(80));
//        make.height.equalTo(@(20));
//        make.top.equalTo(_beforeNoon.mas_top);
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX).offset(self.frame.size.width/3+15);
        make.height.equalTo(@(40));
        make.left.greaterThanOrEqualTo(_beforeNoon.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-20);
    }];
    [_beforeNoonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beforeNoon.mas_right);
        make.top.equalTo(_beforeNoon.mas_top).offset(14);
//        make.width.equalTo(@(21));
//        make.height.equalTo(@(15));
        make.width.equalTo(@(19));
        make.height.equalTo(@(13));

    }];
    [_afterNoonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_afterNoon.mas_right);
        make.top.equalTo(_afterNoon.mas_top).offset(14);
//        make.width.equalTo(@(21));
//        make.height.equalTo(@(15));
        make.width.equalTo(@(19));
        make.height.equalTo(@(13));
    }];
    
}
-(void)setDataDictionary:(NSDictionary *)dataDictionary{
    _dataDictionary=dataDictionary;
    //			recordTime：打卡日期
//onAttState:上午打卡状态 1正常2迟到3早退 5却卡6不需要打卡而且没有打卡展示空 7加班
//onTime:上午打卡时间
//onOutOfRange:0正常打卡1外勤打卡
//onMemo:上午打卡备注
//offAttState:下午打卡状态 1正常2迟到3早退 5却卡6不需要打卡而且没有打卡展示空 7加班
//offTime:下午打卡时间
//offOutOfRange:0正常打卡1外勤打卡
//offMemo:下午打卡备注
//    迟到、早退、正常、外勤、缺卡
//    外勤+迟到：显示迟到
//    外勤+早退：显示早退
//    外勤+正常：显示外勤
    
//    NSArray *stateArray = [NSArray arrayWithObjects:@"迟到", @"早退",@"正常",@"外勤外勤外勤",@"缺卡外勤外勤外勤",nil];
//    int index = (arc4random() % stateArray.count);
    _beforeNoon.textColor=[UIColor blackColor];
    _afterNoon.textColor=[UIColor blackColor];
//    _beforeNoon.text =stateArray[index];
//    _afterNoon.text=stateArray[index];
    _dateLabel.text=  [NSString stringWithFormat:@"%@(%@)",[QYAttendanceListModel secondFormatWithData:dataDictionary[@"recordTime"]],[QYAttendanceListModel featureWeekdayWithDate:dataDictionary[@"recordTime"]]];
    _beforeNoon.text=@"";
    _afterNoon.text=@"";
    NSString *beforeState;
    switch ([dataDictionary[@"onAttState"] intValue]) {
        case 1:
            beforeState=@"(正常)";
            break;
        case 2:
            beforeState=@"(迟到)";
            break;
        case 3:
            beforeState=@"(早退)";
            break;
        case 5:
            beforeState=@"缺卡";
            break;
        case 6:
            beforeState=@"(正常)";
            break;
        case 7:
            beforeState=@"加班";
            break;
    
        default:
            break;
    }
    NSString *beforeTime = [QYAttendanceListModel formatWithData:dataDictionary[@"onTime"]]?[QYAttendanceListModel formatWithData:dataDictionary[@"onTime"]]:@"";
    if ([beforeTime isNotNil]) {
        NSMutableAttributedString *beforeAttributeString;
        if (![beforeState isEqualToString:@"(正常)"]) {
            if ([beforeState isEqualToString:@"加班"]) {
                NSString *outOfStrangeString = [NSString stringWithFormat:@"%@",dataDictionary[@"onOutOfRange"]];
                if ([outOfStrangeString isEqualToString:@"1"]) {
                    beforeState = @"外勤—加班";
                }
                beforeAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",beforeTime,beforeState]];
                [beforeAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(beforeTime.length+1, beforeState.length)];

            }else{
                beforeAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",beforeTime,beforeState]];
                [beforeAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(beforeTime.length+1, beforeState.length)];
            }
        }else{
            beforeAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",beforeTime]];
        }
        [beforeAttributeString addAttribute:NSFontAttributeName value:[UIFont baseTextMiddle] range:NSMakeRange(0, beforeTime.length)];
        
        _beforeNoon.attributedText=beforeAttributeString;
    }else{
        NSMutableAttributedString *beforeAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",beforeTime,beforeState]];
        if (![beforeState isEqualToString:@"(正常)"]) {
            [beforeAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, beforeState.length)];
            [beforeAttributeString addAttribute:NSFontAttributeName value:[UIFont baseTextMiddle] range:NSMakeRange(0, beforeState.length)];
            _beforeNoon.attributedText=beforeAttributeString;
        }
        else{
            _beforeNoon.text=@"—";
        }
        
    }
    
    NSString *afterState;
    switch ([dataDictionary[@"offAttState"] intValue]) {
        case 1:
            afterState=@"(正常)";
            break;
        case 2:
            afterState=@"(迟到)";
            break;
        case 3:
            afterState=@"(早退)";
            break;
        case 5:
            afterState=@"缺卡";
            break;
        case 6:
            afterState=@"(正常)";
            break;
        case 7:
            afterState=@"加班";
            break;
            
        default:
            break;
    }

    NSString *afterTime = [QYAttendanceListModel formatWithData:dataDictionary[@"offTime"]]?[QYAttendanceListModel formatWithData:dataDictionary[@"offTime"]]:@"";
    if ([afterTime isNotNil]) {
        NSMutableAttributedString *afterAttributeString;
        if (![afterState isEqualToString:@"(正常)"]) {
            if ([afterState isEqualToString:@"加班"]) {
                NSString *outOfStrangeString = [NSString stringWithFormat:@"%@",dataDictionary[@"offOutOfRange"]];
                if ([outOfStrangeString isEqualToString:@"1"]) {
                    afterState = @"外勤—加班";
                }
                afterAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",afterTime,afterState]];
                [afterAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(afterTime.length+1, afterState.length)];
                
            }else{
                afterAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",afterTime,afterState]];
                [afterAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(afterTime.length+1, afterState.length)];
            }
        }else{
            afterAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",afterTime]];
        }
        [afterAttributeString addAttribute:NSFontAttributeName value:[UIFont baseTextMiddle] range:NSMakeRange(0, afterTime.length)];
        _afterNoon.attributedText=afterAttributeString;
    }else{
        NSMutableAttributedString *afterAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",afterState]];
        if (![afterState isEqualToString:@"(正常)"]) {
            [afterAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, afterState.length)];
            [afterAttributeString addAttribute:NSFontAttributeName value:[UIFont baseTextMiddle] range:NSMakeRange(0, afterState.length)];
            _afterNoon.attributedText=afterAttributeString;
        }else{
            _afterNoon.text=@"—";
        }
    }

    if ([dataDictionary[@"onMemo"] isNotNil ]) {
        _beforeNoonButton.hidden=NO;
    }else{
        _beforeNoonButton.hidden=YES;
    }
    if ([dataDictionary[@"offMemo"] isNotNil ]) {
        _afterNoonButton.hidden=NO;
    }else{
        _afterNoonButton.hidden=YES;
    }
    
//    _dateLabel.text=dataDictionary[@"recordTime"];
//    _beforeNoon.text=dataDictionary[@"amOn"];
//    _afterNoon.text=dataDictionary[@"pmOff"];
//    if ([dataDictionary[@"onAttState"] isEqualToString:@"迟到"]) {
//        _beforeNoon.textColor=[UIColor redColor];
//    }else if ([dataDictionary[@"amOn"] isEqualToString:@"未打卡"]){
//        _beforeNoon.textColor=[UIColor colorWithRed:56.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0f];
//    }else if ([dataDictionary[@"amOn"] isEqualToString:@"早退"]){
//        _beforeNoon.textColor=[UIColor orangeColor];
//    }else{
//        _beforeNoon.textColor=[UIColor blackColor];
//    }
//    
//    if ([dataDictionary[@"pmOff"] isEqualToString:@"迟到"]) {
//        _afterNoon.textColor=[UIColor redColor];
//    }else if ([dataDictionary[@"pmOff"] isEqualToString:@"未打卡"]){
//        _afterNoon.textColor=[UIColor colorWithRed:56.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0f];
//    }else if ([dataDictionary[@"pmOff"] isEqualToString:@"早退"]){
//        _afterNoon.textColor=[UIColor orangeColor];
//    }else{
//        _afterNoon.textColor=[UIColor blackColor];
//    }

}
-(void)buttonClick:(id)sender{
    UIButton *button = (id)sender;
    if (button.tag==101) {
        _detailMemo(_dataDictionary, YES);
    }else{
        _detailMemo(_dataDictionary, NO);
    }
}
@end
