//
//  QYAttendanceListTableView.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceListTableView.h"
#import "UIColor+QYColorToHtmlColor.h"
#import "QYAttendanceListCell.h"
#import "QYDeviceInfo.h"
#import "QYAttendanceListModel.h"
#import "QYTheme.h"

@interface QYAttendanceListTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonnull, strong)UITableView *tableView;
@property (nonnull, strong)UILabel *headerLabel;
@property (nonnull, strong)UILabel *footerLabel;

@end

@implementation QYAttendanceListTableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.backgroundColor = [UIColor yellowColor];
    //NSLog(@"screenWidth:%ld",(long)[QYDeviceInfo screenWidth]);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    _tableView.rowHeight=77;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor baseTableViewBgColor];
    [self configureHeaderView];
    
    [self addSubview:_tableView];
}
-(void)configureHeaderView{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], 50)];
    headerBackView.backgroundColor=[UIColor clearColor];
    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, [QYDeviceInfo screenWidth]-12*2, 20)];
    _headerLabel.textColor=[UIColor blackColor];
//    _headerLabel.text=@"今天是无需考勤，好好休息吧";
    _headerLabel.font=[UIFont baseTextLarge];
    [headerBackView addSubview:_headerLabel];
    _tableView.tableHeaderView=headerBackView;
}
-(void)configureFooterView{
    UIView *footerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], 60)];
    footerBackView.backgroundColor=[UIColor clearColor];
    _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, [QYDeviceInfo screenWidth]-12*2, 20)];
    _footerLabel.textColor=[UIColor blackColor];
    _footerLabel.font=[UIFont baseTextLarge];
    _footerLabel.text=@"一天的工作结束了，好好休息吧";
    [footerBackView addSubview:_footerLabel];
    _tableView.tableFooterView=footerBackView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifyString = @"cellId";
//    QYAttendanceListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifyString];
//    if (!cell) {
//        cell=[[QYAttendanceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyString];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    }
    QYAttendanceListCell *cell = [[QYAttendanceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyString];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    cell.dataDictionary=_dataArray[indexPath.row];
    cell.gotoDetail=^(NSString *memo ,NSString *pushCardTime, NSString *location){
        _cellDetail(memo,pushCardTime,location);
    };
    cell.refreshAttention=^(NSString *attType){
        _refreshNewAttention(attType);
    };
//    if (indexPath.row%2==0) {
//        cell.model=[QYAttendanceListModel configureSignOrOut:YES];
//    }else{
//        cell.model=[QYAttendanceListModel configureSignOrOut:NO];
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)setIsNeedAttendance:(BOOL)isNeedAttendance{
    _isNeedAttendance = isNeedAttendance;
    if (_isNeedAttendance==YES) {
        _headerLabel.text=@"今天是休息日，好好休息吧";
        _footerLabel.text=@"";

    }else{
        _headerLabel.text=@"美好的一天开始了，祝您工作愉快";
        _footerLabel.text=@"一天的工作结束了，好好休息吧";

    }
}
-(void)setDataArray:(NSArray *)dataArray{

    _dataArray=dataArray;
    switch (dataArray.count) {
        case 0:
            _tableView.tableFooterView=nil;
            break;
        case 1:
            _tableView.tableFooterView=nil;
            break;
        case 2:
            [self configureFooterView];
            break;
    
        default:
            break;
    }
    [self.tableView reloadData];
}
@end
