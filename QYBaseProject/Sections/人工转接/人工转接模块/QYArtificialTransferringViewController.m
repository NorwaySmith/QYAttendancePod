//
//  QYArtificialTransferringViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/7/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYArtificialTransferringViewController.h"

#import "QYArtificialTransferringView.h"

#import "QYAccountService.h"

@interface QYArtificialTransferringViewController ()

@end


@implementation QYArtificialTransferringViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = @"人工转接";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setView];
}

- (void)setView
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    
    QYArtificialTransferringView *artificialTransferrView = [[QYArtificialTransferringView alloc] initWithFrame:self.view.bounds];
    artificialTransferrView.account = account;
    
    [self.view addSubview:artificialTransferrView];
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
