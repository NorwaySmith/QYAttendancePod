//
//  QYAnnexDownloadView.m
//  QYBaseProject
//
//  Created by 田 on 15/7/23.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAnnexDownloadView.h"
#import "QYTheme.h"
#import "IOSTool.h"
#import "QYAnnexDownloadModel.h"
#import "QYAnnexDownloadCell.h"
#import "QYAnnexDownloadDetailViewController.h"
#import "QYAnnexDownloadImageDetailViewController.h"

static NSString *const AnnexDownloadCell = @"AnnexDownloadCell";
/**
 *  表头附件label高度
 */
static CGFloat headLabel_height = 25;

@interface QYAnnexDownloadView()<QYAnnexDownloadCellProtocol>
/**
 *  附件数组
 */
@property(nonatomic,strong)NSArray *modelArray;
/**
 *  附件数组
 */
@property(nonatomic,strong)UITableView *tableView;
/**
 *  当前选中的下载实体类
 */
@property(nonatomic,strong)QYAnnexDownloadModel *currDownloadModel;

@end

@implementation QYAnnexDownloadView

-(instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray*)modelArray {
    CGRect reviseFrame = CGRectMake(CGRectGetMinX(frame),
                                    CGRectGetMinY(frame),
                                    CGRectGetWidth(frame),
                                    ThemeListHeightDoubleNew*[modelArray count]+headLabel_height);
    self=[super initWithFrame:reviseFrame];
    if (self) {
        _modelArray = modelArray;
        [self configTableView];
    }
    return self;
}
-(void)configTableView {
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], headLabel_height)];
    headLabel.backgroundColor = [UIColor themeAnnexHeaderLabelBgColor];
    headLabel.textColor = [UIColor themeAnnexHeaderLabelTextColor];
    headLabel.font = [UIFont themeAnnexHeaderLabelFont];
    headLabel.text = @"   附件";
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.tableView =  [[UITableView alloc] initWithFrame:frame];
    _tableView.delegate = (id<UITableViewDelegate>)self;
    _tableView.dataSource = (id<UITableViewDataSource>)self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = ThemeListHeightDoubleNew;
    _tableView.tableHeaderView = headLabel;
    [self addSubview:_tableView];
    [_tableView registerClass:[QYAnnexDownloadCell class] forCellReuseIdentifier:AnnexDownloadCell];
}
#pragma mark - QYAnnexDownloadCellProtocol

- (void)operationButtonClick:(QYAnnexDownloadCell *)cell {
    NSInteger row = [self.tableView indexPathForCell:cell].row;
    self.currDownloadModel = _modelArray[row];
    [self showActionSheet];

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_modelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYAnnexDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:AnnexDownloadCell forIndexPath:indexPath];
    cell.delegate = self;
    NSInteger row = indexPath.row;
    QYAnnexDownloadModel *annexDownloadModel = _modelArray[row];
    cell.annexDownloadModel = annexDownloadModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    self.currDownloadModel = _modelArray[row];
    [self gotoDetail:0];
}
#pragma mark - UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    [self gotoDetail:buttonIndex];
}
/**
 *  显示ActionSheet
 */
-(void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"附件" delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开附件",@"保存附件", nil];
    [actionSheet showInView:self];
}

/**
 *  跳转到详情
 */
-(void)gotoDetail:(NSInteger)index {
    NSString *type = [[_currDownloadModel.attachmentName pathExtension] lowercaseString];
    if ([type isEqualToString:@"png"]
        ||[type isEqualToString:@"jpg"]
        ||[type isEqualToString:@"jpeg"])
    {
        QYAnnexDownloadImageDetailViewController *detailViewController=[[QYAnnexDownloadImageDetailViewController alloc] init];
        detailViewController.annexDownloadModel = _currDownloadModel;
        detailViewController.title = @"打开附件";
        
        if (index == 1) {
            detailViewController.title = @"保存附件";
            [detailViewController startDownload];
        }
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else {
        QYAnnexDownloadDetailViewController *detailViewController = [[QYAnnexDownloadDetailViewController alloc] init];
        detailViewController.annexDownloadModel = _currDownloadModel;
        detailViewController.title = @"打开附件";

        if (index == 1) {
            detailViewController.title = @"保存附件";
            [detailViewController startDownload];
        }
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}


@end
