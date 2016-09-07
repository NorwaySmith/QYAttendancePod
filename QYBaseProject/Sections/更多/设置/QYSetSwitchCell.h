//
//  QYSetSwitchCell.h
//  QYBaseProject
//
//  Created by 田 on 16/1/19.
//  Copyright © 2016年 田. All rights reserved.
//
/**
 *  设置中开关cell
 */
#import <UIKit/UIKit.h>
#import "QYSetModel.h"
@class QYSetSwitchCell;

@protocol QYSetSwitchCellDelegate <NSObject>

-(void)switchCell:(QYSetSwitchCell*)cell switchStateChange:(BOOL)on;

@end


@interface QYSetSwitchCell : UITableViewCell

@property(nonatomic,weak)id <QYSetSwitchCellDelegate>delegate;

@property(nonatomic,strong) QYSetModel *cellModel;

@end
