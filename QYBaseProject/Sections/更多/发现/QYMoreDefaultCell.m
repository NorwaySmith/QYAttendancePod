//
//  QYMoreDefaultCell.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreDefaultCell.h"
#import "QYTheme.h"
#import "Masonry.h"
#import "UIImageView+Round.h"
#import "QYVersionHelper.h"


@interface QYMoreDefaultCell ()

@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *badgeView;


@end


@implementation QYMoreDefaultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    
//    头像
    self.headImage = [[UIImageView alloc] init];
//    _headImage.backgroundColor = [UIColor redColor];
    [self addSubview:_headImage];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top).offset((ThemeListHeightSingle - ThemeListCellHeadViewSize)/2);
        make.left.equalTo(@(16));
        make.bottom.equalTo(self.mas_bottom).offset(-(ThemeListHeightSingle - ThemeListCellHeadViewSize)/2);
        make.width.equalTo(@(ThemeListCellHeadViewSize));
//        make.height.equalTo(@(ThemeListCellHeadViewSize));
    }];
    
//    title
    self.titleLabel = [[UILabel alloc] init];
//    _titleLabel.backgroundColor = [UIColor redColor];
    _titleLabel.font = [UIFont themeCellTextLabelFont];
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top).offset((ThemeListHeightSingle - ThemeListCellHeadViewSize)/2);
        make.left.equalTo(_headImage.mas_right).offset(18);
        make.bottom.equalTo(self.mas_bottom).offset(-(ThemeListHeightSingle - ThemeListCellHeadViewSize)/2);
    }];
    
    self.badgeView = [[UIImageView alloc] init];
    _badgeView.backgroundColor = [UIColor redColor];
    _badgeView.hidden = YES;
    [_badgeView createRoundIconViewDiameter:8 obj:_badgeView];
    [self addSubview:_badgeView];
    
    [_badgeView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top).offset((ThemeListHeightSingle - 8)/2);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
        make.height.equalTo(@(8));
        make.width.equalTo(@(8));
    }];
    
}

-(void)setMoreModel:(QYMoreModel *)moreModel
{
    _moreModel = moreModel;
    
    self.headImage.image = _moreModel.image;
    self.titleLabel.text = _moreModel.modelTitle;
    if (_moreModel.isShowBadge) {
        _badgeView.hidden = NO;
    }else{
        _badgeView.hidden = YES;
    }
}


@end
