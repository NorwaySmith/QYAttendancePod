//
//  QYApplicationViewModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/13.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

// 模块名
#define kLgz_app_notice              @"公告"
#define kLgz_app_punchCard           @"考勤"
#define kLgz_app_log                 @"日志"
#define kLgz_app_approve             @"审批"
#define kLgz_app_surveyQuestion      @"问卷"
#define kLgz_app_onLineLessono       @"在线课堂"
#define kLgz_app_voice               @"语音通知"
#define kLgz_app_meetting            @"电话会议"
#define kLgz_app_commonPhone         @"常用号码"
#define kLgz_app_crm                 @"CRM"


@interface QYApplicationViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,assign) BOOL isShowWorkRed;

@end
