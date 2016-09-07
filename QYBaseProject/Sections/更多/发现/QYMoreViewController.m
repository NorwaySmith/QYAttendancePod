//
//  QYMoreViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreViewController.h"
#import "QYMoreAvatarCell.h"
#import "QYMoreDefaultCell.h"
#import "QYMoreModel.h"
#import "QYMoreViewModel.h"
#import "QYIndivCenterViewController.h"
//#import "QYRecommendAndFeedbackViewController.h"
#import "QYRecommendViewController.h"
#import "QYFeedbackViewController.h"

#import "QYSetViewController.h"
#import "QYMoreSearchViewController.h"
#import "QYPayStubViewController.h"

#import "QYAccount.h"
#import "QYAccountService.h"

#import "QYH5ViewController.h"
#import "QYNavigationViewController.h"

#import "QYURLHelper.h"

#import <QYAddressBook/QYABDb.h>
#import <QYAddressBook/QYABUserModel.h>

#import "QYPayStubViewController.h"

//#import "QYABDb.h"
//#import "QYABUserModel.h"

#import "MobClick.h"
#import "IOSTool.h"

//区间距
static CGFloat const SectionPadding = 6;
static NSString *const MoreAvatarCell = @"MoreAvatarCell";
static NSString *const MoreDefaultCell = @"MoreDefaultCell";

@interface QYMoreViewController ()
<QYMoreViewModelDelegate>

@property (nonatomic,strong) QYMoreViewModel *viewModel;
@property (nonatomic,strong) NSArray *modelArray;

@property (nonatomic,strong) QYABUserModel *userModel;

@end

@implementation QYMoreViewController

#pragma mark - life cycle
- (void)dealloc
{
    _viewModel = nil;
    _modelArray = nil;
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        [self initializeViewModel];

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor themeListBackgroundColor];
    self.tableView.separatorColor = [UIColor themeSeparatorLineColor];

    [self removeTableViewLine];
    
    //数据源
    [self assembleData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self assembleData];
    [self getSelf];
    
    [MobClick beginLogPageView:@"发现"];
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发现"];
}

/**
 *  初始化viewModel，监测viewModel数据变化，更新UI
 */
- (void)initializeViewModel
{
    _viewModel = [[QYMoreViewModel alloc] init];
    _viewModel.delegate=self;

}
-(void)removeTableViewLine
{
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [UIView new];
    self.tableView.backgroundColor = [UIColor themeBgColorGrey];
    self.tableView.separatorColor = [UIColor appSeparatorColor];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UITableViewDelegate
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    QYMoreModel *moreModel = _modelArray[section][row];
    if (moreModel.moreCellStyle == QYMoreCellStyleAvatar)
    {
        return ThemeListCellHeight;
    }
    else
    {
        return ThemeListHeightSingle;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_modelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_modelArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    QYMoreModel *moreModel = _modelArray[section][row];
    if (moreModel.moreCellStyle == QYMoreCellStyleAvatar)
    {
        QYMoreAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreAvatarCell];
        if (!cell)
        {
            cell = [[QYMoreAvatarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreAvatarCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   //配件类型
        }
        
        moreModel.imageUrl = self.userModel.photo;
        
        cell.moreModel = moreModel;
        
        return cell;
    }
    else
    {
        QYMoreDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreDefaultCell];
        if (!cell)
        {
            cell = [[QYMoreDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreDefaultCell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.section = section;
        cell.row = row;
        cell.moreModel = moreModel;
        
       return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    QYMoreModel *moreModel = _modelArray[section][row];
    
    if (moreModel.moreCellStyle == QYMoreCellStyleAvatar)
    {
        [self gotoIndivCenter];
    }
    else
    {
        if ([moreModel.modelTitle isEqualToString:@"使用统计"])
        {
            [self gotoStatistics];
        }
        if ([moreModel.modelTitle isEqualToString:@"工资条"])
        {
            [self gotoPayStub];
        }
        else if ([moreModel.modelTitle isEqualToString:@"推荐给朋友"])
        {
            [self gotoRecommendToFriend];
        }
        else if ([moreModel.modelTitle isEqualToString:@"问题反馈"])
        {
            [self gotoQuestion];
        }
        else if ([moreModel.modelTitle isEqualToString:@"设置"])
        {
            //点击后需要红点隐藏
            _viewModel.isHaveNewVersion=NO;
            [self gotoSet];
        }
        else if ([moreModel.modelTitle isEqualToString:@"更多搜索"])
        {
            [self moreSearch];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return SectionPadding * 2;
    }
    return SectionPadding;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SectionPadding;
}


#pragma mark - CustomDelegate

#pragma mark - event response
#pragma mark - private methods
-(void)assembleData
{
    self.modelArray = [_viewModel assembleData];
    
    [self.tableView reloadData];
}


//从通讯录数据库中得到自己
-(void)getSelf
{
    self.userModel = nil;
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    
    QYABUserModel *userModel = [QYABDb userWithUserId:account.userId];
    self.userModel = userModel;
    
    [self.tableView reloadData];
}


//个人中心
- (void)gotoIndivCenter
{
    QYIndivCenterViewController *indivCenterViewController = [[QYIndivCenterViewController alloc] initWithStyle:UITableViewStyleGrouped];
    indivCenterViewController.userModel = self.userModel;
    [self.navigationController pushViewController:indivCenterViewController animated:YES];
}

//使用统计
- (void)gotoStatistics
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    
    NSString *webURL = [[QYURLHelper shared] getUrlWithModule:@"report" urlKey:@"getReportInfo"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@userId=%@&companyId=%@&_clientType=wap&r=%d",webURL,account.userId,account.companyId,rand()]];
    
    QYH5ViewController *h5ViewController = [[QYH5ViewController alloc] initWithUrl:url];
    h5ViewController.navigationItem.title = @"使用统计";
    [self.navigationController pushViewController:h5ViewController animated:YES];
}

//工资条
- (void)gotoPayStub
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    NSString *webURL = [[QYURLHelper shared] getUrlWithModule:@"salary" urlKey:@"salary"];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@userId=%@&companyId=%@&_clientType=wap",webURL,account.userId,account.companyId]];
    QYH5ViewController *h5ViewController = [[QYH5ViewController alloc] initWithUrl:url];
    h5ViewController.navigationItem.title = @"工资条";
    
    [self.navigationController pushViewController:h5ViewController animated:YES];
    
//    QYPayStubViewController *h5ViewController = [[QYPayStubViewController alloc] init];
//    h5ViewController.navigationItem.title = @"工资条";
//    [self.navigationController pushViewController:h5ViewController animated:YES];
}

////推荐与反馈
//- (void)gotoRecommendAndFeedback
//{
//    QYRecommendAndFeedbackViewController *recommendAndFeedbackVC = [[QYRecommendAndFeedbackViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:recommendAndFeedbackVC animated:YES];
//}

- (void)gotoRecommendToFriend
{
    //推荐
    QYRecommendViewController *recommendVC = [[QYRecommendViewController alloc] init];
    recommendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommendVC animated:YES];
}

- (void)gotoQuestion
{
    //问题反馈
    QYFeedbackViewController *feedBackVC = [[QYFeedbackViewController alloc] init];
    feedBackVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedBackVC animated:YES];
}


//设置
- (void)gotoSet
{
    QYSetViewController *indivCenterViewController = [[QYSetViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController pushViewController:indivCenterViewController animated:YES];
}
//更多搜索
- (void)moreSearch
{
    QYMoreSearchViewController *moreSearchVC = [[QYMoreSearchViewController alloc] init];
    [self.navigationController pushViewController:moreSearchVC animated:YES];
}

#pragma mark - getters and setters

#pragma mark - notifition

/**
 *  更多需要刷新
 */
-(void)moreViewNeedReload{
    [self assembleData];
}
@end
