//
//  QYApplicationCell.m
//  QYBaseProject
//
//  Created by 田 on 15/6/13.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYApplicationCell.h"
#import "QYTheme.h"
#import "Masonry.h"
#import  "JSBadgeView.h"
#import "IOSTool.h"
#import "UIImageView+Round.h"


@interface QYApplicationCell()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) JSBadgeView *badgeView;
@property (strong, nonatomic) UIImageView *labelRed;



@end

@implementation QYApplicationCell

static CGFloat titleLabel_height = 20;
//static CGFloat iconView_width = 55;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.iconView = [[UIImageView alloc] init];
    [self addSubview:_iconView];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.mas_top).offset(20);
         make.centerX.equalTo(self.mas_centerX);
         make.width.equalTo(self.mas_width).offset(-45);
         make.height.equalTo(_iconView.mas_width);
     }];

    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont themeABGroupNumFont];
    _titleLabel.textColor = [UIColor themeMenuTitleColor];
    [self addSubview:_titleLabel];
    
    self.badgeView = [[JSBadgeView alloc] initWithParentView:_iconView
                                                   alignment:JSBadgeViewAlignmentTopRight];
    _badgeView.badgePositionAdjustment = CGPointMake(-5, 3);
    _badgeView.badgeStrokeColor = [UIColor cRedPointBackgroundColor];
    _badgeView.badgeBackgroundColor = [UIColor cRedPointBackgroundColor];
    _badgeView.badgeStrokeWidth = 2.5;
    _badgeView.badgeTextFont = [UIFont systemFontOfSize:13];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(_iconView.mas_bottom).offset(3);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.equalTo(@(titleLabel_height));
    }];
    
    self.labelRed = [[UIImageView alloc] init];
    _labelRed.hidden = YES;
    _labelRed.backgroundColor = [UIColor cRedPointBackgroundColor];
    [_labelRed createRoundIconViewDiameter:10 obj:_labelRed];
    [_iconView addSubview:_labelRed];
    
    [_labelRed mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(_iconView.mas_top).offset(-3);
        make.right.equalTo(_iconView.mas_right).offset(3);
        make.height.equalTo(@(10));
        make.width.equalTo(@(10));
    }];
}

-(void)setApplicationModel:(QYApplicationModel *)applicationModel
{
    _applicationModel = applicationModel;

    _iconView.image = _applicationModel.icon;
    _titleLabel.text = _applicationModel.title;
    
    _badgeView.badgeText = _applicationModel.badgeValue;

    //审批红点
    if (applicationModel.isBadge == YES)
    {
        _labelRed.hidden = NO;
    }
    else
    {
        _labelRed.hidden = YES;
    }
}


- (void)iconViewAction:(UIButton *)button
{
    if ([self.delegae respondsToSelector:@selector(collectionViewCellAction:)]) {
        [self.delegae collectionViewCellAction:self.itemIndex];
    }
}




@end
