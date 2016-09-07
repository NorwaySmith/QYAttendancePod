//
//  QYABPersonalDetailViewController.h
//  QYBaseProject
//
//  Created by lin on 15/7/8.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  个人通讯录详情
 */
#import "QYViewController.h"
#import "QYABProtocol.h"
#import "QYABEnum.h"

@interface QYABPersonalDetailViewController : QYViewController

/**
 *  初始化详情控制器
 *
 *  @param lid   传id
 *
 *  @return
 */
-(instancetype)initWithId:(int32_t)lid;
/**
 *  通讯录代理
 */
@property (assign) id<QYABProtocol> delegate;
/**
 *  是否显示嘀一下
 */
@property (nonatomic, assign) QYABUserDetailsContainBottomView type;

@end
