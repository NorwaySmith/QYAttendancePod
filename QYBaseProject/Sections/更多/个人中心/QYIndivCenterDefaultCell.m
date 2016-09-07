//
//  QYIndivCenterDefaultCell.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYIndivCenterDefaultCell.h"
#import "QYTheme.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "NSString+ToolExtend.h"

@interface QYIndivCenterDefaultCell()

@property(nonatomic,strong)UILabel *rightLabel;
@property(nonatomic,strong)UILabel *leftLabel;

@end

@implementation QYIndivCenterDefaultCell

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
    self.leftLabel = [[UILabel alloc] init];
    _leftLabel.backgroundColor = [UIColor clearColor];
    _leftLabel.font = [UIFont themeCellTextLabelFont];
    _leftLabel.textColor = [UIColor baseTextBlack];
    _leftLabel.numberOfLines = 1;
    [self addSubview:_leftLabel];
    
    self.rightLabel = [[UILabel alloc] init];
    _rightLabel.backgroundColor = [UIColor clearColor];
    _rightLabel.numberOfLines = 2;
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.font = [UIFont themeCellDetailLabelFont];
    _rightLabel.textColor = [UIColor baseTextGreyLight];
    [self addSubview:_rightLabel];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(levelPadding);
        make.right.equalTo(_rightLabel.mas_left).offset(-padding);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(_leftLabel.mas_right).offset(padding);
        make.right.equalTo(self.mas_right).offset(-levelPadding);
    }];
}

- (void)setIndivCenterModel:(QYIndivCenterModel *)IndivCenterModel
{
    
    _IndivCenterModel = IndivCenterModel;
    
    _leftLabel.text = _IndivCenterModel.leftString;
    
    //NSLog(@"_IndivCenterModel====%@",_IndivCenterModel.rightString);
    
    if ([_IndivCenterModel.rightString isEqualToString:@"(null)"] || _IndivCenterModel.rightString == nil)
    {
        _rightLabel.text = @"";
    }
    else
    {
        _rightLabel.text = _IndivCenterModel.rightString;
    }
    
    CGSize leftLabelSize = [_leftLabel.text getStringSizeForFont:[UIFont themeCellTextLabelFont] maxSize:CGSizeMake(CGFLOAT_MAX, 30)];
    [_leftLabel mas_updateConstraints:^(MASConstraintMaker *make)
    {
        make.width.equalTo(@(leftLabelSize.width));
        make.right.equalTo(_rightLabel.mas_left).offset(-padding * 4);
    }];
    
    if (self.section == 0 && (self.row == 2 || self.row == 3))
    {
        [_rightLabel mas_updateConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.mas_right).offset(-35);
         }];
    }
    else
    {
        [_rightLabel mas_updateConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.mas_right).offset(-padding-4);
         }];
    }
}


@end
