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
//区间距
static CGFloat const SectionPadding = 22.5;

static NSString *const MoreAvatarCell = @"MoreAvatarCell";
static NSString *const MoreDefaultCell = @"MoreDefaultCell";

@interface QYMoreViewController ()
@property(nonatomic,strong)QYMoreViewModel *viewModel;
@property(nonatomic,strong)NSArray *modelArray;
@end

@implementation QYMoreViewController
#pragma mark - life cycle
- (void)dealloc
{
    
}
- (instancetype)init
{
    if (self = [super init]) {
        [self initializeViewModel];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeTableViewLine];
    [self.tableView registerClass:[QYMoreAvatarCell class] forCellReuseIdentifier:MoreAvatarCell];
    [self.tableView registerClass:[QYMoreDefaultCell class] forCellReuseIdentifier:MoreDefaultCell];
    [self assembleData];
    
}
/**
 *  初始化viewModel，监测viewModel数据变化，更新UI
 */
- (void)initializeViewModel
{
    _viewModel = [QYMoreViewModel new];

}
-(void)removeTableViewLine{
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.backgroundView = nil;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.tableView.backgroundColor = [UIColor themeBgColorGrey];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return SectionPadding;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    QYMoreModel *moreModel=_modelArray[section][row];
    if (moreModel.moreCellStyle==QYMoreCellStyleAvatar) {
        return ThemeListHeightDouble;
    }else{
        return ThemeListHeightSingle;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_modelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_modelArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    QYMoreModel *moreModel=_modelArray[section][row];
    if (moreModel.moreCellStyle==QYMoreCellStyleAvatar) {
        QYMoreAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreAvatarCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.moreModel=moreModel;
        return cell;
    }else{
        QYMoreDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreDefaultCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.moreModel=moreModel;
       return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - CustomDelegate

#pragma mark - event response
#pragma mark - private methods
-(void)assembleData{
    self.modelArray=[_viewModel assembleData];
    [self.tableView reloadData];
}
#pragma mark - getters and setters

@end
