//
//  QYLoginViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYLoginViewController.h"
#import "QYLoginView.h"
#import "QYLoginViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "QYLoginNetworkApi.h"
#import "QYDialogTool.h"
#import "QYAccountService.h"
#import "QYLoginSwitchUnitViewController.h"
#import "QYForgetPasswordViewController.h"
#import "QYFunctionExplainViewController.h"
#import "QYExperienceViewController.h"
#import "QYInitUI.h"
#import "QYVersionHelper.h"
#import "QYURLHelper.h"
#import <QYDIDIReminCBB/QYDiDiNewMsgHelper.h>
#import <QYAddressBook/QYABBasicDataHelper.h>
#import <NoticeMsgCBB/QYSMSMobanHelper.h>
#import "QYLoginConstant.h"
#import "Html5PlusRegisterViewController.h"
/**
 * TextFiled输入中底部线条颜色
 */
#define TextFiledInputColor [UIColor colorWithRed:0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0]

@interface QYLoginViewController ()
<UITextFieldDelegate>
/**
 *  登录主View
 */
@property (nonatomic,strong) QYLoginView *mainView;
/**
 *  登录viewModel
 */
@property (nonatomic,strong) QYLoginViewModel *viewModel;


@end

@implementation QYLoginViewController
#pragma mark - life cycle
- (void)dealloc{

}

- (instancetype)init{
    if (self = [super init])
    {
        [self initializeViewModel];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self addMainView];
    
    [self bindToViewModel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 延迟获取第一响应，解决IOS9中，退出登录键盘不能自动弹出
    [self performSelector:@selector(usernameTextFieldFirstResponder)
               withObject:nil
               afterDelay:0.5];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

/**
 *  添加mainView
 */
-(void)addMainView{
    QYLoginView *mainView = [[QYLoginView alloc] initWithFrame:self.view.bounds];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mainView.usernameTextField.delegate = self;
    mainView.passwordTextField.delegate = self;
    [self.view addSubview:mainView];
    mainView.usernameTextField.text = [self phone344:_phone];

    self.mainView = mainView;
    
    __weak QYLoginViewController *wself = self;
    //登录按钮点击回调
    self.mainView.loginButtonClick = ^(NSString *username,NSString *password)
    {
        wself.mainView.loginButton.userInteractionEnabled = NO;
        [wself.mainView.usernameTextField resignFirstResponder];
        [wself.mainView.passwordTextField resignFirstResponder];
        
        [wself.viewModel loginButtonActionSuccess:^(LoginSuccessState successState)
         {
             if (successState == LoginSuccessStateMultiunit){
                 QYLoginSwitchUnitViewController *switchUnitViewController = [[QYLoginSwitchUnitViewController alloc] init];
                 
                 [wself.navigationController pushViewController:switchUnitViewController animated:YES];
                 switchUnitViewController.completBlock = ^
                 {
                     [wself loginDone];
                 };
                 wself.mainView.loginButton.userInteractionEnabled = YES;
             }else{
                 [wself loginDone];
                 wself.mainView.loginButton.userInteractionEnabled = YES;
             }
         }
         failure:^(NSString *alert){
             [wself.view endEditing:YES];
             [QYDialogTool showDlg:wself.view withLabel:alert];
             wself.mainView.loginButton.userInteractionEnabled = YES;
         }];
    };
    
    //忘记密码点击回调
    self.mainView.forgetPasswordButtonClick = ^(NSString *username){
        QYForgetPasswordViewController *forgetPasswordViewController = [[QYForgetPasswordViewController alloc] init];
        NSString *deleteSpaceUsername=[username stringByReplacingOccurrencesOfString:@" " withString:@""];
        forgetPasswordViewController.username = deleteSpaceUsername;
        [wself.navigationController pushViewController:forgetPasswordViewController animated:YES];
    };
    
    // 注册点击回调
    self.mainView.registerButtonClick = ^() {
        Html5PlusRegisterViewController *h5ViewController = [[Html5PlusRegisterViewController alloc] init];
        [wself.navigationController setNavigationBarHidden:NO animated:NO];
        [wself.navigationController pushViewController:h5ViewController animated:YES];
    };
    
    //体验点击回调
    self.mainView.experienceButtonClick = ^(){
        QYExperienceViewController *experienceVC = [[QYExperienceViewController alloc] init];
        [wself.navigationController setNavigationBarHidden:NO animated:NO];
        [wself.navigationController pushViewController:experienceVC animated:YES];
    };
}




#pragma mark - UITextFieldDelegate
/**
 *  textField已经开始编辑
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.mainView.userLine.backgroundColor = [UIColor appSeparatorColor];
    self.mainView.pwdLine.backgroundColor = [UIColor appSeparatorColor];
    if (textField==self.mainView.usernameTextField) {
        self.mainView.userLine.backgroundColor = TextFiledInputColor;
        self.mainView.pwdLine.backgroundColor = [UIColor appSeparatorColor];
    }else{
        self.mainView.userLine.backgroundColor = [UIColor appSeparatorColor];
        self.mainView.pwdLine.backgroundColor = TextFiledInputColor;
    
    }
}
/**
 *  textField已经结束编辑
 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.mainView.userLine.backgroundColor = [UIColor appSeparatorColor];
    self.mainView.pwdLine.backgroundColor = [UIColor appSeparatorColor];
}
/**
 *  textField中text发生改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.mainView.usernameTextField){
        //处理用户名3-4-4
        if (textField.text.length == 0){
            return YES;
        }
        
        if (![string isEqualToString:@""]){
            //3-4-4显示处理
            if ((range.location == 3) || (range.location == 8)){
                NSString *spaceStr = [NSString stringWithFormat:@"%@ ",textField.text];
                textField.text = spaceStr;
            }
        }else{
            if (textField.text.length <= 13){
                //3-4-4显示处理
                if ((range.location == 3) || (range.location == 8)){
                    NSString *spaceStr = [NSString stringWithFormat:@"%@",textField.text];
                    textField.text = spaceStr;
                }
            }
        }
        //textField.text长度
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
         //输入字符串长度
        NSInteger replaceLength = string.length;
        
        //自动切换输入框
        if (existedLength - selectedLength == 14){
            textField.text = [textField.text substringToIndex:14];
            return YES;
        }
        
        if (existedLength - selectedLength + replaceLength >= 14){
            [self.mainView.usernameTextField resignFirstResponder];
            [self.mainView.passwordTextField becomeFirstResponder];
            return NO;
        }
    }
    
    if (textField==self.mainView.passwordTextField){
        if (textField.text.length == 0){
            return YES;
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 20){
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField endEditing:YES];
}


#pragma mark - CustomDelegate
#pragma mark - event response
#pragma mark - private methods
/**
 *  登录完成
 */
-(void)loginDone{
//    QYAccount *account=[[QYAccountService shared] defaultAccount];
//    [QYLoginNetworkApi rememberLoginDeviceWithUserId:account.userId
//                                             success:^(NSString *responseString) {
//                                                 // 清空通讯录基础数据
//                                                 [[QYABBasicDataHelper shared] resetABData];
//                                                 [[QYSMSMobanHelper shared] resetSMSMobanData];
//                                                 //重置通讯录数据
//                                                 [[QYInitUI shared] initUI:nil];
//                                             }
//                                             failure:^(NSString *alert) {
//                                                 [QYDialogTool showDlg:NSLocalizedString(@"SSO_alertView_faildPrompt", nil)];
//                                             }];
    
}

/**
 *  绑定view和viewModel
 */
- (void)bindToViewModel{
    RAC(self.viewModel, username) = _mainView.usernameTextField.rac_textSignal;
    RAC(self.viewModel, password) = _mainView.passwordTextField.rac_textSignal;
}

/**
 *  初始化viewModel，监测viewModel数据变化，更新UI
 */
- (void)initializeViewModel{
    _viewModel = [[QYLoginViewModel alloc] init];
    
    __weak QYLoginViewController *wself = self;
    //登录按钮置灰
    _viewModel.loginButtonEnabled = ^(BOOL enabled){
        wself.mainView.loginButton.enabled = enabled;
    };
}

/**
 * usernameTextField变为第一响应
 */
-(void)usernameTextFieldFirstResponder{
    [self.mainView.usernameTextField becomeFirstResponder];
}
/**
 *  将手机号处理成344样式
 *
 *  @param phone 手机号
 *
 *  @return 344样式手机号
 */
-(NSString*)phone344:(NSString*)phone{
    NSMutableString *muString=nil;
    if (phone&&phone.length>8) {
        muString=[[NSMutableString alloc] initWithString:phone];
        [muString insertString:@" " atIndex:3];
        [muString insertString:@" " atIndex:8];
        
    }
    return muString;
}
#pragma mark - getters and setters

@end
