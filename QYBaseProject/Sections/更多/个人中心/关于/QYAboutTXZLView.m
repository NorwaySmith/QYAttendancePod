//
//  QYAboutTXZLView.m
//  QYBaseProject
//
//  Created by dzq on 15/7/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAboutTXZLView.h"

#import "Masonry.h"
#import "QYTheme.h"
#import "QYApplicationConfig.h"
@implementation QYAboutTXZLView

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
        [self setUI];
    }
    return self;
}


- (void)setUI
{
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 211)];
    logoView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
//    logoView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_logo"]];
    logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [logoView addSubview:logoImageView];
    
    UIEdgeInsets logoImageViewPadding = UIEdgeInsetsMake(25, 0, 0, 0);
    NSLayoutConstraint *logoImageViewTop =
    [NSLayoutConstraint constraintWithItem:logoImageView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:logoView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:logoImageViewPadding.top];
    NSLayoutConstraint *logoImageViewCenterX =
    [NSLayoutConstraint constraintWithItem:logoImageView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:logoView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    [logoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[logoImageView(>=161)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logoImageView)]];
    [logoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoImageView(>=138)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logoImageView)]];
    [logoView addConstraints:@[logoImageViewTop,logoImageViewCenterX]];
    
//    获取应用程序版本号
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildStr = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *appVersionStr = [infoDict objectForKey:@"CFBundleShortVersionString"];

//
    UILabel *appVersion = [[UILabel alloc] init];
    appVersion.textAlignment = NSTextAlignmentCenter;
    appVersion.textColor = [UIColor grayColor];
    appVersion.font = [UIFont systemFontOfSize:10];
    appVersion.translatesAutoresizingMaskIntoConstraints = NO;
    [logoView addSubview:appVersion];
    
    if(Channel == ChannelAppstore){
        //NSLog(@"ChannelAppstore");
        appVersion.text = [NSString stringWithFormat:@"iOS %@",appVersionStr];
    }else if (Channel == ChannelBeta) {
        appVersion.text = [NSString stringWithFormat:@"iOS %@(%@) 内测版",appVersionStr,appBuildStr];
    }
    
    UIEdgeInsets appVersionPadding = UIEdgeInsetsMake(0, 0, 0, 0);
    NSLayoutConstraint *appVersionTop =
    [NSLayoutConstraint constraintWithItem:appVersion
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:logoImageView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:appVersionPadding.top];
    NSLayoutConstraint *appVersionCenterX =
    [NSLayoutConstraint constraintWithItem:appVersion
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:logoView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    [logoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[appVersion(>=161)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(appVersion)]];
    [logoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[appVersion(>=35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(appVersion)]];
    [logoView addConstraints:@[appVersionTop,appVersionCenterX]];
    
//    分割线
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 210.4, [UIScreen mainScreen].bounds.size.width, 0.6)];
    separatorLine.backgroundColor = [UIColor themeSeparatorLineColor];
    [logoView addSubview:separatorLine];
    
    
    self.mTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mTableView.tableHeaderView = logoView;     //logoView 为表头部View
    [self addSubview:self.mTableView];
    [self removeTableViewLine];
}

-(void)removeTableViewLine
{
    self.mTableView.tableFooterView = [[UIView alloc] init];
    self.mTableView.backgroundColor = [UIColor baseTableViewBgColor];
}




@end
