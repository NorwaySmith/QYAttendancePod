//
//  QYMoreSearchResultCell.m
//  QYBaseProject
//
//  Created by lin on 15/6/25.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreSearchResultCell.h"
#import "QYTheme.h"
#import "Masonry.h"
#define _SCREENWIDTH [[UIScreen mainScreen] bounds].size.width


//titlelabel离上边界距离
static CGFloat const label_top_padding = 15;
//datailslable下边界的距离
static CGFloat const label_bottom_padding = 11;
//label离边的距离
static CGFloat const label_left_padding = 10;

@implementation QYMoreSearchResultCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setCompanyModel:(QYMoreSearchCompanyModel *)companyModel
{
    _companyModel = companyModel;
    
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 16)];
    _titleLabel = [UILabel new];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0];
    _titleLabel.tag = 1000;
    [self.contentView addSubview:_titleLabel];
    
//    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 14)];
    _detailLabel = [UILabel new];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    _detailLabel.tag = 1001;
    [self.contentView addSubview:_detailLabel];
    
    UIView* lineView=[[UIView alloc] init];
    lineView.backgroundColor=[UIColor themeSeparatorLineColor];
//    lineView.frame=CGRectMake(0, 64.5, _SCREENWIDTH, 0.5);
    [self.contentView addSubview:lineView];
    
    _titleLabel.text = companyModel.compyCode;
    _detailLabel.text = companyModel.compyName;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left).with.offset(label_left_padding);
        make.top.equalTo(self.mas_top).with.offset(label_top_padding);
        make.right.equalTo(self.mas_right).with.offset(-label_left_padding);
        make.height.equalTo(@(16));
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left).with.offset(label_left_padding);
        make.bottom.equalTo(self.mas_bottom).with.offset(-label_bottom_padding);
        make.right.equalTo(self.mas_right).with.offset(-label_left_padding);
        make.height.equalTo(@(14));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0.5);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
