//
//  QYNoNetworkView.m
//  QYBaseProject
//
//  Created by lin on 16/1/29.
//  Copyright (c) 2016年 lin. All rights reserved.
//

#import "QYNoNetworkView.h"
#import "IOSTool.h"
#import "Masonry.h"
@implementation QYNoNetworkView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        [self setupUI];

    }
    return self;
}
-(void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UIImage *noNetworkImage=[UIImage imageNamed:@"noNetworkBackground"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:noNetworkImage];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@(noNetworkImage.size.width));
        make.height.equalTo(@(noNetworkImage.size.height));

    }];
   
}
-(void)tap:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickNoNetworkView)]) {
        [_delegate didClickNoNetworkView];
    }
}
@end


