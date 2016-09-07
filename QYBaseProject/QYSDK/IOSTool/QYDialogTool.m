//
//  QYDialogTool.m
//  IOSToolDemo
//
//  Created by 田 on 15/5/7.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYDialogTool.h"
#import "MBProgressHUD.h"

@implementation QYDialogTool

+ (void)showDlgAlert:(NSString *) label
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:label delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor clearColor]];
    //必须在这里调用show方法，否则indicator不在UIAlerView里面
    [alertView show];
}

+ (void)showDlgAlert:(NSString *) label cancelButtonTitle:(NSString *)str title:(NSString *)tips
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tips message:label delegate:self  cancelButtonTitle:str otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor clearColor]];
    //必须在这里调用show方法，否则indicator不在UIAlerView里面
    [alertView show];
}
+ (void)showDlg:(NSString *)label
{
    [self showDlg:[[UIApplication sharedApplication].delegate window] withLabel:label];
}
+ (void)showDlg:(UIView *)view  withLabel:(NSString *) label
{
    [self showDlg:view withLabel:label afterDelay:2];
}

+ (void)showDlg:(UIView *)view  withLabel:(NSString *)label afterDelay:(NSTimeInterval)afterDelay
{
     dispatch_async(dispatch_get_main_queue(), ^
    {
         MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
         [view addSubview:hud];
         hud.mode = MBProgressHUDModeText;
         hud.dimBackground = NO;
         hud.labelFont = [UIFont systemFontOfSize:16];
         hud.labelText = label;
         hud.margin = 5.f;
         hud.cornerRadius = 5.f;
         hud.yOffset = 150.f;
         [hud show:YES];
         [hud hide:YES afterDelay:afterDelay];
         view.userInteractionEnabled = YES;
     });
}


@end
