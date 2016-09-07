//
//  QYSetDefaultCell.m
//  QYBaseProject
//
//  Created by 田 on 16/1/19.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYSetDefaultCell.h"
#import "QYTheme.h"
@implementation QYSetDefaultCell

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
    self.textLabel.font = [UIFont themeCellTextLabelFont];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

}
-(void)setCellModel:(QYSetModel *)cellModel{
    _cellModel = cellModel;
    
    self.textLabel.text = _cellModel.leftText;
}


@end
