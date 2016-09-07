//
//  QYAttendanceDetailOnCellView.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceDetailOnCellView.h"

//自动布局
#import "Masonry.h"
#import "QYTheme.h"

#import "UIColor+QYColorToHtmlColor.h"
@interface QYAttendanceDetailOnCellView(){
    
}
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

@end
@implementation QYAttendanceDetailOnCellView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.backgroundColor=[UIColor cSeparatorLineColor];
    
    _topLineView= [[UIView alloc] init];
    _topLineView.backgroundColor=[UIColor cSeparatorLineColor];
    [self addSubview:_topLineView];
    
    _bottomLineView= [[UIView alloc] init];
    _bottomLineView.backgroundColor=[UIColor cSeparatorLineColor];
    [self addSubview:_bottomLineView];
    
    _dateLabel=[[UILabel alloc] init];
    _dateLabel.font=[UIFont baseTextLarge];
    _dateLabel.textAlignment=NSTextAlignmentRight;
    _dateLabel.textColor=[UIColor colorWithRed:29.0/255.0 green:117.0/255.0 blue:93.0/255.0 alpha:1.0f];
    _dateLabel.text=@"日期";
    _dateLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:_dateLabel];

    _beforeNoon=[[UILabel alloc] init];
    _beforeNoon.font=[UIFont baseTextLarge];
    _beforeNoon.textAlignment=NSTextAlignmentCenter;
    _beforeNoon.textColor=[UIColor colorWithRed:29.0/255.0 green:117.0/255.0 blue:93.0/255.0 alpha:1.0f];
    _beforeNoon.text=@"上班";
    _beforeNoon.backgroundColor=[UIColor clearColor];
    [self addSubview:_beforeNoon];

    _afterNoon=[[UILabel alloc] init];
    _afterNoon.font=[UIFont baseTextLarge];
    _afterNoon.textAlignment=NSTextAlignmentLeft;
    _afterNoon.textColor=[UIColor colorWithRed:29.0/255.0 green:117.0/255.0 blue:93.0/255.0 alpha:1.0f];
    _afterNoon.text=@"下班";
    _afterNoon.backgroundColor=[UIColor clearColor];
    [self addSubview:_afterNoon];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(0.5));
    }];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(0.5));
    }];

    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(50));
        make.height.equalTo(@(12));
    }];
    [_beforeNoon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(50));
        make.height.equalTo(@(12));

    }];

    [_afterNoon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(50));
        make.height.equalTo(@(12));
    }];

}
@end
