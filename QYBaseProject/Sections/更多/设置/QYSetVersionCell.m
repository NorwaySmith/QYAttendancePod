//
//  QYSetVersionCell.m
//  QYBaseProject
//
//  Created by 田 on 16/1/19.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYSetVersionCell.h"
#import "QYTheme.h"
#import "Masonry.h"
#import "UIImageView+Round.h"
@interface QYSetVersionCell()
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UIImageView *badgeView;

@end
@implementation QYSetVersionCell

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
    self.accessoryType = UITableViewCellAccessoryNone;

    self.textLabel.font = [UIFont themeCellTextLabelFont];

    self.rightLabel = [[UILabel alloc] init];
    _rightLabel.backgroundColor = [UIColor clearColor];
    _rightLabel.numberOfLines = 2;
    _rightLabel.font = [UIFont themeCellTextLabelFont];
    _rightLabel.textColor = [UIColor baseTextGreyLight];
    [self addSubview:_rightLabel];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.mas_top);
         make.bottom.equalTo(self.mas_bottom);
         make.right.equalTo(self.mas_right).offset(-padding-4);
     }];
    
    self.badgeView = [[UIImageView alloc] init];
    _badgeView.backgroundColor = [UIColor redColor];
    _badgeView.hidden = YES;
    [_badgeView createRoundIconViewDiameter:8 obj:_badgeView];
    [self addSubview:_badgeView];
    
    [_badgeView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.mas_top).offset((ThemeListHeightSingle - 8)/2);
         make.left.equalTo(_rightLabel.mas_right).offset(0);
         make.height.equalTo(@(8));
         make.width.equalTo(@(8));
     }];
    
}

-(void)setCellModel:(QYSetModel *)cellModel {
    _cellModel = cellModel;
    self.textLabel.text = _cellModel.leftText;
    _rightLabel.text = _cellModel.rightValue;
    
    if (_cellModel.isShowBadge) {
        _badgeView.hidden = NO;
    }else{
       _badgeView.hidden = YES;
    }
}


@end
