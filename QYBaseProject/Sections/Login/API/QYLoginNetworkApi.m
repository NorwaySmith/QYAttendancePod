//
//  QYLoginNetworkApi.m
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYLoginNetworkApi.h"
#import "QYDialogTool.h"
#import "QYURLHelper.h"
#import "QYNetworkHelper.h"
#import "QYNetworkJsonProtocol.h"
#import "QYVersionHelper.h"
#import "QYLoginConstant.h"
static NSString  *ModelCode = @"ydzjMobile";

@implementation QYLoginNetworkApi
/**
 *  登录接口
 *
 *  @param username      用户名
 *  @param password      密码
 *  @param showHud       是否显示hud
 *  @param success       登录成功
 *  @param passwordError 用户名或者密码错误
 *  @param networkError  网络错误
 */
+(void)loginWithUserName:(NSString *)username
                password:(NSString *)password
                 showHud:(BOOL)showHud
                 success:(void (^)(NSString *responseString))success
           passwordError:(void (^)(NSString *responseString))passwordError
            networkError:(void (^)(NSString *alert))networkError
{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    if (showHud){
        [networkHelper showHUDAtView:nil message:QYLoginLocaleString(@"QYLoginNetworkApi_loginPrompt")];
    }
    
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"ydzjLogin"];
    NSDictionary *parameters = @{@"userName":username, @"passWord":password, @"_clientType":@"wap",@"verName":[NSString stringWithFormat:@"%@_ios",[[QYVersionHelper shared] currVersion]]};
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
    {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             success(result.result);
         }
         else if(result.statusCode == NetworkResultStatusCodeNoData)
         {
             passwordError(result.result);
         }
         else
         {
             passwordError(result.errMessage);
         }
     } failure:^(NetworkErrorType errorType)
     {
         if (errorType == NetworkErrorTypeNoNetwork)
         {
             networkError(ErrorNoNetworkAlert);
         }
         if (errorType == NetworkErrorType404)
         {
             networkError(Error404Alert);
         }
     }];
}
/**
 *  将登陆设备id更新到服务器
 *
 *  @param username      用户名
 *  @param success       登录成功
 *  @param networkError  网络错误
 */
+(void)rememberLoginDeviceWithUserId:(NSString*)userId
                             success:(void (^)(NSString *responseString))success
                             failure:(void (^)(NSString *alert))failure;{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
   
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"rememberLoginDevice"];

    NSDictionary *parameters = @{@"userId":userId};
    [networkHelper showHUDAtView:nil message:nil];
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             success(result.result);
         }
         else if(result.statusCode == NetworkResultStatusCodeNoData)
         {
             failure(result.result);
         }
         else
         {
             failure(result.errMessage);
         }
     } failure:^(NetworkErrorType errorType)
     {
         if (errorType == NetworkErrorTypeNoNetwork)
         {
             failure(ErrorNoNetworkAlert);
         }
         if (errorType == NetworkErrorType404)
         {
             failure(Error404Alert);
         }
     }];
}

/**
 *  发送验证码到手机号
 *
 *  @param phone   手机号码
 *  @param success 成功回调
 *  @param failure 成功回调
 */
+(void)sendCheckCodeToPhone:(NSString*)phone
                    success:(void (^)(NSString *responseString))success
                    failure:(void (^)(NSString *alert))failure
{
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"sendForgetPassSMS"];
    NSDictionary *parameters = @{@"phone":phone,
                                 @"_clientType":@"wap"};
    
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    [networkHelper showHUDAtView:nil message:nil];
    [networkHelper POST:urlString parameters:parameters
                success:^(QYNetworkResult *result)
    {
        if(result.statusCode == NetworkResultStatusCodeSuccess)
        {
            success(result.result);
        }
        else if(result.statusCode == NetworkResultStatusCodeNoData)
        {
            failure(result.result);
        }
        else
        {
            failure(result.errMessage);
        }
    }
    failure:^(NetworkErrorType errorType)
    {
        if (errorType == NetworkErrorTypeNoNetwork)
         {
            failure(ErrorNoNetworkAlert);
        }
        if (errorType == NetworkErrorType404)
        {
            failure(Error404Alert);
        }
    }];
}
/**
 *  修改密码
 *
 *  @param checkCode 验证码
 *  @param password  密码
 *  @param success   成功回调
 *  @param failure   成功回调
 */
+(void)updatePassByCheckCode:(NSString*)checkCode
                    password:(NSString*)password
                     phone:(NSString*)phone
                     success:(void (^)(NSString *responseString))success
                     failure:(void (^)(NSString *alert))failure
{
    NSString *urlString= [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"updatePassByCheckCode"];
    
    NSDictionary *parameters = @{@"checkCode":checkCode,
                                 @"newPass":password,
                                 @"phone":phone,
                                 @"_clientType":@"wap"};
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    [networkHelper showHUDAtView:nil message:nil];
    [networkHelper POST:urlString parameters:parameters
                success:^(QYNetworkResult *result)
    {
        if(result.statusCode == NetworkResultStatusCodeSuccess)
        {
            success(result.result);
        }
        else if(result.statusCode == NetworkResultStatusCodeNoData)
        {
            failure(result.result);
        }
        else
        {
            failure(result.errMessage);
        }
    }
    failure:^(NetworkErrorType errorType)
    {
        if (errorType == NetworkErrorTypeNoNetwork)
        {
            failure(ErrorNoNetworkAlert);
        }
        if (errorType == NetworkErrorType404)
        {
            failure(Error404Alert);
        }
    }];
}

/**
 *  @author 杨峰, 16-04-13 10:04:04
 *
 *  更新得到用户新的权限
 *
 *  @param companyId 公司Id
 *  @param success   成功回调
 *  @param failure   成功回调
 */
+(void)updateAccountUserRoleMapWithCompanyId:(NSString *)companyId
                                     success:(void (^)(NSString *responseString))success
                                     failure:(void (^)(NSString *alert))failure {
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    
    NSString *urlString= @"http://101.200.31.143/zq-kxh/mobile/modulePermission.action?";
    NSDictionary *parameters = @{@"companyId":companyId,
                                 @"_clientType":@"wap"};
    [networkHelper POST:urlString parameters:parameters
                success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             success(result.result);
         }
         else if(result.statusCode == NetworkResultStatusCodeNoData)
         {
             failure(result.result);
         }
         else
         {
             failure(result.errMessage);
         }
     }
                failure:^(NetworkErrorType errorType)
     {
         if (errorType == NetworkErrorTypeNoNetwork)
         {
             failure(ErrorNoNetworkAlert);
         }
         if (errorType == NetworkErrorType404)
         {
             failure(Error404Alert);
         }
     }];
}

/**
 *  @author 杨峰, 16-04-15 15:04:23
 *
 *  发送语音验证码
 *
 *  @param phone   手机号码
 *  @param success 成功回调
 *  @param failure 成功回调
 */
+(void)getVerifyFromPhone:(NSString*)phone
                  success:(void (^)(NSString *responseString))success
                  failure:(void (^)(NSString *alert))failure {
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    
    NSString *urlString = @"http://101.200.31.143/zq-kxh/mobile/getNoticeCode.action?";
    NSDictionary *parameters = @{@"phone":phone,
                                 @"_clientType":@"wap",
                                 @"moduleName":@"regExperUser"};
    [networkHelper POST:urlString parameters:parameters
                success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess){
             success(result.result);
         }
         else if(result.statusCode == NetworkResultStatusCodeNoData){
             failure(result.result);
         }
         else{
             failure(result.errMessage);
         }
     }failure:^(NetworkErrorType errorType){
         if (errorType == NetworkErrorTypeNoNetwork)
         {
             failure(ErrorNoNetworkAlert);
         }
         if (errorType == NetworkErrorType404)
         {
             failure(Error404Alert);
         }
     }];
}
/**
 *  @author 杨峰, 16-04-15 16:04:54
 *
 *  注册试用人员信息
 *
 *  @param userName 试用人员名字
 *  @param phone    试用人员手机号
 *  @param isShow   是否公开手机号
 *  @param code     语音验证码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
+(void)regExperUserWithUserName:(NSString *)userName
                          phone:(NSString *)phone
                         isShow:(BOOL)isShow
                           code:(NSString *)code
                        success:(void (^)(NSString *responseString))success
                        failure:(void (^)(NSString *alert))failure {
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    [networkHelper showHUDAtView:nil message:nil];
    
    NSString *urlString = @"http://101.200.31.143/zq-kxh/mobile/addExperUser.action?";
    NSDictionary *parameters = @{@"userName":userName,
                                 @"phone":phone,
                                 @"isShow":@(isShow),
                                 @"code":code,
                                 @"_clientType":@"wap",
                                 @"moduleName":@"regExperUser"};
    [networkHelper POST:urlString parameters:parameters
                success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess){
             success(result.result);
         }
         else if(result.statusCode == NetworkResultStatusCodeNoData){
             failure(result.result);
         }
         else{
             failure(result.errMessage);
         }
     }failure:^(NetworkErrorType errorType){
         if (errorType == NetworkErrorTypeNoNetwork)
         {
             failure(ErrorNoNetworkAlert);
         }
         if (errorType == NetworkErrorType404)
         {
             failure(Error404Alert);
         }
     }];
}

@end







