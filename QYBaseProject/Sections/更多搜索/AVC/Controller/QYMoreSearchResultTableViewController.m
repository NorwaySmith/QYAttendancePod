//
//  QYMoreSearchResultTableViewController.m
//  QYBaseProject
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreSearchResultTableViewController.h"
#import "QYMoreSearchNetWorkApi.h"
#import "MJRefresh.h"
#import "QYMoreSearchCompanyModel.h"
#import "QYMoreSearchResultCell.h"
#import "QYMoreSearchNoDataView.h"
#import "IOSTool.h"
#import "QYMoreSearchResultDetailViewController.h"

@interface QYMoreSearchResultTableViewController ()

@property (nonatomic, assign) int pageNum;   //当前分页数
@property (nonatomic, strong) NSMutableArray *searchResultArray;   //搜索结果列表

@property (nonatomic, strong) QYMoreSearchNoDataView * nodataView;

@end

@implementation QYMoreSearchResultTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"搜索结果";
    _searchResultArray = [NSMutableArray array];
    UIView * view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        [self headerStratRefreshing];
    }];
    
    [self.tableView.header beginRefreshing];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerStratRefreshing)];
    
    _nodataView = [[QYMoreSearchNoDataView alloc] initWithFrame:self.view.frame];
    _nodataView.hidden = YES;
    [self.view addSubview:_nodataView];
}

- (void)headerStratRefreshing
{
    _pageNum = 1;
    [_searchResultArray removeAllObjects];
    [self.tableView reloadData];
    [self getSearchList];
}

- (void)footerStratRefreshing
{
    _pageNum++;
    [self getSearchList];
}

#pragma mark  加载搜索结果
- (void)getSearchList
{
    [QYMoreSearchNetWorkApi loadListWithsearchName:_searchContent pageIndex:_pageNum success:^(NSString *responseString)
     {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        NSError *error;
        NSMutableArray *resultArray=[QYMoreSearchCompanyModel arrayOfModelsFromData:[responseString dataUsingEncoding:NSUTF8StringEncoding] error:&error];
        //NSLog(@"--=-=-=-%@", error);
        if (resultArray.count > 0)
        {
            for (int i = 0; i < resultArray.count; i++)
            {
                QYMoreSearchCompanyModel *companyModel = resultArray[i];
                [_searchResultArray addObject:companyModel];
            }
        }
        if (_searchResultArray.count > 0)
        {
            [self.tableView reloadData];
        }
        else
        {
            _nodataView.hidden = NO;
        }
    }
    failure:^(NSString *alert)
    {
        [QYDialogTool showDlg:alert];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  UITableViewDataSource - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYMoreSearchCompanyModel * companyModel = _searchResultArray[indexPath.row];
    QYMoreSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (nil == cell)
    {
        cell = [[QYMoreSearchResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.companyModel = companyModel;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    QYMoreSearchCompanyModel * companyModel = _searchResultArray[indexPath.row];
    QYMoreSearchResultDetailViewController *detailsViewController = [[QYMoreSearchResultDetailViewController alloc] init];
    detailsViewController.companyModel = companyModel;
    [self.navigationController pushViewController:detailsViewController animated:YES];
}





@end
