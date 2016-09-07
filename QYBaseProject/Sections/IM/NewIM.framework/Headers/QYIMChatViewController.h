//
//  QYIMChatViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/8/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  聊天会话
 */

#import "QYViewController.h"

@protocol QYIMProtocol;

@interface QYIMChatViewController : QYViewController

@property (nonatomic, strong) NSNumber *chatId;

@property (nonatomic, assign) id<QYIMProtocol>      imProtocol;

@end
