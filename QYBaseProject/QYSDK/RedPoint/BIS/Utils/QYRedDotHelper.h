//
//  QYRedDotHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYRedDotModel.h"
#import "QYRedDotStorage.h"

// 通知 红点已经改变通知ui刷新
extern NSString *const kQYRedDotChangeNotification;

@interface QYRedDotHelper : NSObject
+ (QYRedDotHelper *)shared;
/**
 *  打开红点推送监听
 */
-(void)openPushMonitoring;
/**
 *  根据模块标识获取红点对象
 *
 *  @param moduleCode 模块标识
 *
 *  @return 红点对象
 */
-(QYRedDotModel*)redDotModelWithModuleCode:(NSString*)moduleCode;
/**
 *  某模块红点改变
 *
 *  @param changeNum  红点改变，+则红点数增加，－红点数减少
 *  @param moduleCode 模块标识
 *
 */
-(void)redDotChangeNum:(NSInteger)changeNum
            moduleCode:(NSString*)moduleCode;
/**
 *  清除某个模块的红点
 *
 *  @param moduleCode 模块标识
 */
-(void)cleanRedDotAtModuleCode:(NSString*)moduleCode;
/**
 *  重置红点数据
 */
-(void)resetData;
/**
 *  从网络获取所有红点
 */
-(void)allRedPointFromNetwork;


@end
