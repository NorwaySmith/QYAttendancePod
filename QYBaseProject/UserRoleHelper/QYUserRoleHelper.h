//
//  QYUserRoleHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/15.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYUserRoleHelper : NSObject
/**
 *  账户管理单例
 *
 *  @return 账户管理对象
 */
+ (QYUserRoleHelper *)shared;
/**
 *  同时创建多个账户，先创建账户，后设置默认账户
 *
 *  @param accounts 多个账户
 */
- (void)createUserRoles:(NSArray *)userRoles;
/**
 *  同时创建多个账户，先创建账户，后设置默认账户
 *
 *  @param accounts 多个账户
 */
- (NSDictionary*)userRolesWithModuleCode:(NSString *)moduleCode;
@end
