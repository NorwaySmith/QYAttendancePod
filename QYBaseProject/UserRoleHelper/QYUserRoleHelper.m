//
//  QYUserRoleHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/15.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYUserRoleHelper.h"
#import "QYAccountService.h"
static NSString * const UserRoleHelperKey = @"com.quanya.UserRoleHelperKey";

@implementation QYUserRoleHelper
+ (QYUserRoleHelper *)shared
{
    static dispatch_once_t pred;
    static QYUserRoleHelper *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
- (void)createUserRoles:(NSArray *)userRoles{
    [[NSUserDefaults standardUserDefaults] setObject:userRoles forKey:UserRoleHelperKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSDictionary*)userRolesWithModuleCode:(NSString *)moduleCode{
//    QYAccountService *
//    NSArray *userRoles=

    return nil;
}

@end
