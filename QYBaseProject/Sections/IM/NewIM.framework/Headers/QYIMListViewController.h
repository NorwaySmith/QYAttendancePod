//
//  QYIMListViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/8/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  聊天列表
 */

#import "QYViewController.h"

@protocol QYIMProtocol;

@interface QYIMListViewController : QYViewController

@property (nonatomic, assign) id<QYIMProtocol>      imProtocol;

@end
