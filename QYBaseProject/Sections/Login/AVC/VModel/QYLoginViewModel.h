//
//  QYLoginViewModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  登录ViewModel，放置登录业务
 */
#import <Foundation/Foundation.h>
/**
 *  是否多单位
 */
typedef NS_ENUM(NSInteger, LoginSuccessState){
    /**
     *  一个单位
     */
    LoginSuccessStateNone=0,
    /**
     *  多单位
     */
    LoginSuccessStateMultiunit =1,
};

@interface QYLoginViewModel : NSObject
/**
 *  用户名
 */
@property (nonatomic, strong) NSString *username;
/**
 *  密码
 */
@property (nonatomic, strong) NSString *password;
/**
 *  登录按钮置灰回调
 */
@property (nonatomic, copy)  void (^loginButtonEnabled)(BOOL enabled);

/**
 *  登录按钮点击事件
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)loginButtonActionSuccess:(void (^)(LoginSuccessState successState))success
                        failure:(void (^)(NSString *alert))failure;
@end

