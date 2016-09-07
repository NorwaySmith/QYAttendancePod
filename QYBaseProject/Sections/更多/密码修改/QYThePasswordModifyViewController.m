//
//  QYThePasswordModifyViewController.m
//  QYBaseProject
//
//  Created by 小海 on 15/9/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYThePasswordModifyViewController.h"
#import "Masonry.h"
#import "IOSTool.h"
#import "QYURLHelper.h"
#import "QYNetworkHelper.h"
#import "QYNetworkJsonProtocol.h"
#import "QYAccountService.h"
#import "QYRedDotHelper.h"
#import <QYAddressBook/QYABBasicDataHelper.h>
#import <NoticeMsgCBB/QYSMSMobanHelper.h>

#import "APService.h"
#import "QYInitUI.h"
#import "QYTheme.h"

@interface QYThePasswordModifyViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *oldPassword;
@property (nonatomic, strong) UIView *oldLine;
@property (nonatomic, strong) UITextField *theNewPassword;
@property (nonatomic, strong) UIView *theNewLine;
@property (nonatomic, strong) UITextField *verificationPassword;
@property (nonatomic, strong) UIView *verificationLine;

@end

#define TheLineColorDefault [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f]
#define TheLineColorHeight [UIColor colorWithRed:37/255.0f green:182/255.0f blue:237/255.0f alpha:1.0f]

@implementation QYThePasswordModifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"密码修改";
        
        UIButton *sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.backgroundColor = [UIColor clearColor];
        [sendButton setTitle:@"完成" forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont themeRightButtonFont];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        sendButton.frame=CGRectMake(0, 0, 57, 30);
        UIBarButtonItem *signBar = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
        self.navigationItem.rightBarButtonItem = signBar;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_oldPassword becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldPassword = [[UITextField alloc] init];
    _oldPassword.backgroundColor = [UIColor clearColor];
    _oldPassword.delegate = self;
    _oldPassword.placeholder = @"请输入原密码";
    [_oldPassword setSecureTextEntry:YES];
    [self.view addSubview:_oldPassword];
    
    self.oldLine = [[UIView alloc] init];
    _oldLine.backgroundColor = TheLineColorDefault;
    [self.view addSubview:_oldLine];
    
    self.theNewPassword = [[UITextField alloc] init];
    _theNewPassword.backgroundColor = [UIColor clearColor];
    _theNewPassword.delegate = self;
    _theNewPassword.placeholder = @"请输入新的登录密码";
    [_theNewPassword setSecureTextEntry:YES];
    [self.view addSubview:_theNewPassword];
    
    self.theNewLine = [[UIView alloc] init];
    _theNewLine.backgroundColor = TheLineColorDefault;
    [self.view addSubview:_theNewLine];
    
    self.verificationPassword = [[UITextField alloc] init];
    _verificationPassword.backgroundColor = [UIColor clearColor];
    _verificationPassword.delegate = self;
    _verificationPassword.placeholder = @"请再次确认登录密码";
    [_verificationPassword setSecureTextEntry:YES];
    [self.view addSubview:_verificationPassword];
    
    self.verificationLine = [[UIView alloc] init];
    _verificationLine.backgroundColor = TheLineColorDefault;
    [self.view addSubview:_verificationLine];
    
    [_oldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(40));
    }];
    
    [_oldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oldPassword.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(0.5f));
    }];
    
    [_theNewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oldLine.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(40));
    }];
    
    [_theNewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_theNewPassword.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(0.5f));
    }];
    
    [_verificationPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_theNewLine.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(40));
    }];
    
    [_verificationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verificationPassword.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(0.5f));
    }];
    
    [_oldPassword becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _oldPassword) {
        _oldLine.backgroundColor = TheLineColorHeight;
        _theNewLine.backgroundColor = TheLineColorDefault;
        _verificationLine.backgroundColor = TheLineColorDefault;
    }else if (textField == _theNewPassword) {
        _theNewLine.backgroundColor = TheLineColorHeight;
        _oldLine.backgroundColor = TheLineColorDefault;
        _verificationLine.backgroundColor = TheLineColorDefault;
    }else if (textField == _verificationPassword) {
        _verificationLine.backgroundColor = TheLineColorHeight;
        _oldLine.backgroundColor = TheLineColorDefault;
        _theNewLine.backgroundColor = TheLineColorDefault;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >=16) {
        return NO; // return NO to not change text
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _oldPassword) {
        [_theNewPassword becomeFirstResponder];
    }else if (textField == _theNewPassword) {
        [_verificationPassword becomeFirstResponder];
    }else if (textField == _verificationPassword) {
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)sendButtonClicked:(id)sender {
    [self.view endEditing:YES];
    
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    
    if (!_oldPassword.text||[_oldPassword.text isEqualToString:@""]) {
        [QYDialogTool showDlg:@"请输入原密码"];
        return;
    }
    if (![account.password isEqualToString:_oldPassword.text]) {
        [QYDialogTool showDlg:@"原密码输入不正确，请重新输入"];
        return;
    }
    if (!_theNewPassword.text||[_theNewPassword.text isEqualToString:@""]) {
        [QYDialogTool showDlg:@"请输入新密码"];
        return;
    }
    if (!_verificationPassword.text||[_verificationPassword.text isEqualToString:@""]) {
        [QYDialogTool showDlg:@"请确认新密码"];
        return;
    }
    if (_theNewPassword.text.length < 6) {
        [QYDialogTool showDlg:@"密码长度不能小于6位"];
        return;
    }
    if (_theNewPassword.text.length > 16) {
        [QYDialogTool showDlg:@"密码长度不能大于16位"];
        return;
    }
    if (![_theNewPassword.text isEqualToString:_verificationPassword.text]) {
        [QYDialogTool showDlg:@"新密码和确认密码不一致，请重新输入"];
        return;
    }
    if (![self isValidatePassword:_theNewPassword.text] || ![self isValidatePassword:_verificationPassword.text]) {
        return;
    }
    
    QYNetworkHelper *networkHelper=[[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate=[QYNetworkJsonProtocol new];
    [networkHelper showHUDAtView:nil message:nil];
    NSString *urlString= [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"updatePass"];
    NSDictionary *parameters=@{@"method":@"updatePass",
                               @"userId":account.userId,
                               @"oldPass":_oldPassword.text,
                               @"newPass":_theNewPassword.text,
                               @"_clientType":@"wap"};
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result) {
        if(result.statusCode==NetworkResultStatusCodeSuccess){
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码修改成功，请重新登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alertView.delegate = self;
//            [alertView show];
            [QYDialogTool showDlg:result.result];
            [[QYAccountService shared] setDefaultAccountPassword:_theNewPassword.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else if(result.statusCode==NetworkResultStatusCodeNoData){
            [QYDialogTool showDlg:result.result];
        }else{
            [QYDialogTool showDlg:result.errMessage];
        }
    } failure:^(NetworkErrorType errorType) {
        if (errorType==NetworkErrorTypeNoNetwork) {
            [QYDialogTool showDlg:ErrorNoNetworkAlert];
        }
        if (errorType==NetworkErrorType404) {
            [QYDialogTool showDlg:Error404Alert];
        }
    }];
}

/**
 * @brief    判断密码的合法性
 * @param
 * @return
 */
- (BOOL)isValidatePassword:(NSString *)password
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    if ([passWordPredicate evaluateWithObject:password]) {
        return YES;
    }
    else
    {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"密码不合法", nil) message:NSLocalizedString(@"请重新输入密码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
        
    }
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self signOut];
    }
}

//退出登录
-(void)signOut
{
    
    [[QYRedDotHelper shared] resetData];             //红点
    
    //退出登陆并且清空数据库
    [[QYABBasicDataHelper shared] resetABData]; //基础数据
    [[QYSMSMobanHelper shared] resetSMSMobanData];
    
    //推送
    [APService setTags:[NSSet set] alias:@"" callbackSelector:nil target:nil];
    
    //移除默认账户
    [[QYAccountService shared] removeDefaultAccount];
    
    //通知公告 手动 添加数据 处理
    //手动添加数据 是否有红点
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isClickHandWritCell"];
    
    [[QYAccountService shared] removeAllAccount];
    [[QYInitUI shared] initUI:nil];
}

@end
