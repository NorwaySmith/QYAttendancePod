//
//  QYH5BlockButton.m
//  QYBaseProject
//
//  Created by 田 on 15/8/14.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYH5BlockButton.h"

@implementation QYH5BlockButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touchAction:(id)sender{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(self);
    }
}

@end
