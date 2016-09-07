//
//  QYResetPasswordViewModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/5.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYResetPasswordViewModel.h"
#import "QYLoginNetworkApi.h"
#import "IOSTool.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "QYLoginConstant.h"
@interface QYResetPasswordViewModel()

@property(nonatomic,weak)NSTimer *timer;

@end


@implementation QYResetPasswordViewModel

-(void)dealloc
{
    [_timer invalidate];
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupObserverationForTheDoneButtonsEnabledState];
        [self setupTimer];
    }
    return self;
}
/**
 *  完成按钮点击事件
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)doneButtonActionSuccess:(void (^)(NSString *alert))success
                       failure:(void (^)(NSString *alert))failure{
    if ([_vercode isNil])
    {
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYLoginSwitchUnitCell_vercodePrompt")];
        return;
    }
    if ([_password isNil])
    {
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYLoginSwitchUnitCell_passwordPrompt")];
        return;
    }
    
    if ([_verPassword isNil])
    {
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYLoginSwitchUnitCell_verPasswordPrompt")];
        return;
    }
    
    if (_password.length < 6 || _password.length > 20)
    {
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYLoginSwitchUnitCell_passwordFormatPrompt")];
        return;
    }
    
    if (_password.length < 6 || _password.length > 20)
    {
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYLoginSwitchUnitCell_passwordFormatPrompt")];
        return;
    }
    
    if (![_verPassword isEqualToString:_password])
    {
        [QYDialogTool showDlg:QYLoginLocaleString(@"QYLoginSwitchUnitCell_passwordDisagreePrompt")];
        return;
    }

    [QYLoginNetworkApi updatePassByCheckCode:_vercode  password:_password phone:_phone success:^(NSString *responseString)
    {
        success(QYLoginLocaleString(@"QYLoginSwitchUnitCell_successPrompt"));
    }
    failure:^(NSString *alert)
    {
        failure(alert);
    }];

}

/**
 *  倒计时按钮点击事件
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)countdownButtonActionSuccess:(void (^)(NSString *alert))success
                            failure:(void (^)(NSString *alert))failure
{
    
    if ([_phone isNil])
    {
        failure(QYLoginLocaleString(@"QYLoginSwitchUnitCell_phonePrompt"));
        return;
    }
    [QYLoginNetworkApi sendCheckCodeToPhone:_phone success:^(NSString *responseString)
    {
        success(QYLoginLocaleString(@"QYLoginSwitchUnitCell_vercodeSucessPrompt"));
        _countdown = 120;
    }
    failure:^(NSString *alert)
    {
        failure(alert);
    }];
}

/**
 *  监测按钮是否置灰,放controller和viewModel都行，原则：能放viewModel的都不放controller
 */
- (void)setupObserverationForTheDoneButtonsEnabledState
{
    [[[RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, vercode),RACObserve(self, password),RACObserve(self, verPassword)]] reduceEach:^id( NSString *phone, NSString *vercode,NSString *password, NSString *verPassword){
        
        if ([phone isNil]||[vercode isNil]||[password isNil]||[verPassword isNil]) {
            return @(NO);
        }
        return @(YES);
    }] subscribeNext:^(NSNumber *doneButtonEnabled)
    {
        if (_doneButtonEnabled)
        {
            _doneButtonEnabled([doneButtonEnabled boolValue]);
        }
    }];
}
/**
 *  开始倒计时
 */
-(void)setupTimer{

    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkCodeCountdown) userInfo:nil repeats:YES];
}
/**
 *  定时器调用方法
 */
-(void)checkCodeCountdown{
 
    BOOL isHiddenResendButton=YES;
    if (_countdown<=0) {
        isHiddenResendButton=NO;
    }
    if (_showCountdown) {
        _showCountdown(isHiddenResendButton,_countdown);
    }
    if (_countdown>0) {
        _countdown--;
    }
}
@end
