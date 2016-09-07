//
//  QYLoginViewModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYLoginViewModel.h"
#import "QYLoginNetworkApi.h"
#import "QYAccountService.h"
#import "MBProgressHUD.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "IOSTool.h"
#import "QYUserRoleHelper.h"
#import "QYLoginConstant.h"
@implementation QYLoginViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupObserverationForTheSignInButtonsEnabledState];
    }
    return self;
}
/**
 *
 *  开始登录
 *
 *  @param success 登录成功回调
 *  @param failure 登录失败回调
 */
-(void)loginButtonActionSuccess:(void (^)(LoginSuccessState successState))success
                                       failure:(void (^)(NSString *alert))failure
{
    if ([_username isNil])
    {
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYLoginSwitchUnitCell_userNamePrompt")];
        return;
    }
    if ([_password isNil])
    {
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYLoginSwitchUnitCell_passwordPrompt")];
        return;
    }
    
    //字符串处理
    NSMutableString *muContent = [_username mutableCopy];
    NSRange substr;
    substr = [muContent rangeOfString:@" "];
    while (substr.location != NSNotFound)
    {
        [muContent replaceCharactersInRange:substr withString:@""];
        substr = [muContent rangeOfString:@" "];
    }
    NSString *content = [muContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [QYLoginNetworkApi loginWithUserName:content password:_password showHud:YES success:^(NSString *responseString)
    {
         NSError *error = nil;
         
         NSDictionary *resultArray = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
         
         //账户数组
         NSMutableArray *accountArray = [[NSMutableArray alloc] init];
         //权限数组
         NSMutableArray *userRoleArray = [[NSMutableArray alloc] init];
         
         for (NSDictionary *resultDic in resultArray)
         {
             QYAccount *account = [[QYAccount alloc] initWithDictionary:resultDic error:&error];
             account.password = _password;
             [accountArray addObject:account];
             //权限数组
             NSMutableDictionary *userRoleMap = [[NSMutableDictionary alloc]initWithDictionary:resultDic[@"userRoleMap"]];
             [userRoleMap setObject:account.companyId forKey:@"companyId"];
             [userRoleArray addObject:userRoleMap];
             
         }
         //账户管理
         [[QYAccountService shared] createAccounts:accountArray];
         //用户权限管理
         [[QYUserRoleHelper shared] createUserRoles:userRoleArray];
         
         if ([resultArray count] >= 2)
         {
             //多公司
             success(LoginSuccessStateMultiunit);
         }
         else if([resultArray count] == 1)
         {
             //单公司
             QYAccount *account = accountArray[0];
             [[QYAccountService shared] setDefaultAccount:account];
             success(LoginSuccessStateNone);
         }
         else
         {
             failure(@"QYLoginSwitchUnitCell_loginFailurePrompt");
         }
     
     }
     passwordError:^(NSString *responseString)
     {
         failure(responseString);
     }
     networkError:^(NSString *alert)
     {
         failure(alert);
     }];
}

/**
 *  监测按钮是否置灰,放controller和viewModel都行，原则：能放viewModel的都不放controller
 */
- (void)setupObserverationForTheSignInButtonsEnabledState
{
    [[[RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password)]] reduceEach:^id( NSString *username, NSString *password)
    {
        if ([username isNil]||[password isNil])
        {
            return @(NO);
        }
        return @(YES);
    }] subscribeNext:^(NSNumber *signInButtonEnabled)
    {
        if (_loginButtonEnabled)
        {
            _loginButtonEnabled([signInButtonEnabled boolValue]);
        }
    }];
}


@end
