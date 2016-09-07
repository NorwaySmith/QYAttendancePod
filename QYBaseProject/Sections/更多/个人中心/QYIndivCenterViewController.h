//
//  QYIndivCenterViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYTableViewController.h"


#import <QYAddressBook/QYABUserModel.h>
//#import "QYABUserModel.h"


@interface QYIndivCenterViewController : QYTableViewController


@property (nonatomic,strong) QYABUserModel *userModel;

@end
