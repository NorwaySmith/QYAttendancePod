//
//  QYNoticeListViewController.h
//  QYBaseProject
//
//  Created by quanya on 15-6-26.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  公告列表
 */
#import "QYViewController.h"

@interface QYNoticeListViewController : QYViewController

//yes  为从推送通知点击进入
@property (nonatomic, assign) BOOL isNoticePushEnter;

//推送进入详情
@property (nonatomic,   copy) NSString *recordId;

@end
