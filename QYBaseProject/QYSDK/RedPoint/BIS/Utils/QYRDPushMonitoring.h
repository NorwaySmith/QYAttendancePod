//
//  QYRDPushMonitoring.h
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//  推送监听

#import <Foundation/Foundation.h>
#import "QYPushHelper.h"

@interface QYRDPushMonitoring : NSObject

+ (QYRDPushMonitoring *)shared;

/**
 *  打开红点推送监听
 */
-(void)openPushMonitoring;

@end
