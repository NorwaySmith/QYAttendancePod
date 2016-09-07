//
//  QYABUnitDetailOtherViewController.h
//  QYBaseProject
//
//  Created by lin on 15/8/17.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  OA单位通讯录详情
 */
#import "QYViewController.h"
#import "QYABProtocol.h"

@protocol QYABUnitDetailOtherViewControllerDelegate <NSObject>

@end


@interface QYABUnitDetailOtherViewController : QYViewController

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
 *  底部操作栏代理
 */
@property (nonatomic,assign)id<QYABUnitDetailOtherViewControllerDelegate>toolBardelegate;


@end
