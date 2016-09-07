//
//  QYPersonalitySignatureView.m
//  QYBaseProject
//
//  Created by dzq on 15/7/2.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYPersonalitySignatureView.h"

#import "QYTheme.h"
#import "Masonry.h"


@implementation QYPersonalitySignatureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}


- (void)setUI
{
    UIControl *control = [[UIControl alloc] init];
    control.backgroundColor = [UIColor whiteColor];
    [control addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-0);
        make.right.equalTo(self.mas_right).offset(-0);
    }];
    
    
    self.textView = [[QYIndivCenterTextView alloc] initWithLimitNum:30];
    _textView.font = [UIFont themeTextInputFont];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.scrollEnabled = NO;
    [_textView becomeFirstResponder];
    [self addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(@(padding));
         make.left.equalTo(@(0));
         make.right.equalTo(@(0));
         make.height.equalTo(@(80));
     }];
}

- (void)bgAction
{
    [_textView resignFirstResponder];
}






@end
