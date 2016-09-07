//
//  QYMoreAvatarCell.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreAvatarCell.h"
#import "QYLoginSwitchUnitCell.h"
#import "QYTheme.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#import "QYURLHelper.h"
#import "UIImageView+Round.h"

static NSString  *ModelCode          = @"ydzjMobile";

@interface QYMoreAvatarCell()

@property (nonatomic,strong) UIImageView    *photoImage;
@property (nonatomic,strong) UILabel        *nameLabel;
@property (nonatomic,strong) UILabel        *companyLabel;

@end

@implementation QYMoreAvatarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupUI];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.photoImage = [[UIImageView alloc] init];
    _photoImage.backgroundColor = [UIColor redColor];
    
    [_photoImage createRoundIconViewDiameter:ThemeListCellInHeadSize obj:_photoImage];
    
    [self addSubview:_photoImage];
    
    [_photoImage mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.width.equalTo(@(ThemeListCellInHeadSize));
         make.top.equalTo(@((ThemeListCellHeight - ThemeListCellInHeadSize)/2));
         make.left.equalTo(@(levelPadding));
         make.height.equalTo(@(ThemeListCellInHeadSize));
         make.bottom.equalTo(@(-(ThemeListCellHeight - ThemeListCellInHeadSize)/2));
     }];
    
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont baseTextLarge];
    _nameLabel.textColor = [UIColor baseTextBlack];
    _nameLabel.numberOfLines = 1;
    [self addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
         make.top.equalTo(self.mas_top).offset(ThemeListCellHeight - ThemeListCellInHeadSize - 5);
         make.left.equalTo(_photoImage.mas_right).offset((ThemeListCellHeight - ThemeListCellInHeadSize)/2);
         make.right.equalTo(self.mas_right).offset(-(ThemeListHeightDouble - ThemeListPicSizeDouble)*2);
        make.height.equalTo(@15);
     }];

    self.companyLabel = [[UILabel alloc] init];
    _companyLabel.textAlignment = NSTextAlignmentLeft;
    _companyLabel.textColor = [UIColor baseTextGreyLight];
    _companyLabel.font = [UIFont baseTextMiddle];
    [self addSubview:_companyLabel];

    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(_nameLabel.mas_bottom).offset(11);
        make.left.equalTo(_photoImage.mas_right).offset((ThemeListCellHeight - ThemeListCellInHeadSize)/2);
        make.right.equalTo(self.mas_right).offset(-(ThemeListHeightDouble - ThemeListPicSizeDouble)*2);
        make.height.equalTo(@12);
    }];

}

- (void)setMoreModel:(QYMoreModel *)moreModel
{
    _moreModel = moreModel;
    //NSLog(@"_moreModel.imageUrl===%@",_moreModel.imageUrl);
    
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"headPictureView"];
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    
//     QYABUserModel *userModel = [QYABDb userWithUserId:account.userId];
    
    
    if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:@"headImage"])
    {
        _photoImage.image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:@"headImage"];
    }
    else
    {
        if (_moreModel.imageUrl != nil && ![_moreModel.imageUrl isEqualToString:@""])
        {
            NSString *headURL = [NSString stringWithFormat:@"%@userId=%@&_clientType=wap&filePath=%@",urlString,account.userId,_moreModel.imageUrl];
            [_photoImage sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:_moreModel.image];
        }
        else
        {
            [_photoImage sd_setImageWithURL:[NSURL URLWithString:_moreModel.imageUrl] placeholderImage:_moreModel.image];
        }
    }
    
    _nameLabel.text = _moreModel.userName;
    _companyLabel.text = _moreModel.companyName;
}



@end
