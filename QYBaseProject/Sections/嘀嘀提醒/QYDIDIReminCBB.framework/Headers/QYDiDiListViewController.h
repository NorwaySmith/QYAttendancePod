//
//  QYDiDiListViewController.h
//  QYBaseProject
//
//  Created by 小海 on 15/8/21.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  嘀嘀模块嘀嘀列表
 */

#import "QYViewController.h"
#import <QYAddressBook/QYABProtocol.h>

@interface QYDiDiListViewController : QYViewController

@property(weak,nonatomic)id <QYABProtocol>delegate;

@end
