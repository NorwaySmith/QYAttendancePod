//
//  QYIndivCenterAvatarCell.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYIndivCenterAvatarCell.h"
#import "QYTheme.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#import "QYAccount.h"
#import "QYAccountService.h"
#import "QYURLHelper.h"
#import "UIImageView+Round.h"

static NSString  *ModelCode          = @"ydzjMobile";

@interface QYIndivCenterAvatarCell()

@property(nonatomic,strong)UIImageView *photoImage;
@property(nonatomic,strong)UILabel *leftLabel;

@end

@implementation QYIndivCenterAvatarCell

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
-(void)setupUI
{
    self.photoImage = [[UIImageView alloc] init];
    _photoImage.backgroundColor = [UIColor clearColor];
//    [_photoImage createUnCustomFilletIconView:_photoImage];
    [_photoImage createRoundIconViewDiameter:ThemeListPicSizeDouble obj:_photoImage];
    
    [self addSubview:_photoImage];
    
    self.leftLabel = [[UILabel alloc] init];
    _leftLabel.backgroundColor = [UIColor clearColor];
    _leftLabel.font = [UIFont themeCellTextLabelFont];
    _leftLabel.textColor = [UIColor baseTextBlack];
    _leftLabel.numberOfLines = 1;
    [self addSubview:_leftLabel];
    
    [_photoImage mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.width.equalTo(@(ThemeListPicSizeDouble));
        make.height.equalTo(@(ThemeListPicSizeDouble));
        make.top.equalTo(@((ThemeListHeightDouble - ThemeListPicSizeDouble)/2));
        make.left.equalTo(self.mas_left).offset([UIScreen mainScreen].bounds.size.width - 35 - ThemeListPicSizeDouble);
        make.right.equalTo(@(-35));
    }];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(levelPadding);
        make.right.equalTo(_photoImage.mas_left).offset(-padding);
    }];
}

-(void)setIndivCenterModel:(QYIndivCenterModel *)IndivCenterModel
{
    _IndivCenterModel = IndivCenterModel;
    
    _leftLabel.text = _IndivCenterModel.leftString;
    
    //NSLog(@"取  _IndivCenterModel.imageUrl===%@",_IndivCenterModel.imageUrl);
    
    
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"headPictureView"];
    NSString *headImageURL = [NSString stringWithFormat:@"%@userId=%@&_clientType=wap&filePath=%@",urlString,account.userId,_IndivCenterModel.imageUrl];
    
    //从内存中区图片
    if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:headImageURL])
    {
        _photoImage.image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:headImageURL];
    }
    else
    {
        if (_IndivCenterModel.imageUrl != nil && ![_IndivCenterModel.imageUrl isEqualToString:@""])
        {
            [_photoImage sd_setImageWithURL:[NSURL URLWithString:headImageURL] placeholderImage:_IndivCenterModel.defaultImage];
        }
        else
        {
            [_photoImage sd_setImageWithURL:[NSURL URLWithString:_IndivCenterModel.imageUrl] placeholderImage:_IndivCenterModel.defaultImage];
        }
    }
}


@end
