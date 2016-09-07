//
//  QYNotificationView.m
//  QYNotificationViewTest
//
//  Created by 田 on 16/1/26.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYNotificationView.h"
#import "Masonry.h"
#import "QYNotificationManager.h"
/**
 *  图标宽度
 */
static CGFloat iconImageView_width=42;
/**
 *  图标左间距
 */
static CGFloat iconImageView_left=10;


/**
 *  标题上间距
 */
static CGFloat titleLabel_top=5;
/**
 *  标题左间距
 */
static CGFloat titleLabel_left=10;
/**
 *  标题右间距
 */
static CGFloat titleLabel_right=0;
/**
 *  标题高度
 */
static CGFloat titleLabel_height=16;
/**
 *  标题字号
 */
static CGFloat titleLabel_fontSize=16;


/**
 *  详情底部间距
 */
static CGFloat detailLabel_bottom=-5;
/**
 *  详情左间距
 */
static CGFloat detailLabel_left=10;
/**
 *  详情右间距
 */
static CGFloat detailLabel_right=0;
/**
 *  详情高度
 */
static CGFloat detailLabel_height=12;
/**
 *  详情字号
 */
static CGFloat detailLabel_fontSize=12;


/**
 *  关闭按钮宽度
 */
static CGFloat closeButton_width=60;
/**
 *  关闭按钮高度
 */
static CGFloat closeButton_height=60;
/**
 *  关闭按钮右间距
 */
static CGFloat closeButton_right=0;




@interface QYNotificationView()
/**
 *  左侧模块图标
 */
@property(nonatomic,strong)UIImageView *iconImageView;
/**
 *  标题
 */
@property(nonatomic,strong)UILabel *titleLabel;
/**
 *  详情
 */
@property(nonatomic,strong)UILabel *detailLabel;
/**
 *  点击回调block
 */
@property(nonatomic,copy)QYNotificationViewTap tapBlock;
@end
@implementation QYNotificationView
/**
 *  弹出QYNotificationView
 *
 *  @param text     标题
 *  @param detail   内容
 *  @param image    左侧图标
 *  @param duration 延时多长时间
 *  @param tapBlock 点击回调
 *
 *  @return QYNotificationView对象
 */
+ (QYNotificationView *) showWithText:(NSString*)text
                               detail:(NSString*)detail
                                image:(UIImage*)image
                             duration:(NSTimeInterval)duration
                             tapBlock:(QYNotificationViewTap)tapBlock{
    QYNotificationView *notificationView=[[QYNotificationView alloc] init];
    notificationView.iconImageView.image=image;
    notificationView.titleLabel.text=text;
    notificationView.detailLabel.text=detail;
    notificationView.duration=duration;
    notificationView.tapBlock=tapBlock;
    [[QYNotificationManager shared] addNotificationView:notificationView];
    return notificationView;
}
-(void)dealloc{
    _iconImageView=nil;
    _titleLabel=nil;
    _detailLabel=nil;
    _tapBlock=nil;
    _extend=nil;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self setupUI];
    }
    return self;

}
/**
 *  初始化UI
 */
-(void)setupUI{
    
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tapGestureRecognizer];

    self.backgroundColor=[UIColor colorWithRed:3.0/255.0 green:32.0/255.0 blue:44.0/255.0 alpha:0.9];
    [self.layer setCornerRadius:3.0];

    self.iconImageView=[[UIImageView alloc] init];
    [self addSubview:_iconImageView];

    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:titleLabel_fontSize];
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:detailLabel_fontSize];
    _detailLabel.numberOfLines = 1;
    _detailLabel.textAlignment = NSTextAlignmentLeft;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = [UIColor whiteColor];
    [self addSubview:_detailLabel];
    
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"notificationView_close"]
                 forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"notificationView_closeH"]
                 forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    closeButton.backgroundColor=[UIColor clearColor];
    [self addSubview:closeButton];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(iconImageView_width));
        make.height.equalTo(@(iconImageView_width));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@(iconImageView_left));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top).offset(titleLabel_top);
        make.left.equalTo(_iconImageView.mas_right).offset(titleLabel_left);
        make.right.equalTo(closeButton.mas_left).offset(titleLabel_right);
        make.height.equalTo(@(titleLabel_height));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_iconImageView.mas_bottom).offset(detailLabel_bottom);
        make.left.equalTo(_iconImageView.mas_right).offset(detailLabel_left);
        make.right.equalTo(closeButton.mas_left).offset(detailLabel_right);
        make.height.equalTo(@(detailLabel_height));
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(closeButton_right));
        make.width.equalTo(@(closeButton_width));
        make.height.equalTo(@(closeButton_height));
        make.centerY.equalTo(self.mas_centerY);
    }];
}
/**
 *  关闭按钮点击事件
 */
-(void)closeButtonClick{
    [self close];
}
/**
 *  背景点击事件
 */
-(void)tap{
    if (_tapBlock) {
        _tapBlock(self);
    }
    [self close];
}
-(void)close{
    [[QYNotificationManager shared] removeNotificationView:self];
}
@end
