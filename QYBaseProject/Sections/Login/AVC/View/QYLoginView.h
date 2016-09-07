//
//  QYLoginView.h
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  登录主viewController的View布局
 */
#import <UIKit/UIKit.h>
#import "QYLoginTextField.h"

@interface QYLoginView : UIView
/**
 *  用户名输入框
 */
@property(nonatomic,strong)QYLoginTextField *usernameTextField;
/**
 *  密码输入框
 */
@property(nonatomic,strong)QYLoginTextField *passwordTextField;
/**
 *  用户名底部线
 */
@property (nonatomic,strong) UIView *userLine;
/**
 *  密码底部线
 */
@property (nonatomic,strong) UIView *pwdLine;
/**
 *  登录按钮
 */
@property(nonatomic,strong)UIButton *loginButton;
/**
 *  登录按钮点击回调
 */
@property(nonatomic,copy)void (^loginButtonClick)(NSString *username,NSString *password);
/**
 *  忘记密码按钮点击回调
 */
@property(nonatomic,copy)void (^forgetPasswordButtonClick)(NSString *username);
/**
 *  注册按钮点击回调
 */
@property(nonatomic,copy)void (^registerButtonClick)();
/**
 *  体验按钮点击回调
 */
@property(nonatomic,copy)void (^experienceButtonClick)();

@end
