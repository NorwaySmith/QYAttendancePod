//
//  QYShakeHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/12/22.
//  Copyright © 2015年 田. All rights reserved.


/**
 *  摇一摇事件监听
 */
#import <UIKit/UIKit.h>

@interface QYShakeHelper : NSObject

/**
 *  单例
 *
 *  @return QYShakeHelper对象
 */
+ (QYShakeHelper *)shared;

/**
 *  初始化摇一摇
 */
-(void)initShake;

/**
 *  摇一摇view变为第一响应
 */
-(void)becomeFirstResponder;

/**
 *  开始晃动
 */
-(void)motionBegan;

/**
 *  取消晃动
 */
-(void)motionCancelled;

/**
 *  晃动结束
 */
-(void)motionEnded;

/**
 *  关闭摇一摇
 */
-(void)closeShake;

/**
 *  开启摇一摇
 */
-(void)openShake;

/**
 *  当前是否关闭摇一摇
 */
-(BOOL)isCloseShake;

@end
