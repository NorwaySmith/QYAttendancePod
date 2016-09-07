//
//  QYDiDiReplyDetailViewController.h
//  QYBaseProject
//
//  Created by lin on 15/10/28.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  嘀嘀模块回复详情
 */

#import "QYViewController.h"
#import <QYAddressBook/QYABProtocol.h>
@class QYDiDiModel;

@interface QYDiDiReplyDetailViewController : QYViewController

@property(weak,nonatomic)id <QYABProtocol>delegate;

/**
 *  用消息id来配置详情
 *
 *  @param msgId 消息id
 */
-(void)configDetailWithMsgId:(NSInteger)msgId;

@end
