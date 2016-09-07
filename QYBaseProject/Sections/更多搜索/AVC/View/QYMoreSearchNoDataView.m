//
//  QYMoreSearchNoDataView.m
//  QYBaseProject
//
//  Created by lin on 15/6/25.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreSearchNoDataView.h"
#import "Masonry.h"

//lable的高度
static CGFloat const label_height_padding = 30;
//label离边的距离
static CGFloat const label_left_padding = 10;

@implementation QYMoreSearchNoDataView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    UILabel * noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-250-30)/2, 320, 30)];
    UILabel *noDataLabel = [UILabel new];
    noDataLabel.backgroundColor = [UIColor clearColor];
    noDataLabel.textColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    noDataLabel.textAlignment = 1;
    noDataLabel.text = @"暂无信息";
    [self addSubview:noDataLabel];
    
    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(@((self.frame.size.height-250-30)/2));
        make.left.equalTo(self.mas_left).offset(label_left_padding);
        make.right.equalTo(self.mas_right).offset(-label_left_padding);
        make.height.equalTo(@(label_height_padding));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
