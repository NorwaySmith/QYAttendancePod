//
//  QYABBasicDataHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/29.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  人员选择逻辑
 */
#import <Foundation/Foundation.h>
#import "QYABConstant.h"



typedef NS_ENUM(NSInteger, QYABBasicDataMode)
{
    QYABBasicDataModeNone = 0,      //默认变量下载
    QYABBasicDataModeBigData = 1,   //大数据
};


@interface QYABBasicDataHelper : NSObject


@property(nonatomic,assign)QYABBasicDataMode basicDataMode;


+ (QYABBasicDataHelper *)shared;

/**
 *  以某种方式更新基础数据
 *
 *  @param basicDataMode 更新方式
 */
-(void)checkBasicData:(QYABBasicDataMode)basicDataMode;

/**
 *  重置通讯录数据
 */
-(void)resetABData;


@end
