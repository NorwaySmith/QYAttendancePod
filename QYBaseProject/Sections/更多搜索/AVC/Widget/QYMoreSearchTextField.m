//
//  QYMoreSearchTextField.m
//  QYBaseProject
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreSearchTextField.h"
#define _SCREENWIDTH [[UIScreen mainScreen] bounds].size.width

@implementation QYMoreSearchTextField

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, _SCREENWIDTH-80, 35);
        self.tintColor = [UIColor whiteColor];
        NSMutableAttributedString *sreachPlaceHolder = [[NSMutableAttributedString alloc] initWithString:@"请输入单位名称或集团号码"];
        [sreachPlaceHolder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, sreachPlaceHolder.length)];
        [sreachPlaceHolder addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, sreachPlaceHolder.length)];
        self.attributedPlaceholder = sreachPlaceHolder;

        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14];
        //左视图
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_more_search_icon"]];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width + 40, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
    }
    
    return self;
}

@end
