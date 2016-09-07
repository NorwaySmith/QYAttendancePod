//
//  QYAccountService.m
//  QYBaseProject
//
//  Created by 田 on 15/6/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAccountService.h"

static NSString * const DefaultAccountCompanyIdDefaultsKey = @"AccountCompanyIdDefaultsKey";
static NSString * const AccountsKey = @"com.quanya.accounts";

@implementation QYAccountService

+ (QYAccountService *)shared
{
    static dispatch_once_t pred;
    static QYAccountService *sharedInstance = nil;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//默认账户
- (QYAccount *)defaultAccount
{
    NSArray *accounts = [self allAccounts];
    NSString *defaultAccountCompanyId = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultAccountCompanyIdDefaultsKey];
    for (QYAccount *account in accounts)
    {
        if ([account.companyId isEqualToString:defaultAccountCompanyId])
        {
            return account;
        }
    }
    return nil;
}
//得到所有账户
- (NSArray*)allAccounts
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:AccountsKey];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray *accounts = [unarchiver decodeObjectForKey:AccountsKey];
    [unarchiver finishDecoding];
    
    return accounts;
}
//设置默认账户
- (void)setDefaultAccount:(QYAccount *)account {
    [self setDefaultAccountWithCompanyId:account.companyId];
}

//设置默认账户
- (void)setDefaultAccountWithCompanyId:(NSString *)companyId
{
    [[NSUserDefaults standardUserDefaults] setObject:companyId forKey:DefaultAccountCompanyIdDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//删除帐户,
- (void)removeDefaultAccount
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DefaultAccountCompanyIdDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//删除全部帐户
- (void)removeAllAccount
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:DefaultAccountCompanyIdDefaultsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AccountsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//设置多个账户
- (void)createAccounts:(NSArray *)accounts
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //NSLog(@"archiver===%@",archiver);
    
    [archiver encodeObject:accounts forKey:AccountsKey];
    [archiver finishEncoding];

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:AccountsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//设置性别
- (void)setDefaultAccountSex:(BOOL)sex
{
    NSArray *accounts = [self allAccounts];
    NSString *defaultAccountCompanyId = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultAccountCompanyIdDefaultsKey];
    for (QYAccount *account in accounts)
    {
        if ([account.companyId isEqualToString:defaultAccountCompanyId])
        {
            account.sex = sex;
        }
    }
    [self createAccounts:accounts];
}
//设置签名
- (void)setDefaultAccountSign:(NSString*)sign
{
    NSArray *accounts = [self allAccounts];
    NSString *defaultAccountCompanyId=[[NSUserDefaults standardUserDefaults] objectForKey:DefaultAccountCompanyIdDefaultsKey];
    for (QYAccount *account in accounts)
    {
        if ([account.companyId isEqualToString:defaultAccountCompanyId])
        {
            account.signName = sign;
        }
    }
    [self createAccounts:accounts];
}
//修改密码
- (void)setDefaultAccountPassword:(NSString*)password
{
    NSArray *accounts = [self allAccounts];
    NSString *defaultAccountCompanyId=[[NSUserDefaults standardUserDefaults] objectForKey:DefaultAccountCompanyIdDefaultsKey];
    for (QYAccount *account in accounts)
    {
        if ([account.companyId isEqualToString:defaultAccountCompanyId])
        {
            account.password = password;
        }
    }
    [self createAccounts:accounts];
}

/**
 *  @author 杨峰, 16-04-13 09:04:54
 *
 *  更新设置默认的模块
 */
- (void)setDefaultAccountUserRoleMap:(NSDictionary *)userRoleMap {
    NSArray *accounts = [self allAccounts];
    NSString *defaultAccountCompanyId = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultAccountCompanyIdDefaultsKey];
    for (QYAccount *account in accounts) {
        if ([account.companyId isEqualToString:defaultAccountCompanyId]) {
            account.userRoleMap = userRoleMap;
        }
    }
    [self createAccounts:accounts];
}

- (NSString *)combinedModuleName: (NSString *)module {
    return [NSString stringWithFormat:@"%@_%@", module,[self defaultAccount].userId];
}
@end
