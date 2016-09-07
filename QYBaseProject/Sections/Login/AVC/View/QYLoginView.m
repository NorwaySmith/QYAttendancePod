//
//  QYLoginView.m
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYLoginView.h"
#import "Masonry.h"
#import "QYTheme.h"
#import "UIImage+ToolExtend.h"
#import "QYLoginConstant.h"
//logo距上边间距
static CGFloat const logoImageView_top_padding      = 32+10;
//用户名密码背景上边间距
static CGFloat const textFieldBg_top_padding        = 33;
//用户名密码背景高度
static CGFloat const textFieldBg_height             = 88;
//用户名密码背景高度
static CGFloat const loginButton_top_padding        = 10;

@interface QYLoginView()
/**
 *  登录上部logo
 */
@property(nonatomic,strong)UIImageView              *logoImageView;

@end

@implementation QYLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
/**
 *  组装UI
 */
-(void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    //背景事件绑定
    UIControl *mainControl = [[UIControl alloc] initWithFrame:self.bounds];
    [mainControl addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mainControl];
    
    
    UIView *textFieldBg = [[UIView alloc] init];
    textFieldBg.userInteractionEnabled = YES;
    [self addSubview:textFieldBg];
    
    //用户名线
    _userLine = [[UIView alloc] init];
    _userLine.backgroundColor = [UIColor appSeparatorColor];
    [textFieldBg addSubview:_userLine];
    
    //密码线
    _pwdLine = [[UIView alloc] init];
    _pwdLine.backgroundColor = [UIColor appSeparatorColor];
    [textFieldBg addSubview:_pwdLine];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"login_logo"]];
    [self addSubview:_logoImageView];
    
//    self.usernameTextField = [[QYLoginTextField alloc] initWithLeftViewImage:[UIImage imageNamed:@"login_phoneIcon"]];
    self.usernameTextField = [[QYLoginTextField alloc] initWithLeftViewImage:@"手机号"];

    _usernameTextField.tag = 100;
    _usernameTextField.placeholder = QYLoginLocaleString(@"QYLoginView_usernameTextFieldPlaceholder");
    _usernameTextField.font = [UIFont systemFontOfSize:18];
    _usernameTextField.backgroundColor = [UIColor clearColor];
    _usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameTextField.keyboardType = UIKeyboardTypeNumberPad;
    _usernameTextField.tintColor = [UIColor themeTextInputeCursorColor];
    [textFieldBg addSubview:_usernameTextField];
    
//    self.passwordTextField = [[QYLoginTextField alloc] initWithLeftViewImage:[UIImage imageNamed:@"login_passwordIcon"]];
    self.passwordTextField = [[QYLoginTextField alloc] initWithLeftViewImage:@"密不码"];

    _passwordTextField.tag = 101;
    _passwordTextField.placeholder = QYLoginLocaleString(@"QYLoginView_passwordTextFieldPlaceholder");
    _passwordTextField.font =[UIFont systemFontOfSize:18];
    _passwordTextField.backgroundColor = [UIColor clearColor];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.tintColor = [UIColor themeTextInputeCursorColor];
    _passwordTextField.keyboardType = UIKeyboardTypeDefault;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    [textFieldBg addSubview:_passwordTextField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:QYLoginLocaleString(@"QYLoginView_login") forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateDisabled];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_loginButtonBgD"] forState:UIControlStateDisabled];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_loginButtonBg"] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login_loginButtonBgH"] forState:UIControlStateHighlighted];
    _loginButton.layer.cornerRadius = 3;
    _loginButton.clipsToBounds = YES;
    [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginButton];
    
    UIButton *forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPasswordButton setTitle:QYLoginLocaleString(@"QYLoginView_forgetPassword") forState:UIControlStateNormal];
    [forgetPasswordButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetPasswordButton];
    
//    UIImage *bgImage = [UIImage  imageWithColor:[UIColor whiteColor]];
//    UIImage *bgHighlightImage = [UIImage  imageWithColor:[UIColor themeSeparatorLineColor]];

//    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [registerButton setTitle:QYLoginLocaleString(@"QYLoginView_register") forState:UIControlStateNormal];
//    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [registerButton.titleLabel setFont:[UIFont baseTextSmall]];
//    [registerButton setBackgroundImage:bgImage forState:UIControlStateNormal];
//    [registerButton setBackgroundImage:bgHighlightImage forState:UIControlStateHighlighted];
//    [registerButton.layer setBorderColor:[[UIColor themeSeparatorLineColor] CGColor]];
//    [registerButton.layer setBorderWidth:0.5];
//    [registerButton addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:registerButton];
    
    UIButton *extensionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [extensionButton setTitle:QYLoginLocaleString(@"QYLoginView_extension") forState:UIControlStateNormal];
    [extensionButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [extensionButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [extensionButton setBackgroundImage:bgImage forState:UIControlStateNormal];
//    [extensionButton setBackgroundImage:bgHighlightImage forState:UIControlStateHighlighted];
//    [extensionButton.layer setBorderColor:[[UIColor themeSeparatorLineColor] CGColor]];
//    [extensionButton.layer setBorderWidth:0.5];
    [extensionButton addTarget:self action:@selector(experienceClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:extensionButton];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(logoImageView_top_padding));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [textFieldBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_bottom).offset(textFieldBg_top_padding);
        make.left.equalTo(self.mas_left).offset(padding);
        make.right.equalTo(self.mas_right).offset(-padding);
        make.height.equalTo(@(textFieldBg_height));
    }];
    
    [_userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldBg.mas_top).offset(textFieldBg_height/2 - 0.5);
        make.left.equalTo(textFieldBg.mas_left).offset(0);
        make.right.equalTo(textFieldBg.mas_right).offset(-0);
        make.height.equalTo(@(0.5));
    }];
    
    [_pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldBg.mas_top).offset(textFieldBg_height);
        make.left.equalTo(textFieldBg.mas_left).offset(0);
        make.right.equalTo(textFieldBg.mas_right).offset(-0);
        make.height.equalTo(@(0.5));
    }];
    
    [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldBg.mas_top);
        make.left.equalTo(textFieldBg.mas_left).offset(6);
        make.right.equalTo(textFieldBg.mas_right);
        make.height.equalTo(@(textFieldBg_height/2));
    }];
    
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usernameTextField.mas_bottom);
        make.left.equalTo(textFieldBg.mas_left).offset(6);
        make.right.equalTo(textFieldBg.mas_right);
        make.height.equalTo(@(textFieldBg_height/2)); //can pass array of views
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldBg.mas_bottom).offset(25);
        make.left.equalTo(textFieldBg.mas_left);
        make.right.equalTo(textFieldBg.mas_right);
        make.height.equalTo(@(40));
    }];
    
    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).offset(20);
        make.right.equalTo(textFieldBg.mas_right);
        make.height.equalTo(@(20));
    }];
    
    [extensionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).offset(20);
        make.left.equalTo(textFieldBg.mas_left);
        make.height.equalTo(@(20));

//        make.bottom.equalTo(self.mas_bottom).offset(-40);
//        make.centerX.equalTo(self.mas_centerX);
//        make.width.equalTo(@(48));
//        make.height.equalTo(@(28));
    }];
//    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).offset(-40);
//        make.centerX.equalTo(self.mas_centerX).offset(-40);
//        make.width.equalTo(@(48));
//        make.height.equalTo(@(28));
//    }];
//    [extensionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).offset(-40);
//        make.centerX.equalTo(self.mas_centerX).offset(40);
//        make.width.equalTo(@(48));
//        make.height.equalTo(@(28));
//    }];
}
/**
 *  登录按钮点击事件
 *
 *  @param sender 登录按钮对象
 */
-(void)login:(id)sender {
    if (_loginButtonClick) {
        _loginButtonClick(_usernameTextField.text,_passwordTextField.text);
    }
}
/**
 *  忘记密码点击事件
 */
-(void)forgetPasswordClick {
    if (_forgetPasswordButtonClick) {
        _forgetPasswordButtonClick(_usernameTextField.text);
    }
}
/**
 *  注册按钮点击事件
 *
 *  @param sender 注册按钮对象
 */
-(void)registerClick:(id)sender {
    if (_registerButtonClick) {
        _registerButtonClick();
    }
}
/**
 *  体验按钮点击事件
 *
 *  @param sender 体验按钮对象
 */
-(void)experienceClick:(id)sender {
    if (_experienceButtonClick) {
        _experienceButtonClick();
    }
}
/**
 *  背景点击事件
 */
- (void)bgAction {
    [self endEditing:YES];
}


@end
