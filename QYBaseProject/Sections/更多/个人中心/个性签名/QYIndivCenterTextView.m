//
//  QYIndivCenterTextView.m
//  QYBaseProject
//
//  Created by 田 on 15/6/10.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYIndivCenterTextView.h"
#import "QYTheme.h"
#import "Masonry.h"

//logo距上边间距
static CGFloat const numLabel_height = 20;
static CGFloat const numLabel_width = 110;

@interface QYIndivCenterTextView()<UITextViewDelegate>

@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,assign)NSInteger limitNum;

@property(nonatomic,strong)UIView *separatorLine;

@end

@implementation QYIndivCenterTextView

-(instancetype)initWithLimitNum:(NSInteger)limitNum
{
    self = [super init];
    if (self)
    {
        _limitNum = limitNum;
        [self setup];
    }
    return self;
}
-(void)setup
{
    self.delegate = self;
    self.textContainerInset = UIEdgeInsetsMake(padding, padding, 20,padding);
    
    self.separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [UIColor colorWithRed:6.0/255.0 green:182.0/255.0f blue:255.0/255.0 alpha:1.0];
    [self addSubview:_separatorLine];
    
    [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top).offset(50);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width - 20));
        make.height.equalTo(@1);
    }];
    
    
    self.numLabel = [[UILabel alloc] init];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.textColor = [UIColor baseTextGreyMiddle];
    [self addSubview:_numLabel];

    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(_separatorLine.mas_bottom).offset(5);
        make.right.equalTo(_separatorLine.mas_right).offset(-0);
        make.height.equalTo(@(numLabel_height));
        make.width.equalTo(@(numLabel_width));
    }];
    
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    NSInteger surplus = _limitNum - [self.text length];
    
    _numLabel.text = [NSString stringWithFormat:@"还可以输入%ld字",(long)surplus];
    _numLabel.textColor = [UIColor baseTextGreyLight];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger surplus = _limitNum - [textView.text length] - range.length;

    if (surplus < 0 && range.length == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger surplus = _limitNum - [textView.text length];
    if (surplus < 0)
    {
        textView.text = [textView.text substringToIndex:_limitNum];
    }
    _numLabel.text = [NSString stringWithFormat:@"还可以输入%ld字",surplus <= 0 ? 0 : surplus];
}

@end
