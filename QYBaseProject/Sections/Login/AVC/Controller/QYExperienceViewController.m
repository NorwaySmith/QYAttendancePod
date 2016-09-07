//
//  QYExperienceViewController.m
//  QYBaseProject
//
//  Created by lin on 16/4/15.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYExperienceViewController.h"
#import "Masonry.h"
#import "QYTheme.h"
#import "IOSTool.h"
#import "QYLoginNetworkApi.h"
#import "QYAccountService.h"
#import "QYInitUI.h"
#import "QYLoginSwitchUnitViewController.h"

#define kgetVerifyForTime                   120

@interface QYExperienceViewController ()<UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITextField           *nameTextField;
@property (nonatomic, strong) UITextField           *phoneTextField;
@property (nonatomic, strong) UITextField           *verifyTextField;

@property (nonatomic, strong) NSString              *nameString;

@property (nonatomic, assign) int                   kTime;
@property (strong, nonatomic) NSTimer               *timer;
@property (nonatomic, strong) UIButton              *getCodeButton;
@property (nonatomic, strong) UILabel               *getCodeLabel;

@property (nonatomic, assign) BOOL                  isShowPhone;

@end

@implementation QYExperienceViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"体验";
    _isShowPhone = YES;

    self.tableView.backgroundColor = [UIColor themeListBackgroundColor];
    [self configTableViewHeaderView];
    [self configTableViewFooterView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
/**
 *  @author 杨峰, 16-04-15 11:04:09
 *
 *  配置表的headerView
 */
- (void)configTableViewHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], levelPadding+15+44*4+3)];
    headerView.backgroundColor = [UIColor themeListBackgroundColor];
    self.tableView.tableHeaderView = headerView;
    
    UIView *nameView = [[UIView alloc] init];
    nameView.backgroundColor = [UIColor whiteColor];
    [nameView.layer setBorderColor:[[UIColor themeSeparatorLineColor] CGColor]];
    [nameView.layer setBorderWidth:0.5];
    [headerView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(levelPadding);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@(44));
    }];
    
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.delegate = self;
    _nameTextField.tag = 100;
    _nameTextField.placeholder = @"请输入姓名/昵称";
    _nameTextField.font = [UIFont baseTextLarge];
    _nameTextField.backgroundColor = [UIColor clearColor];
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.tintColor = [UIColor themeTextInputeCursorColor];
    [nameView addSubview:_nameTextField];

    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView.mas_centerY);
        make.left.equalTo(headerView.mas_left).offset(levelPadding);
        make.right.equalTo(headerView.mas_right).offset(-levelPadding);
    }];
    
    UIView *phoneView = [[UIView alloc] init];
    phoneView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@(44));
    }];
    
    _getCodeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _getCodeButton.backgroundColor = [UIColor clearColor];
    [_getCodeButton addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:_getCodeButton];
    
    _getCodeLabel = [[UILabel alloc] init];
    _getCodeLabel.backgroundColor = [UIColor clearColor];
    _getCodeLabel.textAlignment = NSTextAlignmentRight;
    _getCodeLabel.font = [UIFont baseTextLarge];
    _getCodeLabel.textColor = [UIColor themeBlueColor];
    _getCodeLabel.text = @"获取语音验证码";
    [phoneView addSubview:_getCodeLabel];
    
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.delegate = self;
    _phoneTextField.tag = 101;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.placeholder = @"请输入手机号码";
    _phoneTextField.font = [UIFont baseTextLarge];
    _phoneTextField.backgroundColor = [UIColor clearColor];
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.tintColor = [UIColor themeTextInputeCursorColor];
    [phoneView addSubview:_phoneTextField];
    
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView.mas_centerY);
        make.left.equalTo(headerView.mas_left).offset(levelPadding);
        make.right.equalTo(_getCodeButton.mas_left).offset(-levelPadding);
    }];
    [_getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView.mas_centerY);
        make.right.equalTo(headerView.mas_right).offset(-levelPadding);
        make.width.equalTo(@(120));
        make.height.equalTo(@(44));
    }];
    [_getCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView.mas_centerY);
        make.right.equalTo(headerView.mas_right).offset(-levelPadding);
        make.width.equalTo(@(120));
        make.height.equalTo(@([_getCodeLabel.font lineHeight]));
    }];
    
    UIView *verifyView = [[UIView alloc] init];
    verifyView.backgroundColor = [UIColor whiteColor];
    [verifyView.layer setBorderColor:[[UIColor themeSeparatorLineColor] CGColor]];
    [verifyView.layer setBorderWidth:0.5];
    [headerView addSubview:verifyView];
    [verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@(44));
    }];
    
    _verifyTextField = [[UITextField alloc] init];
    _verifyTextField.delegate = self;
    _verifyTextField.tag = 102;
    _verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verifyTextField.placeholder = @"请输入语音验证码";
    _verifyTextField.font = [UIFont baseTextLarge];
    _verifyTextField.backgroundColor = [UIColor clearColor];
    _verifyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verifyTextField.tintColor = [UIColor themeTextInputeCursorColor];
    [verifyView addSubview:_verifyTextField];
    
    [_verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verifyView.mas_centerY);
        make.left.equalTo(headerView.mas_left).offset(levelPadding);
        make.right.equalTo(headerView.mas_right).offset(-levelPadding);
    }];
    
    UIView *switchView = [[UIView alloc] init];
    switchView.backgroundColor = [UIColor whiteColor];
    [switchView.layer setBorderColor:[[UIColor themeSeparatorLineColor] CGColor]];
    [switchView.layer setBorderWidth:0.5];
    [headerView addSubview:switchView];
    [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verifyView.mas_bottom).offset(15);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@(44));
    }];
    
    UILabel *phonelabel = [[UILabel alloc] init];
    phonelabel.text = @"公开手机号";
    phonelabel.font = [UIFont baseTextLarge];
    phonelabel.backgroundColor = [UIColor clearColor];
    [switchView addSubview:phonelabel];

    UISwitch *openSwitch = [[UISwitch alloc] init];
    openSwitch.on = _isShowPhone;
    openSwitch.onTintColor = [UIColor themeBlueColor];
    [openSwitch addTarget:self action:@selector(updatePhoneStatus:) forControlEvents:UIControlEventValueChanged];
    [switchView addSubview:openSwitch];
    
    [phonelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(switchView.mas_centerY);
        make.left.equalTo(headerView.mas_left).offset(levelPadding);
        make.width.equalTo(@(100));
        make.height.equalTo(@([phonelabel.font lineHeight]));
    }];
    [openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phonelabel.mas_centerY);
        make.right.equalTo(headerView.mas_right).offset(-levelPadding);
    }];
    
    //监测输入框文字变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

/**
 *  @author 杨峰, 16-04-15 11:04:27
 *
 *  配置表的footerView
 */
- (void)configTableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], 100)];
    footerView.backgroundColor = [UIColor themeListBackgroundColor];
    self.tableView.tableFooterView = footerView;
    
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.text = @"您的用户名为手机号码，初始密码为123456";
    alertLabel.font = [UIFont baseTextMiddle];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:alertLabel];
    
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(15);
        make.left.equalTo(footerView.mas_left).offset(levelPadding);
        make.right.equalTo(footerView.mas_right).offset(-levelPadding);
        make.height.equalTo(@([alertLabel.font lineHeight]));
    }];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterButton setTitle:@"进入系统" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *bgImage = [UIImage imageWithColor:[UIColor themeBlueColor]];
    UIImage *bgHighlightImage = [UIImage imageWithColor:[UIColor themeSeparatorLineColor]];
    [enterButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [enterButton setBackgroundImage:bgHighlightImage forState:UIControlStateHighlighted];
    [enterButton.titleLabel setFont:[UIFont baseTextLarge]];
    enterButton.layer.masksToBounds = YES;
    enterButton.layer.cornerRadius = 8;
    [enterButton.layer setBorderColor:[[UIColor themeSeparatorLineColor] CGColor]];
    [enterButton.layer setBorderWidth:0.5];
    [enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:enterButton];
    
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertLabel.mas_bottom).offset(15);
        make.left.equalTo(footerView.mas_left).offset(levelPadding);
        make.right.equalTo(footerView.mas_right).offset(-levelPadding);
        make.height.equalTo(@(40));
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
/**
 *  textField中text发生改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        //删除
        return YES;
    }
    if (textField.tag == 100){

    }
    if (textField.tag == 101){
        if (textField.text.length >= 11) {
            return NO;
        }
    }
    if (textField.tag == 102){
        if (textField.text.length >= 4) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField endEditing:YES];
}

#pragma mark - event response
/**
 *  @author 杨峰, 16-04-15 12:04:17
 *
 *  获取语音验证码
 */
- (void)getCodeButtonClick :(UIButton *)sender {
    //取消输入框的响应
    [self.view endEditing:YES];
    
    if ([QYVerifiTool validPhone:_phoneTextField.text]) {
        [QYDialogTool showDlg:@"请接收来自乐工作拨打的语音验证码电话"];
        sender.enabled = NO;
        _kTime = kgetVerifyForTime;
        
        self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeButtonName) userInfo:nil repeats:YES];
        
        //请求语音验证码
        [QYLoginNetworkApi getVerifyFromPhone:_phoneTextField.text success:^(NSString *responseString) {
            
        } failure:^(NSString *alert) {
            
        }];
    }else{
        [QYDialogTool showDlg:@"请输入正确的手机号码"];
    }
}
/**
 *  @author 杨峰, 16-04-15 13:04:04
 *
 *  监测是否隐藏号码的事件
 */
- (void)updatePhoneStatus :(UISwitch *)sender {
    //取消输入框的响应
    [self.view endEditing:YES];
    _isShowPhone = sender.on;
}
/**
 *  @author 杨峰, 16-04-15 14:04:37
 *
 *  进入系统的事件
 */
- (void)enterButtonClick :(UIButton *)sender {
    //取消输入框的响应
    [self.view endEditing:YES];

    if (![_nameString isNotNil]) {
        [QYDialogTool showDlg:@"姓名不能为空"];
        return;
    }
    if ([_phoneTextField.text isEqualToString:@""]) {
        [QYDialogTool showDlg:@"手机号不能为空"];
        return;
    }
    if ([_verifyTextField.text isEqualToString:@""]) {
        [QYDialogTool showDlg:@"验证码不能为空"];
        return;
    }
    
    //网络请求，成功后直接进入指定公司
    [QYLoginNetworkApi regExperUserWithUserName:_nameString phone:_phoneTextField.text isShow:_isShowPhone code:_verifyTextField.text success:^(NSString *responseString) {
        //隐藏登录，进入应用
        [self hideLogin];
    } failure:^(NSString *alert) {
        //判断号码是否已在体验公司
        if ([alert isEqualToString:@"手机号码重复!"]) {
            //隐藏登录，进入应用
            [self hideLogin];
        }else{
            [QYDialogTool showDlg:alert];
        }
    }];
}

/**
 *  输入框变化
 *
 *  @param notification 通知对象
 */
- (void)textFieldTextDidChange:(NSNotification*)notification {
    UITextField *textField = [notification object];
    if (textField.tag == 100) {
        _nameString = textField.text;
    }
}

#pragma mark - private methods
/**
 *  @author 杨峰, 16-04-15 15:04:38
 *
 *  计时器 响应方法
 */
- (void)changeButtonName {
    if (_kTime > 0) {
        self.getCodeButton.enabled = NO;
        _kTime--;
        NSString *string = [NSString stringWithFormat:@"%d秒", _kTime];
        self.getCodeLabel.text = string;
        self.getCodeLabel.textColor = [UIColor themeLightGrayColor];
    }else
    {
        [self.timer invalidate];
        self.getCodeButton.enabled = YES;
        self.getCodeLabel.text = @"获取语音验证码";
        self.getCodeLabel.textColor = [UIColor themeBlueColor];
    }
}
/**
 *  @author 杨峰, 16-04-15 16:04:39
 *
 *  隐藏登录
 */
- (void)hideLogin {
    [QYLoginNetworkApi loginWithUserName:_phoneTextField.text password:@"123456" showHud:NO success:^(NSString *responseString){

        NSDictionary *resultArray = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        //账户数组
        NSMutableArray *accountArray = [[NSMutableArray alloc] init];
        for (NSDictionary *resultDic in resultArray) {
            QYAccount *account = [[QYAccount alloc] initWithDictionary:resultDic error:nil];
            account.password = @"123456";
            [accountArray addObject:account];
        }
        //账户管理
        [[QYAccountService shared] createAccounts:accountArray];
        
        if ([resultArray count] >= 2){
            //多公司
            QYLoginSwitchUnitViewController *switchUnitViewController = [[QYLoginSwitchUnitViewController alloc] init];
            [self.navigationController pushViewController:switchUnitViewController animated:YES];
            switchUnitViewController.completBlock = ^ {
                //记录登录设备
                [self loginDone];
            };
        }
        else if([resultArray count] == 1){
            //单公司
            QYAccount *account = accountArray[0];
            [[QYAccountService shared] setDefaultAccount:account];
            //记录登录设备
            [self loginDone];
        }
    }passwordError:^(NSString *responseString)
     {
         [QYDialogTool showDlg:@"该手机号已申请体验，请重新登录。"];
         //NSLog(@"密码错误");
     }networkError:^(NSString *alert)
     {
         //NSLog(@"其他错误");
     }];
}

/**
 *  登录完成，记录登录设备
 */
-(void)loginDone{
    QYAccount *account=[[QYAccountService shared] defaultAccount];
    [QYLoginNetworkApi rememberLoginDeviceWithUserId:account.userId success:^(NSString *responseString) {
        //初始化项目控制器，进入
        [[QYInitUI shared] initUI:nil];
    }failure:^(NSString *alert) {
        [QYDialogTool showDlg:NSLocalizedString(@"SSO_alertView_faildPrompt", nil)];
    }];
}

#pragma mark - getters and setters


@end
