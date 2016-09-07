//
//  QYSetSwitchCell.m
//  QYBaseProject
//
//  Created by 田 on 16/1/19.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYSetSwitchCell.h"
#import "QYTheme.h"
@interface QYSetSwitchCell()
/**
 *  cell右侧开关
 */
@property(nonatomic,strong)UISwitch *theSwitch;
@end
@implementation QYSetSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupUI];
    }
    return self;
}
/**
 *  配置UI
 */
-(void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;

    self.textLabel.font = [UIFont themeCellTextLabelFont];

    self.theSwitch = [[UISwitch alloc] init];
    self.theSwitch.onTintColor = [UIColor colorWithRed:37.0/255 green:182.0/255 blue:237.0/255 alpha:1.0];
    self.accessoryView = _theSwitch;
    [_theSwitch addTarget:self action:@selector(theSwitchChange:) forControlEvents:UIControlEventValueChanged];

}
/**
 *  开关状态改变的事件响应
 *
 *  @param sender 开关
 */
-(void)theSwitchChange:(id)sender {
    UISwitch *theSwitch = sender;
    if (_delegate && [_delegate respondsToSelector:@selector(switchCell:switchStateChange:)]) {
        [_delegate switchCell:self switchStateChange:theSwitch.on];
    }
}

-(void)setCellModel:(QYSetModel *)cellModel {
    _cellModel = cellModel;
    self.textLabel.text = _cellModel.leftText;
    _theSwitch.on = [_cellModel.rightValue boolValue];
}


@end
