//
//  QYMoreDefaultCell.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreDefaultCell.h"
#import "QYTheme.h"
@implementation QYMoreDefaultCell
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
    self.textLabel.font=[UIFont themeCellTextLabelFont];
}
-(void)setMoreModel:(QYMoreModel *)moreModel{
    _moreModel=moreModel;
    self.imageView.image=_moreModel.image;
    self.textLabel.text=_moreModel.modelTitle;
}
@end
