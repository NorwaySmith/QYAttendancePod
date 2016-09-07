//
//  QYABDetailViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/6/29.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  单位通讯录详情
 */
#import "QYViewController.h"
#import "QYABProtocol.h"
#import "QYABEnum.h"

@interface QYABUnitDetailViewController : QYViewController
/**
 *  通讯录代理
 */
@property(weak,nonatomic)id <QYABProtocol>delegate;
/**
 *  初始化详情控制器
 *
 *  @param lid      如果为单位人员，传userId。否则传id
 *  @param userType 人员类型
 *
 *  @return
 */
-(instancetype)initWithId:(NSString *)lid;
/**
 *  通讯录是否显示嘀一下
 */
@property (nonatomic, assign) QYABUserDetailsContainBottomView type;

/**
 *  是否从IM跳入到单位通讯录详情，然后跳转新建滴滴提醒页面
 */
@property (nonatomic, assign) BOOL isComeFromIM;

@end
