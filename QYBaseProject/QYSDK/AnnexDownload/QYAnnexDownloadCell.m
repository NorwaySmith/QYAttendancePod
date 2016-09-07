//
//  QYAnnexDownloadCell.m
//  QYBaseProject
//
//  Created by 田 on 15/7/23.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAnnexDownloadCell.h"
#import "QYTheme.h"
#import "Masonry.h"
#import "QYAnnexDownloadIconHelper.h"
@interface QYAnnexDownloadCell()
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *annexNameLabel;
@property(nonatomic,strong)UILabel *sizeLabel;
@property(nonatomic,strong)UIButton *operationButton;

@end
@implementation QYAnnexDownloadCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    _iconImageView=[[UIImageView alloc] init];
  
    [self.contentView addSubview:_iconImageView];

    _annexNameLabel=[[UILabel alloc] init];
    _annexNameLabel.font=[UIFont themeAnnexTitleFont];
    _annexNameLabel.textColor=[UIColor themeAnnexTitleColor];
    [self.contentView addSubview:_annexNameLabel];
    
    _sizeLabel=[[UILabel alloc] init];
    _sizeLabel.font=[UIFont themeAnnexSizeFont];
    _sizeLabel.textColor=[UIColor themeAnnexSizeColor];
    [self.contentView addSubview:_sizeLabel];
    
    _operationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _operationButton.backgroundColor=[UIColor clearColor];
    [_operationButton setImage:[UIImage imageNamed:@"annex_operation"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_operationButton];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(ThemeListPicDistanceTop));
        make.left.equalTo(@(padding));
        make.width.equalTo(@(30));
        make.bottom.equalTo(@(-ThemeListPicDistanceTop));
 
    }];
    
    [_annexNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(ThemeListPicDistanceTop));
        make.left.equalTo(_iconImageView.mas_right).offset(padding);
        make.right.equalTo(_operationButton.mas_left).offset(padding);
        make.height.equalTo(@(20));
        
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_annexNameLabel.mas_bottom);
        make.left.equalTo(_iconImageView.mas_right).offset(padding);
        make.right.equalTo(_operationButton.mas_left).offset(padding);
        make.height.equalTo(@(20));
    }];
    
    [_operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.right.equalTo(@(0));
        make.width.equalTo(@(40));
        make.bottom.equalTo(@(0));
        
    }];
    
}
-(void)setAnnexDownloadModel:(QYAnnexDownloadModel *)annexDownloadModel{
    _annexDownloadModel=annexDownloadModel;
    _iconImageView.image=[QYAnnexDownloadIconHelper iconWithAnnexName:_annexDownloadModel.attachmentName];
    _annexNameLabel.text=_annexDownloadModel.attachmentName;
    _sizeLabel.text=_annexDownloadModel.fileSize;
    
}
-(void)operationButton:(id)sender{
    if ([_delegate respondsToSelector:@selector(operationButtonClick:)]) {
        [_delegate operationButtonClick:self];
    }
}
@end
