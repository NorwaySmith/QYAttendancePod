//
//  QYLoginSwitchUnitCell.h
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 * 切换单位cell
 */
#import <UIKit/UIKit.h>
#import "QYAccountService.h"

@interface QYLoginSwitchUnitCell : UITableViewCell
/**
 *  账户信息
 */
@property(nonatomic,strong)QYAccount *account;
@end