//
//  QYIMReceiveMsgHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/8/24.
//  Copyright (c) 2015年 田. All rights reserved.
//  接收新消息

/**
 *  IM 接收新消息的helper
 */

#import <Foundation/Foundation.h>

@interface QYIMReceiveMsgHelper : NSObject

+ (QYIMReceiveMsgHelper *)shared;
/**
 *  接收新消息
 */
- (void)receiveMsg;
@end
