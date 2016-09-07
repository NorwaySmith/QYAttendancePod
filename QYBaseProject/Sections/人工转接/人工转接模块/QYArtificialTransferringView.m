//
//  QYArtificialTransferringView.m
//  QYBaseProject
//
//  Created by dzq on 15/7/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYArtificialTransferringView.h"

#import "QYTheme.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "QYAccount.h"
#import "QYAccountService.h"
#import "QYURLHelper.h"
#import "IOSTool.h"
//#import "QYNoticeDistributionHelper.h"
//#import <NoticeCBB/QYNoticeDistributionHelper.h>

#import "QYSysTool.h"

@implementation QYArtificialTransferringView

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
        [self setUIView];
        self.backgroundColor = [UIColor themeTableViewBackgroundColor];
    }
    return self;
}

- (void)setUIView
{
    int headWith = (self.frame.size.width - 20) /3;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@(290));
    }];
    
//    0、头像
    self.headImgaeView = [[UIImageView alloc] init];
//    _headImgaeView.backgroundColor = [UIColor redColor];
//    [_headImgaeView sd_setImageWithURL:[NSURL URLWithString:account.companyLogo] placeholderImage:nil];
    [self addSubview:_headImgaeView];
    
    [_headImgaeView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(bgView.mas_top).offset(30);
        make.centerX.equalTo(bgView.mas_centerX);
        make.height.equalTo(@(headWith));
        make.width.equalTo(@(headWith));
    }];
    
//    1、公司名称
    self.companyName = [[UILabel alloc] init];
//    _companyName.backgroundColor = [UIColor redColor];
    _companyName.font = [UIFont baseTextTitle];
    _companyName.numberOfLines = 2;
//    _companyName.text = @"北京全亚通信技术有限公司真实数据";
    _companyName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_companyName];
    
    [_companyName mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_headImgaeView.mas_bottom).offset(25);
         make.left.equalTo(bgView.mas_left).offset(15);
         make.right.equalTo(bgView.mas_right).offset(-15);
         make.centerX.equalTo(bgView.mas_centerX);
         make.height.equalTo(@(18));
     }];
    
//    1、公司标语
    self.companySlogan = [[UILabel alloc] init];
//    _companySlogan.text = account.slogan;
    _companySlogan.font = [UIFont baseTextMiddle];
    _companySlogan.textAlignment = NSTextAlignmentCenter;
    _companySlogan.textColor = [UIColor baseTextGreyLight];
//    _companySlogan.backgroundColor = [UIColor yellowColor];
    [self addSubview:_companySlogan];
    
    [_companySlogan mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.equalTo(bgView.mas_centerX);
         make.top.equalTo(_companyName.mas_bottom).offset(20);
         make.left.equalTo(bgView.mas_left).offset(10);
         make.right.equalTo(bgView.mas_right).offset(-10);
         make.height.equalTo(@(14));
     }];
    
//    2、人工转接号码
    self.arrtificialTransferrNum = [[UILabel alloc] init];
//    _arrtificialTransferrNum.text = [NSString stringWithFormat:@"人工转接号码：%@",account.companyPhone];
    _arrtificialTransferrNum.font = [UIFont baseTextLarge];
    _arrtificialTransferrNum.textAlignment = NSTextAlignmentCenter;
//    _arrtificialTransferrNum.backgroundColor = [UIColor redColor];
    [self addSubview:_arrtificialTransferrNum];
    
    [_arrtificialTransferrNum mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.equalTo(bgView.mas_centerX);
         make.top.equalTo(_companySlogan.mas_bottom).offset(20);
         make.left.equalTo(bgView.mas_left).offset(10);
         make.right.equalTo(bgView.mas_right).offset(-10);
         make.height.equalTo(@(16));
     }];
    
    UIButton *changeAritificialService = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeAritificialService setBackgroundImage:[UIImage imageNamed:@"zrgfw"] forState:UIControlStateNormal];
    changeAritificialService.layer.cornerRadius = 4;
    changeAritificialService.clipsToBounds = YES;
    [changeAritificialService addTarget:self action:@selector(changeAritificialServiceAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeAritificialService];
    
    [changeAritificialService mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.equalTo(self.mas_centerX);
         make.top.equalTo(bgView.mas_bottom).offset(buttonTopPadding);
         make.left.equalTo(self.mas_left).offset(buttonLeftOrRightPadding);
         make.right.equalTo(self.mas_right).offset(-buttonLeftOrRightPadding);
         make.height.equalTo(@(45));
     }];
    
}

- (void)setAccount:(QYAccount *)account
{
    _account = account;
    
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"headPictureView"];
    [_headImgaeView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",urlString,account.companyLogo]] placeholderImage:[UIImage imageNamed:@"HumanRelayWork_logo"]];
    
    _companyName.text = account.companyName;
    
    //需要计算 label  高度
//    CGFloat hight = [QYNoticeDistributionHelper getStringHeighForFont:[UIFont baseTextTitle] String:account.companyName Width:[QYDeviceInfo screenWidth] - 50];
   
    CGFloat hight=[account.companyName  getStringSizeForFont:[UIFont baseTextTitle] maxSize:CGSizeMake([QYDeviceInfo screenWidth] - 50, 100*100)].height;
    [_companyName mas_updateConstraints:^(MASConstraintMaker *make)
    {
        make.height.equalTo(@(ceilf(hight)));
    }];
    
    
    _companySlogan.text = account.slogan;
    _arrtificialTransferrNum.text = [NSString stringWithFormat:@"人工转接号码：%@",account.companyPhone];
    
}


- (void)changeAritificialServiceAction
{
    [QYSysTool makePhoneCall:[NSString stringWithFormat:@"tel://%@",self.account.companyPhone]];
}

@end
