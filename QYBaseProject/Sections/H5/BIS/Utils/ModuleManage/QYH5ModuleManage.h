//
//  QYH5ModuleManage.h
//  QYBaseProject
//
//  Created by 田 on 15/8/12.
//  Copyright (c) 2015年 田. All rights reserved.
//  本地存储html的管理

#import <Foundation/Foundation.h>

@interface QYH5ModuleManage : NSObject
/**
 *  添加一个模块
 *
 *  @param modulePath 模块路径
 *  @param moduleName 模块名
 */
-(void)addModuleAtModulePath:(NSString*)modulePath moduleName:(NSString*)moduleName;
/**
 *  根据模块名删除一个模块
 *
 *  @param moduleName 模块名
 */
-(void)delModuleWithModuleName:(NSString*)moduleName;
/**
 *  更具模块名得到模块路径
 *
 *  @param moduleName 模块名
 *
 *  @return 模块路径
 */
-(NSURL*)moduleURLWithModuleName:(NSString*)moduleName;
/**
 *  删除所有模块
 */
-(void)delAllModule;
@end
