//
//  QYMeetingMemoryBallManager.h
//  QYBaseProject
//
//  Created by 田 on 16/4/25.
//  Copyright © 2016年 田. All rights reserved.
//
/**
 *  悬浮球管理类
 */
#import <UIKit/UIKit.h>

@interface QYMeetingMemoryBallManager : NSObject
+ (QYMeetingMemoryBallManager *)shared;
/**
 *  开始监听电话会议推送
 */
- (void)startMonitorPush;

/**
 *  添加悬浮球
 *
 *  @param meetingId 会议id
 */
- (void)addMemoryBallWithMeetingId:(NSString *)meetingId;
/**
 *  删除悬浮球
 */
- (void)removeMemoryBall;
/**
 *  暂时显示悬浮球
 */
- (void)showMemoryBall;
/**
 *  暂时隐藏悬浮球
 */
- (void)hideMemoryBall;

/**
 *  检查当前会议状态并添加悬浮球
 */
- (void)checkCurrentMeetingStatus;

@end
