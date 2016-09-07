//
//  QYResetPasswordViewController.m
//  CommunicationAssistant
//
//  Created by quanya on 14-11-17.
//  Copyright (c) 2014年 田. All rights reserved.
//

#import "QYResetPasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "QYDialogTool.h"
#import "MBProgressHUD.h"
#import "QYLoginViewModel.h"
#import "QYLoginSwitchUnitViewController.h"
#import "QYAccountService.h"
#import "QYInitUI.h"
#import "QYTheme.h"
#import "QYLoginConstant.h"
/**
 * TextFiled输入中底部线条颜色
 */
#define TextFiledInputColor [UIColor colorWithRed:0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0]

@interface QYResetPasswordViewController () <UITextFieldDelegate>
/**
 *  验证码TextField
 */
@property (strong, nonatomic) IBOutlet UITextField *vercodeTextField;
/**
 *  确认密码TextField
 */
@property (strong, nonatomic) IBOutlet UITextField *verPasswordTextField;
/**
 *  倒计时Label
 */
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
/**
 *  新密码TextField
 */
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
/**
 *  右侧完成按钮
 */
@property (strong, nonatomic) UIButton *rightButton;
/**
 *  重发验证码按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *resendButton;
/**
 *  验证码下部线
 */
@property (weak, nonatomic) IBOutlet UIView *oneLineView;
/**
 *  新密码下部线
 */
@property (weak, nonatomic) IBOutlet UIView *twoLineView;
/**
 *  验证密码下部线
 */
@property (weak, nonatomic) IBOutlet UIView *threeLineView;



@end

@implementation QYResetPasswordViewController

#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = QYLoginLocaleString(@"QYResetPasswordViewController_title");
        //右侧完成按钮
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont  themeRightButtonFont];
        [_rightButton setTitle:QYLoginLocaleString(@"QYResetPasswordViewController_done")
                      forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor themeRightButtonHalfColor] forState:UIControlStateDisabled];
        [_rightButton setTitleColor:[UIColor themeRightButtonColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.frame = CGRectMake(0, 0, 60, 44);
        
        UIBarButtonItem *operationBar=[[UIBarButtonItem alloc]initWithCustomView:_rightButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -18;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, operationBar];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _resendButton.hidden = YES;
    [self bindToViewModel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CustomDelegate
#pragma mark - UITextFieldDelegate
/**
 *  textField text改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 101 || textField.tag == 102)
    {
        if (textField.text.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 20)
        {
            return NO;
        }
    }
    return YES;
}
/**
 *  textField 将要变为第一响应
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 100:
        {
            _oneLineView.backgroundColor = [UIColor themeForgetPwdSeparatorLineColor];
            _twoLineView.backgroundColor = [UIColor themeSeparatorLineColor];
            _threeLineView.backgroundColor = [UIColor themeSeparatorLineColor];
        }
            break;
        case 101:
        {
            _oneLineView.backgroundColor = [UIColor themeSeparatorLineColor];
            _twoLineView.backgroundColor = [UIColor themeForgetPwdSeparatorLineColor];
            _threeLineView.backgroundColor = [UIColor themeSeparatorLineColor];
        }
            break;
        case 102:
        {
            _oneLineView.backgroundColor = [UIColor themeSeparatorLineColor];
            _twoLineView.backgroundColor = [UIColor themeSeparatorLineColor];
            _threeLineView.backgroundColor = [UIColor themeForgetPwdSeparatorLineColor];
        }
            break;
        default:
            
            break;
    }
    
    return YES;
}
#pragma mark - event response
/**
 *  完成按钮点击事件
 */
- (void)doneButtonAction{
    [self.view endEditing:YES];

    [_viewModel doneButtonActionSuccess:^(NSString *alert){
         [self updatePasswordDone];
    }failure:^(NSString *alert){
        [QYDialogTool  showDlg:alert];
    }];
    _oneLineView.backgroundColor = [UIColor themeSeparatorLineColor];
    _twoLineView.backgroundColor = [UIColor themeSeparatorLineColor];
    _threeLineView.backgroundColor = [UIColor themeSeparatorLineColor];
}

/**
 *  重发按钮点击事件
 *
 *  @param sender 重发按钮对象
 */
- (IBAction)resendButtonClick:(id)sender
{
    [_viewModel countdownButtonActionSuccess:^(NSString *alert){
        [QYDialogTool showDlg:alert];
    }failure:^(NSString *alert){
        [QYDialogTool  showDlg:alert];
    }];

}

#pragma mark - private methods
/**
 *  绑定view和viewModel
 */
- (void)bindToViewModel
{
    RAC(self.viewModel, vercode) = _vercodeTextField.rac_textSignal;
    RAC(self.viewModel, password) = _passwordTextField.rac_textSignal;
    RAC(self.viewModel, verPassword) = _verPasswordTextField.rac_textSignal;
}
/**
 *  修改密码完成
 */
-(void)updatePasswordDone
{
    __weak QYResetPasswordViewController *wself = self;
    QYLoginViewModel *loginViewModel = [[QYLoginViewModel alloc] init];
    loginViewModel.username = _viewModel.phone;
    loginViewModel.password = _viewModel.password;
    
    [loginViewModel loginButtonActionSuccess:^(LoginSuccessState successState)
    {
        if (successState == LoginSuccessStateMultiunit)
        {
            QYLoginSwitchUnitViewController *switchUnitViewController = [[QYLoginSwitchUnitViewController alloc] init];
            [wself.navigationController pushViewController:switchUnitViewController animated:YES];
            switchUnitViewController.completBlock = ^
            {
                [wself loginDone];
            };
        }
        else
        {
            [wself loginDone];
        }
    }
    failure:^(NSString *alert)
    {
        [QYDialogTool showDlg:wself.view withLabel:alert];
    }];
}
/**
 *  登录完成
 */
-(void)loginDone
{
//    QYAccount *defaultAccount = [[QYAccountService shared] defaultAccount];
    [[QYInitUI shared] initUI:nil];
}
/**
 *  背景view点击事件
 */
- (IBAction)loseFristResponse:(id)sender{
    [self.view endEditing:YES];
    _oneLineView.backgroundColor = [UIColor themeSeparatorLineColor];
    _twoLineView.backgroundColor = [UIColor themeSeparatorLineColor];
    _threeLineView.backgroundColor = [UIColor themeSeparatorLineColor];
}
#pragma mark - getters and setters
/**
 *  viewModel set方法
 */
-(void)setViewModel:(QYResetPasswordViewModel *)viewModel
{
    _viewModel = viewModel;
    __weak QYResetPasswordViewController *wself = self;
   //倒计时
    _viewModel.showCountdown=^(BOOL isHiddenResendButton,NSInteger s)
    {
        wself.resendButton.hidden = isHiddenResendButton;
        wself.countdownLabel.hidden = !isHiddenResendButton;
        wself.countdownLabel.text = [NSString stringWithFormat:@"%ld",(long)s];
    };
}

@end
