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
//间距
static CGFloat const padding = 8;
@interface QYMoreAvatarCell()
@property(nonatomic,strong)UIImageView *photoImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *companyLabel;
//@property(nonatomic,strong)UILabel *noPhotoTipLabel;
@end
@implementation QYMoreAvatarCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      		[self setupUI];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.photoImage = [[UIImageView alloc] init];
    _photoImage.backgroundColor = [UIColor clearColor];
    [self addSubview:_photoImage];
    
//    self.noPhotoTipLabel = [[UILabel alloc] init];
//    _noPhotoTipLabel.backgroundColor = [UIColor clearColor];
//    _noPhotoTipLabel.font = [UIFont systemFontOfSize:14];
//    _noPhotoTipLabel.textColor = [UIColor baseTextGreyLight];
//    [self addSubview:_noPhotoTipLabel];
    
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont themeCellTextLabelFont];
    _nameLabel.textColor = [UIColor baseTextBlack];
    _nameLabel.numberOfLines=1;
    [self addSubview:_nameLabel];
    
    self.companyLabel = [[UILabel alloc] init];
    _companyLabel.backgroundColor = [UIColor clearColor];
    _companyLabel.textAlignment = NSTextAlignmentLeft;
    _companyLabel.textColor = [UIColor baseTextGreyLight];
    _companyLabel.font = [UIFont themeCellDetailLabelFont];
    [self addSubview:_companyLabel];
    
    [_photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ThemeListPicSizeDouble));
        make.height.equalTo(@(ThemeListPicSizeDouble));
        make.top.equalTo(@((ThemeListHeightDouble-ThemeListPicSizeDouble)/2));
        make.left.equalTo(@((ThemeListHeightDouble-ThemeListPicSizeDouble)/2));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoImage.mas_right).offset(padding);
//        make.right.equalTo(self.mas_left).offset(-padding);
        make.top.equalTo(@(padding));
    }];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
//        make.right.equalTo(_nameLabel.mas_left).offset(-padding);
        make.bottom.equalTo(@(-padding));

    }];
    
}
-(void)setMoreModel:(QYMoreModel *)moreModel{
    _moreModel=moreModel;
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:_moreModel.imageUrl] placeholderImage:_moreModel.image];
    _nameLabel.text=_moreModel.userName;
    _companyLabel.text=_moreModel.companyName;
}
@end
