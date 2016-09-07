//
//  QYLoginSwitchUnitCell.m
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYLoginSwitchUnitCell.h"
#import "QYTheme.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#import "QYURLHelper.h"
#import "QYLoginConstant.h"
static NSString  *ModelCode          = @"ydzjMobile";

@interface QYLoginSwitchUnitCell()
/**
 *  公司 logo
 */
@property(nonatomic,strong)UIImageView *logoImage;
/**
 *  公司 名称
 */
@property(nonatomic,strong)UILabel *titleLabel;
/**
 *  当前登录公司标记
 */
@property(nonatomic,strong)UILabel *nowLabel;
/**
 *  公司 详情
 */
@property(nonatomic,strong)UILabel *detailLabel;

@end

@implementation QYLoginSwitchUnitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupUI];
    }
    return self;
}
/**
 *  组装界面
 */
-(void)setupUI
{
    self.logoImage = [[UIImageView alloc] init];
    [self addSubview:_logoImage];
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont themeCellTextLabelFont];
    _titleLabel.textColor = [UIColor baseTextBlack];
    _titleLabel.numberOfLines = 1;
    [self addSubview:_titleLabel];
    
    self.nowLabel = [[UILabel alloc] init];
    _nowLabel.text = QYLoginLocaleString(@"QYLoginSwitchUnitCell_now");
    _nowLabel.textAlignment = 2;
    _nowLabel.textColor = [UIColor baseTextGreyLight];
    _nowLabel.font = [UIFont themeCellDetailLabelFont];
    [self addSubview:_nowLabel];
    

    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.width.equalTo(@(ThemeListPicSizeDouble));
        make.height.equalTo(@(ThemeListPicSizeDouble));
        make.top.equalTo(@((ThemeListHeightDouble - ThemeListPicSizeDouble) / 2));
        make.left.equalTo(@((ThemeListHeightDouble - ThemeListPicSizeDouble) / 2));
    }];
    
    [_nowLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(@(-padding));
         make.centerY.equalTo(self.mas_centerY);
     }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(_logoImage.mas_right).offset(padding);
        make.right.equalTo(_nowLabel.mas_left).offset(-padding);
        make.centerY.equalTo(self.mas_centerY);
        
    }];

}
/**
 *  account set 方法
 */
-(void)setAccount:(QYAccount *)account
{
    _account = account;
    
    //单位logo
    NSString *logoImageString = account.companyLogo;
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"companyLogoView"];
    
    NSURL *logoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",urlString,logoImageString]];
    [_logoImage sd_setImageWithURL:logoURL placeholderImage:[UIImage imageNamed:@"login_switchUnit_defaultLogo"]];
    
    _titleLabel.text = _account.companyName;
    
    //是否当前单位
    _nowLabel.hidden = YES;
      QYAccount *defaultAccount = [[QYAccountService shared] defaultAccount];
        if ([_account.companyId isEqualToString:defaultAccount.companyId])
        {
            _nowLabel.hidden = NO;
        }
    
    //是否已停机
    _detailLabel.hidden = YES;
    if (_account.regesiter != 1)
    {
        _detailLabel.hidden = NO;
        _titleLabel.textColor = [UIColor baseTextGreyLight];
        _detailLabel.text = QYLoginLocaleString(@"QYLoginSwitchUnitCell_halt");
    }
}


@end
