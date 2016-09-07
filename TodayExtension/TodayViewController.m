//
//  TodayViewController.m
//  TodayExtension
//
//  Created by 田 on 15/12/22.
//  Copyright © 2015年 田. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize=CGSizeMake(320, 100);
    // Do any additional setup after loading the view from its nib.

    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}
/**
 *  嘀嘀按钮点击
 *
 *  @param sender 按钮
 */
- (IBAction)didiButtonClick:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"LGZTodayExtensionApp://action=GotoDidi"] completionHandler:^(BOOL success) {
        //NSLog(@"open url result:%d",success);
    }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
