//
//  QYMoreSearchViewController.m
//  QYBaseProject
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreSearchViewController.h"
#import "QYMoreSearchTextField.h"
#import "QYMoreSearchButtonsView.h"
#import "QYMoreSearchResultTableViewController.h"
#import "IOSTool.h"
#import "QYMoreSearchTextField.h"

@interface QYMoreSearchViewController ()

@property (nonatomic, strong) QYMoreSearchTextField *sreachTextField;
@property (nonatomic, strong) QYMoreSearchButtonsView *searchButtonView;

@end

@implementation QYMoreSearchViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建导航上的按钮
    [self creatNavigationItem];
    
    //创建热门搜索按钮
    [self creatLabelButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _sreachTextField.text = @"";
}


#pragma makr - 创建导航上的按钮
- (void)creatNavigationItem
{
    //搜索框
    QYMoreSearchTextField *textField = [[QYMoreSearchTextField alloc] init];
    self.navigationItem.titleView = textField;
    _sreachTextField = textField;
    
    //搜索按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 40);
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont themeRightButtonFont];
    [btn addTarget:self action:@selector(sreach) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    if ([QYDeviceInfo systemVersion] >= 7.0)
    {
        negativeSpacer.width = -20;
    }
    else
    {
        negativeSpacer.width = -15;
    }
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, item];
    
}
#pragma mark - 点击搜索
- (void)sreach
{
    [_sreachTextField resignFirstResponder];
    
    if (!_sreachTextField.text || [_sreachTextField.text isEqualToString:@""])
    {
        [QYDialogTool showDlgAlert:@"请输入单位名称或集团号码"];
        return;
    }
    
    QYMoreSearchResultTableViewController *searchResultVC = [[QYMoreSearchResultTableViewController alloc] init];
    searchResultVC.searchContent = _sreachTextField.text;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}

#pragma mark - 创建热门搜索按钮
- (void)creatLabelButton
{
    _searchButtonView = [[QYMoreSearchButtonsView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_searchButtonView];
    
    __weak QYMoreSearchViewController *wself = self;
    _searchButtonView.searchButtonClick = ^(NSString * searchString)
    {
        QYMoreSearchResultTableViewController *searchResultVC = [[QYMoreSearchResultTableViewController alloc] init];
        searchResultVC.searchContent = searchString;
        [wself.navigationController pushViewController:searchResultVC animated:YES];
    };
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
