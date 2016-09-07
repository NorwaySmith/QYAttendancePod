//
//  QYPayStubViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/7/2.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYPayStubViewController.h"

@interface QYPayStubViewController ()

@end

@implementation QYPayStubViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"工资条";
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
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

@end
