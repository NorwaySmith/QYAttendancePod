//
//  QYUserRoleHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/15.
//  Copyright (c) 2015年 田. All rights reserved.
//
/*
 UserRoleType roleType =[[QYUserRoleHelper shared] userRolesWithModuleId:@"53"];
 BOOL isShow =[[QYUserRoleHelper shared] showModuleWithModuleId:@"53"];

 */

#import <Foundation/Foundation.h>
@class QYMenuModel;
typedef NS_ENUM(NSInteger, UserRoleType) {
    UserRoleTypeHave=0,//有权限
    UserRoleTypeNoneUnit =1,//无单位权限
    UserRoleTypeNonePersonal =2,//无个人权限
    UserRoleTypeNotExist =3//权限不存在
};
@interface QYUserRoleHelper : NSObject
/**
 *  账户管理单例
 *
 *  @return 账户管理对象
 */
+ (QYUserRoleHelper *)shared;
/**
 *  设置权限字典
 *
 *  @param accounts 多个账户
 */
- (void)createUserRoles:(NSArray *)userRoles;
/**
 *  是否有权限
 *
 *  @param
 */
- (UserRoleType)userRolesWithModuleId:(NSString *)moduleId;
/**
 *  是否显示当前模块
 *
 *  @param
 */
- (BOOL)showModuleWithModuleId:(NSString *)moduleId;
/**
 *  一级权限
 *
 *  @return 权限数组
 */
-(NSArray*)moduleArray;
@end
