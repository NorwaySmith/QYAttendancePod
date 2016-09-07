//
//  QYAttendanceDetailTableView.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//
//详情列表
#import "QYAttendanceDetailTableView.h"
#import "UIColor+QYColorToHtmlColor.h"
#import "QYDeviceInfo.h"
#import "QYAttendanceDetailCell.h"
#import "QYAttendanceDetailOnCellView.h"
#import "QYAttendanceDetailHeader.h"

@interface QYAttendanceDetailTableView()<UITableViewDelegate,UITableViewDataSource,QYAttendanceHeaderDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)QYAttendanceDetailOnCellView *tableHeaderView;
@property (nonatomic, strong)QYAttendanceDetailHeader *header;

@end
@implementation QYAttendanceDetailTableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc] init];
    _tableView.rowHeight=50;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_tableView];
    
//    [self configureHeaderView];
}
-(void)configureHeaderView{
    _tableHeaderView = [[QYAttendanceDetailOnCellView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    _tableHeaderView.type=QYAttendanceDetailOnCellViewTypeHeader;
    _tableView.tableHeaderView=_tableHeaderView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifyString = @"cellId";
    QYAttendanceDetailCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifyString];
    if (!cell) {
        cell=[[QYAttendanceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyString];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.dataDictionary=_dataArray[indexPath.row];
    cell.detailMemo=^(NSDictionary *dictionary,BOOL isNoon){
        _viewNotes(dictionary,isNoon);
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    [_tableView reloadData];
}

@end
