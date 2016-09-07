//
//  QYRecommendAndFeedbackViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYRecommendAndFeedbackViewController.h"

//#import "QYRecommendAndFeedbackView.h"
#import "QYRecommendAndFeedbackModel.h"
#import "QYRecommendAndFeedbackTableViewCell.h"

#import "QYRecommendViewController.h"
#import "QYFeedbackViewController.h"

static CGFloat const SectionPadding = 5;

@interface QYRecommendAndFeedbackViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSMutableArray *cellDataSource;


@end

@implementation QYRecommendAndFeedbackViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"推荐与反馈";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationController.title = @"推荐与反馈";
//    self.navigationItem.title =
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.tableView.backgroundColor = [UIColor themeListBackgroundColor];
    self.tableView.separatorColor = [UIColor themeSeparatorLineColor];
    
    [self removeTableViewLine];
    
    self.cellDataSource = [[NSMutableArray alloc] init];
    
    [self.cellDataSource addObject:[QYRecommendAndFeedbackModel recommendAndFeedbackValuationLogo:[UIImage imageNamed:@""] title:@"推荐给朋友"]];
    [self.cellDataSource addObject:[QYRecommendAndFeedbackModel recommendAndFeedbackValuationLogo:[UIImage imageNamed:@""] title:@"问题反馈"]];

}

-(void)removeTableViewLine
{
    self.tableView.tableFooterView = [UIView new];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"Cell";
    QYRecommendAndFeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil)
    {
        cell = [[QYRecommendAndFeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    QYRecommendAndFeedbackModel *recommendAndFeedback = self.cellDataSource[indexPath.row];
    cell.recommendAndFeedback = recommendAndFeedback;
    
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            //推荐
            QYRecommendViewController *recommendVC = [[QYRecommendViewController alloc] init];
            [self.navigationController pushViewController:recommendVC animated:YES];
        }
            break;
        case 1:
        {
            //问题反馈
            QYFeedbackViewController *feedBackVC = [[QYFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedBackVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ThemeListHeightSingle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionPadding;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
