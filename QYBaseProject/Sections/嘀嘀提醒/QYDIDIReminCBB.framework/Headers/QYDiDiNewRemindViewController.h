//
//  QYDiDiNewRemindViewController.h
//  QYBaseProject
//
//  Created by 小海 on 15/8/26.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  嘀嘀模块新建嘀嘀提醒
 */

#import "QYViewController.h"
#import <QYAddressBook/QYABUserModel.h>
#import "QYAddDIDIModel.h"
#import <QYAddressBook/QYABProtocol.h>

@interface QYDiDiNewRemindViewController : QYViewController

@property(weak,nonatomic)id <QYABProtocol>delegate;

@property (nonatomic, assign) BOOL                      isPeopleDetails;

@property (nonatomic, strong) QYABUserModel             *userModel;

@property (nonatomic,strong) QYAddDIDIModel             *addDiDiModel;

@end
