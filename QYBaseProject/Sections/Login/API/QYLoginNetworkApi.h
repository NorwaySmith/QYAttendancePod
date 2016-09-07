//
//  QYLoginNetworkApi.h
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  登录模块对服务器接口层
 */
#import "QYNetworkHelper.h"

@interface QYLoginNetworkApi : NSObject
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
+(void)loginWithUserName:(NSString*)username
                password:(NSString*)password
                 showHud:(BOOL)showHud
                 success:(void (^)(NSString *responseString))success
           passwordError:(void (^)(NSString *responseString))passwordError
            networkError:(void (^)(NSString *alert))networkError;
/**
 *  将登陆设备id更新到服务器
 *
 *  @param success       登录成功
 *  @param failure  网络错误
 */
+(void)rememberLoginDeviceWithUserId:(NSString*)userId
                             success:(void (^)(NSString *responseString))success
                             failure:(void (^)(NSString *alert))failure;
/**
 *  发送验证码到手机号
 *
 *  @param phone   手机号码
 *  @param success 成功回调
 *  @param failure 成功回调
 */
+(void)sendCheckCodeToPhone:(NSString*)phone
                 success:(void (^)(NSString *responseString))success
                 failure:(void (^)(NSString *alert))failure;
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
                     failure:(void (^)(NSString *alert))failure;

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
                                     failure:(void (^)(NSString *alert))failure;
/**
 *  @author 杨峰, 16-04-15 15:04:23
 *
 *  发送验证码到手机号
 *
 *  @param phone   手机号码
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)getVerifyFromPhone:(NSString*)phone
                  success:(void (^)(NSString *responseString))success
                  failure:(void (^)(NSString *alert))failure;
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
                        failure:(void (^)(NSString *alert))failure;


@end
