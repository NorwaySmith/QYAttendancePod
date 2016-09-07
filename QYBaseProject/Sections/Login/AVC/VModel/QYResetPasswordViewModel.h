//
//  QYResetPasswordViewModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/5.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  忘记密码ViewModel，放置登录业务
 */
#import <Foundation/Foundation.h>

@interface QYResetPasswordViewModel : NSObject
/**
 *  手机号
 */
@property (strong, nonatomic) NSString *phone;
/**
 *  验证码
 */
@property (strong, nonatomic) NSString *vercode;
/**
 *  新密码
 */
@property (strong, nonatomic)  NSString *password;
/**
 *  验证密码
 */
@property (strong, nonatomic) NSString *verPassword;
/**
 *  倒计时
 */
@property (assign, nonatomic) NSInteger countdown;
/**
 *  完成按钮置灰回调
 */
@property (nonatomic, copy)  void (^showCountdown)(BOOL isHiddenResendButton,NSInteger s);
/**
 *  完成按钮置灰回调
 */
@property (nonatomic, copy)  void (^doneButtonEnabled)(BOOL enabled);
/**
 *  完成按钮点击事件
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)doneButtonActionSuccess:(void (^)(NSString *alert))success
                        failure:(void (^)(NSString *alert))failure;

/**
 *  倒计时按钮点击事件
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)countdownButtonActionSuccess:(void (^)(NSString *alert))success
                            failure:(void (^)(NSString *alert))failure;
@end
