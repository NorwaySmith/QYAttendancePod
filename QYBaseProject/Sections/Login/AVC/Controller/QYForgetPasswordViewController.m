//
//  QYForgetPasswordViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYForgetPasswordViewController.h"
#import "QYResetPasswordViewController.h"
#import "QYResetPasswordViewModel.h"
#import "QYDialogTool.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MBProgressHUD.h"
#import "QYTheme.h"

#import "QYVerifiTool.h"
#import "QYLoginConstant.h"

@interface QYForgetPasswordViewController ()<UITextFieldDelegate>
/**
 *  手机号码TextField
 */
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
/**
 *  重置密码viewModel
 */
@property (nonatomic, strong) QYResetPasswordViewModel *viewModel;
/**
 *  手机号码TextField底部线
 */
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation QYForgetPasswordViewController

#pragma mark - life cycle

- (void)dealloc
{
    
    
}
- (instancetype)init
{
    if (self = [super init])
    {
        [self initializeViewModel];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = QYLoginLocaleString(@"QYForgetPasswordViewController_title");
    self.navigationController.navigationBarHidden = NO;
    
    /**
     *  右侧下一步按钮
     */
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont themeRightButtonFont];
    [rightButton setTitle:QYLoginLocaleString(@"QYForgetPasswordViewController_nextStep")
                 forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor themeRightButtonColor] forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor themeRightButtonHalfColor] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 60, 44);
    
    UIBarButtonItem *operationBar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                  target:nil action:nil];
    negativeSpacer.width = -15;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, operationBar];
    [self.phoneTextField becomeFirstResponder];
    
    [self bindToViewModel];
    _phoneTextField.text = _username;
    _phoneTextField.delegate = self;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CustomDelegate
#pragma mark - event response
/**
 *  下一步按钮点击事件
 */
-(void)nextStep{
    [self.view endEditing:YES];
    
    if ([QYVerifiTool validPhone:_phoneTextField.text] == NO){
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYForgetPasswordViewController_phoneNumberFormatPrompt")];
        _lineView.backgroundColor = [UIColor themeSeparatorLineColor];
    }else{
        [_viewModel countdownButtonActionSuccess:^(NSString *alert){
            [QYDialogTool showDlg:alert];
            QYResetPasswordViewController *resetPasswordViewController = [[QYResetPasswordViewController alloc] init];
            resetPasswordViewController.viewModel = _viewModel;
            
            [self.navigationController pushViewController:resetPasswordViewController animated:YES];
        }failure:^(NSString *alert){
            [QYDialogTool  showDlg:alert];
        }];
    }
}

#pragma mark - textFieldDelegate
/**
 * 键盘 return按钮点击事件
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self nextStep];
    return YES;
}
/**
 * textField将要开始编辑
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _lineView.backgroundColor = [UIColor themeForgetPwdSeparatorLineColor];
    return YES;
}

#pragma mark - private methods
/**
 *  初始化viewModel，监测viewModel数据变化，更新UI
 */
- (void)initializeViewModel
{
    _viewModel = [[QYResetPasswordViewModel alloc] init];
    
}

/**
 *  绑定view和viewModel
 */
- (void)bindToViewModel
{
    RAC(self.viewModel, phone) = _phoneTextField.rac_textSignal;
}
#pragma mark - getters and setters
/**
 *  username set方法
 */
-(void)setUsername:(NSString *)username{
    _username = username;
    
}
/**
 *  背景点击事件
 */
- (IBAction)loseFristResponse:(id)sender
{
    [self.view endEditing:YES];
    _lineView.backgroundColor = [UIColor themeSeparatorLineColor];
}


@end
