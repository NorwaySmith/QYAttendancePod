//
//  QYResetPasswordViewController.h
//  CommunicationAssistant
//
//  Created by quanya on 14-11-17.
//  Copyright (c) 2014年 田. All rights reserved.
//
/**
 *  忘记密码，重置密码controller
 */
#import "QYViewController.h"
#import "QYResetPasswordViewModel.h"

@interface QYResetPasswordViewController : QYViewController
/**
 *  重置密码viewModel
 */
@property(nonatomic,strong)QYResetPasswordViewModel *viewModel;

@end
