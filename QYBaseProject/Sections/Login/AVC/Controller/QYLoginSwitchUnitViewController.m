//
//  QYLoginSwitchUnitViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/6/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYLoginSwitchUnitViewController.h"
#import "QYAccountService.h"
#import "QYTheme.h"
#import "IOSTool.h"
#import "QYLoginSwitchUnitCell.h"
#import "QYLoginConstant.h"
static NSString  *cellReuseIdentifier = @"QYLoginSwitchUnitCell";

@interface QYLoginSwitchUnitViewController ()
/**
 *  单位数组，tableView数据源
 */
@property (nonatomic,strong) NSArray *accountArray;

@end


@implementation QYLoginSwitchUnitViewController

#pragma mark - life cycle
-(void)dealloc{
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = QYLoginLocaleString(@"QYLoginSwitchUnitViewController_title");
    self.tableView.tableFooterView = [UIView new];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.backgroundColor = [UIColor themeListBackgroundColor];
    self.tableView.separatorColor = [UIColor appSeparatorColor];
    [self.tableView registerClass:[QYLoginSwitchUnitCell class] forCellReuseIdentifier:cellReuseIdentifier];
    
    self.accountArray = [[QYAccountService shared] allAccounts];
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ThemeListHeightDouble;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_accountArray count];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYLoginSwitchUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    QYAccount *account = _accountArray[indexPath.row];
    
    cell.account = account;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QYAccount *account = _accountArray[indexPath.row];
    QYAccount *defaultAccount = [[QYAccountService shared] defaultAccount];
    //如果当前所选单位，提示
//    if ([account.companyId  isEqualToString:defaultAccount.companyId]){
//        [QYDialogTool showDlg:self.view
//                    withLabel:QYLoginLocaleString(@"QYLoginSwitchUnitViewController_currUnitPrompt")];
//        return ;
//    }

    [[QYAccountService shared] setDefaultAccount:account];
    //完成回调
    if (_completBlock)
    {
        _completBlock();
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - CustomDelegate
#pragma mark - event response
#pragma mark - private methods


@end
