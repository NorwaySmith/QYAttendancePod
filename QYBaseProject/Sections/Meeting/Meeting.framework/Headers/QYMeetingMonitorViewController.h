//
//  QYMeetingMonitorViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/12/14.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYViewController.h"

/**
 *  会议监控控制器类声明
 */
@interface QYMeetingMonitorViewController : QYViewController
/**
 *  会议标识
 */
@property(nonatomic,copy)NSString *meetingId;
/**
 *  显示电话接通中的提示，播放语音提示音，电话接通后自动消失，
 */
-(void)showMonitorAlertView;

@end
