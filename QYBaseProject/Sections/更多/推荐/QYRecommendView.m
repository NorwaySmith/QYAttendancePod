//
//  QYRecommendView.m
//  QYBaseProject
//
//  Created by dzq on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYRecommendView.h"

@implementation QYRecommendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
//    1、第一条信息
    UILabel *oneTitle = [[UILabel alloc] init];
    oneTitle.text = @"1、扫描二维码，可以直接下载，并安装";
    oneTitle.translatesAutoresizingMaskIntoConstraints = NO;
    oneTitle.tintColor = [UIColor colorWithRed:53.0/255 green:53.0/255 blue:53.0/255 alpha:1.0];
    oneTitle.font = [UIFont systemFontOfSize:16];
    [self addSubview:oneTitle];
    UIEdgeInsets oneTitlePadding = UIEdgeInsetsMake(20, 10, 0, 10);
    NSLayoutConstraint *oneTitleTop =
    [NSLayoutConstraint constraintWithItem:oneTitle
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:oneTitlePadding.top];
    NSLayoutConstraint *oneTitleLeft =
    [NSLayoutConstraint constraintWithItem:oneTitle
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:oneTitlePadding.left];
    NSLayoutConstraint *oneTitleRight =
    [NSLayoutConstraint constraintWithItem:oneTitle
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-oneTitlePadding.right];
    [self addConstraints:@[oneTitleTop,oneTitleLeft,oneTitleRight]];
    
    /*
//    2.注意事项
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"注意：若使用微信扫描的手机，请点击右上角的按钮选择“用浏览器打开”。";
    noticeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    noticeLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:114.0/255.0 blue:0.0/255.0 alpha:1.0];
    noticeLabel.font = [UIFont systemFontOfSize:14];
    noticeLabel.numberOfLines = 2;
    [self addSubview:noticeLabel];
    
    UIEdgeInsets noticePadding = UIEdgeInsetsMake(10, 35, 0, 0);
    NSLayoutConstraint *noticeTop =
    [NSLayoutConstraint constraintWithItem:noticeLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:oneTitle
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:noticePadding.top];
    NSLayoutConstraint *noticeLeft =
    [NSLayoutConstraint constraintWithItem:noticeLabel
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:noticePadding.left];
    
    NSLayoutConstraint *noticeRight =
    [NSLayoutConstraint constraintWithItem:noticeLabel
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:noticePadding.right];
    [self addConstraints:@[noticeTop,noticeLeft,noticeRight]];
    */
//    3、二维码ImageView
    UIImageView *QRCodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongxunzhuli_erweima_icon"]];
    QRCodeImageView.backgroundColor = [UIColor redColor];
    QRCodeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:QRCodeImageView];

    UIEdgeInsets QRCodePadding = UIEdgeInsetsMake(15, 60, 0, 60);
    NSLayoutConstraint *QRCodeTop =
    [NSLayoutConstraint constraintWithItem:QRCodeImageView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:oneTitle
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:QRCodePadding.top];
    NSLayoutConstraint *QRCodeLeft =
    [NSLayoutConstraint constraintWithItem:QRCodeImageView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:QRCodePadding.left];
    NSLayoutConstraint *QRCodeRight =
    [NSLayoutConstraint constraintWithItem:QRCodeImageView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-QRCodePadding.right];
    NSLayoutConstraint *QRCodeCenterX =
    [NSLayoutConstraint constraintWithItem:QRCodeImageView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    
    NSArray *QRCodeWithArray =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[QRCodeImageView(==200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(QRCodeImageView)];
    [self addConstraints:QRCodeWithArray];
    NSArray *QRCodeHeightArray =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[QRCodeImageView(==200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(QRCodeImageView)];
    [self addConstraints:QRCodeHeightArray];

    [self addConstraints:@[QRCodeTop,QRCodeLeft,QRCodeRight,QRCodeCenterX]];
    
//    1、第二条消息
    UILabel *twoTitle = [[UILabel alloc] init];
    twoTitle.text = @"2、通过发送短信的方式推荐好友安装";
    twoTitle.translatesAutoresizingMaskIntoConstraints = NO;
    twoTitle.tintColor = [UIColor colorWithRed:53.0/255 green:53.0/255 blue:53.0/255 alpha:1.0];
    twoTitle.font = [UIFont systemFontOfSize:16];
    [self addSubview:twoTitle];
    UIEdgeInsets twoTitlePadding = UIEdgeInsetsMake(30, 10, 0, 10);
    NSLayoutConstraint *twoTitleTop =
    [NSLayoutConstraint constraintWithItem:twoTitle
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:QRCodeImageView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:twoTitlePadding.top];
    NSLayoutConstraint *twoTitleLeft =
    [NSLayoutConstraint constraintWithItem:twoTitle
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:twoTitlePadding.left];
    NSLayoutConstraint *twoTitleRight =
    [NSLayoutConstraint constraintWithItem:twoTitle
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-twoTitlePadding.right];
    [self addConstraints:@[twoTitleTop,twoTitleLeft,twoTitleRight]];
    
//    2、 短信推荐 Button
    UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [recommendButton setBackgroundImage:[UIImage imageNamed:@"M_Recommend"] forState:UIControlStateNormal];
    [recommendButton setBackgroundImage:[UIImage imageNamed:@"M_Recommend_H"] forState:UIControlStateHighlighted];
    [recommendButton setTitle:@"短信推荐" forState:UIControlStateNormal];
    recommendButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [recommendButton setTintColor:[UIColor whiteColor]];
    [recommendButton addTarget:self action:@selector(recommendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:recommendButton];
    
    UIEdgeInsets recommendButtonPadding = UIEdgeInsetsMake(15, 4, 0, 4);
    NSLayoutConstraint *recommendButtonTop =
    [NSLayoutConstraint constraintWithItem:recommendButton
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:twoTitle
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:recommendButtonPadding.top];
   
    NSLayoutConstraint *recommendButtonLeft =
    [NSLayoutConstraint constraintWithItem:recommendButton
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:QRCodeImageView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:recommendButtonPadding.left];
    
    NSLayoutConstraint *recommendButtonRight =
    [NSLayoutConstraint constraintWithItem:recommendButton
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:QRCodeImageView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-recommendButtonPadding.right];
    
    NSLayoutConstraint *recommendButtonCenterX =
    [NSLayoutConstraint constraintWithItem:recommendButton
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    
    NSArray *recommendButtonWith =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[recommendButton(<=200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(recommendButton)];
    [self addConstraints:recommendButtonWith];
    NSArray *recommendButtonHeight =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[recommendButton(==45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(recommendButton)];
    [self addConstraints:recommendButtonHeight];
    
    [self addConstraints:@[recommendButtonTop,recommendButtonLeft,recommendButtonRight,recommendButtonCenterX]];
}


/**
 *  短信分享事件
 */
- (void)recommendButtonAction
{
    [self.delegate messageRecommendAction];
}




@end
