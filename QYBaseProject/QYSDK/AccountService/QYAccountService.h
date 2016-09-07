//
//  QYAccountService.h
//  QYBaseProject
//
//  Created by 田 on 15/6/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYAccount.h"
@interface QYAccountService : NSObject
/**
 *  账户管理单例
 *
 *  @return 账户管理对象
 */
+ (QYAccountService *)shared;
/**
 *  得到默认账户
 *
 *  @return 默认账户
 */
- (QYAccount *)defaultAccount;
/**
 *  设置默认账户
 *
 *  @param account 默认账户
 */
- (void)setDefaultAccount:(QYAccount *)account;
/**
 *  设置默认账户
 *
 *  @param companyId 公司ID
 */
- (void)setDefaultAccountWithCompanyId:(NSString *)companyId;
/**
 *  删除帐户，只删除默认账号的key，退出登录一半调用removeAllAccount
 */
- (void)removeDefaultAccount;
/**
 *  删除全部帐户
 */
- (void)removeAllAccount;
/**
 *  同时创建多个账户，先创建账户，后设置默认账户
 *
 *  @param accounts 多个账户
 */
- (void)createAccounts:(NSArray *)accounts;
/**
 *  得到所有账户
 *
 *  @return 所有账户
 */
- (NSArray*)allAccounts;
//设置性别
- (void)setDefaultAccountSex:(BOOL)sex;
//设置签名
- (void)setDefaultAccountSign:(NSString*)sign;
//修改密码
- (void)setDefaultAccountPassword:(NSString*)password;

/**
 *  @author 杨峰, 16-04-13 09:04:54
 *
 *  更新设置默认的模块
 */
- (void)setDefaultAccountUserRoleMap:(NSDictionary *)userRoleMap;

- (NSString *)combinedModuleName: (NSString *)module;
@end
