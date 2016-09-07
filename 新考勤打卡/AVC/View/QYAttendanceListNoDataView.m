//
//  QYAttendanceListNoDataView.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/16.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceListNoDataView.h"
#import "QYTheme.h"
#import "Masonry.h"

@interface QYAttendanceListNoDataView()

@property (nonatomic,strong) UIImageView                *imageView;

@property (nonatomic,strong) UILabel                    *titleLabel;

@end


/**
 *  电话会议空视图控件类实现
 */
@implementation QYAttendanceListNoDataView

#pragma mark - lift cycle
- (instancetype)init {
    self = [super init];
    if (self) {
//        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupSetUI];
    }
    return self;
}
-(void)setType:(QYAttedanceListDataType)type{
    _type=type;
    if (type==QYAttedanceListDataTypeNotSetTheProgram) {
        [self setupSetUI];
    }else if (type==QYAttedanceListDataTypeNoRecord){
        [self setupUI];
    }
}
#pragma mark - private methods
-(void)setupSetUI{
    
    // 初始化提示控件
    _titleLabel = [[UILabel alloc] init];
    // 设置提示控件文字水平位置
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    // 设置提示控件字体颜色
    [_titleLabel setTextColor:[UIColor blackColor]];
    // 设置提示控件字体
    [_titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    _titleLabel.numberOfLines=2;
    _titleLabel.text = @"您当前不在考勤组内\n管理员可以登录后台设定考勤组";
    [self addSubview:_titleLabel];
    
    // 设置布局约束
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(50);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(40));
    }];
}

/**
 *  设置空视图界面
 */
- (void)setupUI {
    UIImage *noDataImage = [UIImage imageNamed:@"base_noDataImage"];
    self.imageView = [[UIImageView alloc]initWithImage:noDataImage];
    [self addSubview:_imageView];
    
    // 初始化提示控件
    _titleLabel = [[UILabel alloc] init];
    // 设置提示控件文字水平位置
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    // 设置提示控件字体颜色
    [_titleLabel setTextColor:[UIColor lightGrayColor]];
    // 设置提示控件字体
    [_titleLabel setFont:[UIFont baseTextMiddle]];
    _titleLabel.text = @"暂无考勤记录";
    [self addSubview:_titleLabel];
    
    // 设置布局约束
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(70);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@([_titleLabel.font lineHeight]));
    }];
}



@end
