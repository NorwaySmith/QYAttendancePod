//
//  QYMoreSearchResultDetailViewController.m
//  QYBaseProject
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreSearchResultDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "QYURLHelper.h"
#import "IOSTool.h"

@interface QYMoreSearchResultDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *qiYeKouHao;
@property (weak, nonatomic) IBOutlet UILabel *switchTelephone;
@property (weak, nonatomic) IBOutlet UITextView *companyDescripaton;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@end

@implementation QYMoreSearchResultDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"企业详情";
    
    //显示公司信息
    [self showCompanyDetail];
}

- (void)showCompanyDetail
{
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"companyLogoView"];
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",urlString,_companyModel.compyLogo]] placeholderImage:[UIImage imageNamed:@"search_HumanRelayWork_logo"]];
    
    self.companyName.text = _companyModel.compyName;
    self.switchTelephone.text = _companyModel.compyCode;
    
    if ([_companyModel.compySlogan isEqualToString:@"(null)"] || !_companyModel.compySlogan || [_companyModel.compySlogan isEqualToString:@""])
    {
        self.qiYeKouHao.text = @"内通外联 ∙ 沟通无限";
    }
    else
    {
        self.qiYeKouHao.text = _companyModel.compySlogan;
    }
    
    self.companyDescripaton.editable = NO;
    NSString *noticeString;
    if ([_companyModel.compyTxt isEqualToString:@""])
    {
        noticeString = @"暂无简介";
    }
    else
    {
        noticeString = _companyModel.compyTxt;
    }
    self.companyDescripaton.text=noticeString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callAction:(UIButton *)sender
{
    [QYSysTool makePhoneCall:[NSString stringWithFormat:@"tel://%@", _companyModel.compyCode]];
}


@end
