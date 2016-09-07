//
//  QYMoreSearchButtonsView.m
//  QYBaseProject
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreSearchButtonsView.h"
#import "QYTheme.h"
#import "Masonry.h"

//按钮的宽高固定
static CGFloat const button_width_padding = 90;
static CGFloat const button_height_padding = 30;
//按钮离上边界距离
static CGFloat const button_top_padding = 50;
//lable的高度为21
static CGFloat const label_height_padding = 21;
//label离上边界距离
static CGFloat const label_top_padding = 20;
//label离边的距离
static CGFloat const label_left_padding = 10;

@implementation QYMoreSearchButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}
/**
 *  组装UI
 */
-(void)setupUI
{
    //    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 150, 21)];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:17.0];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"热门搜索";
    [self addSubview:label];
    
    //固定按钮的with为90 height 30
    CGFloat space = ([UIScreen mainScreen].bounds.size.width - 3*90)/4;
    //按钮标题暂时固定
    NSArray *titles = @[@"全亚通信",@"中国移动",@"宇通",
                        @"双汇",@"三全",@"郑煤集团",
                        @"安阳钢铁",@"神火集团",@"中原证券",
                        @"河南煤化",@"神马集团",@"天方药业"];
    for (int i = 0; i < titles.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(space + ((90+space)*(i%3)), 50 + 40*(i/3), 90, 30);
        [btn setTitleColor:[UIColor themeDarkgrayColor] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundImage:[UIImage imageNamed:@"search_sousuo_icon"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"search_sousuo_icon_hight"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.equalTo(self.mas_top).offset(button_top_padding + 40*(i/3));
            make.left.equalTo(self.mas_left).offset(space + ((90+space)*(i%3)));
            make.width.equalTo(@(button_width_padding));
            make.height.equalTo(@(button_height_padding));
        }];
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left).offset(label_left_padding);
        make.right.equalTo(self.mas_right).offset(-label_left_padding);
        make.top.equalTo(self.mas_top).offset(label_top_padding);
        make.height.equalTo(@(label_height_padding));
    }];
}

- (void)btnClick:(UIButton *)button
{
    if (_searchButtonClick)
    {
        _searchButtonClick(button.titleLabel.text);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
