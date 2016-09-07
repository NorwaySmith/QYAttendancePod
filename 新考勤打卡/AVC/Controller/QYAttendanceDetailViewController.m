//
//  QYAttendanceDetailViewController.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceDetailViewController.h"
#import "QYAttendanceDetailHeader.h"
#import "QYAttendanceDetailTableView.h"
#import "QYDeviceInfo.h"
#import "QYAttendanceDetailCellModel.h"
#import "QYAttendanceApi.h"
//空数据页面
#import "QYAttendanceListNoDataView.h"

#import "YLPopViewController.h"
#import "QYDialogTool.h"

#define popWidth (float)[QYDeviceInfo screenWidth]/320*237
#define popHeight (float)[QYDeviceInfo screenWidth]/320*250

@interface QYAttendanceDetailViewController()<QYAttendanceHeaderDelegate>

//头部视图
@property (nonatomic, strong)QYAttendanceDetailHeader *header;

////列表空数据
@property (nonatomic, strong)QYAttendanceListNoDataView *attendanceNoData;

//下部列表
@property (nonatomic, strong)QYAttendanceDetailTableView *tableView;

@end
@implementation QYAttendanceDetailViewController

#pragma mark - life cycle

- (instancetype)init{
    if (self = [super init]){
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title=@"考勤查看";
    
    //头部
    [self configureHeaderView];
//
    //tableView
    [self configureTable];
    
    //nodata
    [self addNotDataView];
    
    //初始当月数据
    [self getApiDetailDataWithDictionary:[QYAttendanceDetailCellModel getCurrentMonthAndYead] isBaseData:YES];
}

#pragma mark - UI

-(void)configureHeaderView{
    _header= [[QYAttendanceDetailHeader alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], [QYAttendanceDetailHeader getHoleViewHeight])];
    _header.headerDelegate=self;
    
    [self.view addSubview:_header];
}
-(void)configureTable{
    _tableView = [[QYAttendanceDetailTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_header.frame), [QYDeviceInfo screenWidth], [QYDeviceInfo screenHeight]-64-[QYAttendanceDetailHeader getHoleViewHeight])];
    _tableView.viewNotes=^(NSDictionary *dictionary,BOOL isNoon){
        YLPopViewController *popView = [[YLPopViewController alloc] init];
        popView.contentViewSize = CGSizeMake(popWidth, popHeight);
        popView.Title = @"打卡备注";
        popView.placeHolder = @"";
        if (isNoon) {
            popView.textViewText=dictionary[@"onMemo"];
            popView.timeString=dictionary[@"onTime"];
            popView.location=dictionary[@"onPosition"];
        }else{
            popView.textViewText=dictionary[@"offMemo"];
            popView.timeString=dictionary[@"offTime"];
            popView.location=dictionary[@"offPosition"];
        }
         popView.wordCount = 50;//不设置则没有
        [popView addContentView];//最后调用
    };
    [self.view addSubview:_tableView];
}
/**
 *  添加或删除无数据
 */
- (void)addNotDataView {
    // 初始化无数据视图
    self.attendanceNoData = [[QYAttendanceListNoDataView alloc]
                             initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth],
                                                      self.tableView.frame.size.height)];
    self.attendanceNoData.hidden = NO;
    self.attendanceNoData.type=QYAttedanceListDataTypeNoRecord;
    [self.tableView addSubview:self.attendanceNoData];
}

#pragma mark - event response
//获取上月数据
-(void)lastMonthClick{
    NSDictionary *lastMonthDic=[QYAttendanceDetailCellModel reduceMonthWithYeads:[_header.currentDictionary[@"localKey"][@"year"] integerValue] andMonth:[_header.currentDictionary[@"localKey"][@"month"] integerValue]];
    //并且刷新数据
    [self getApiDetailDataWithDictionary:lastMonthDic isBaseData:NO];
}

//获取下月数据
-(void)nextMonthClick{
    BOOL isCurrentMonth = [QYAttendanceDetailCellModel juedgeIfIsCurrentMonthWithYeads: [_header.currentDictionary[@"localKey"][@"year"] integerValue] andMonth:[_header.currentDictionary[@"localKey"][@"month"] integerValue]];
    if (isCurrentMonth==YES) {
        //NSLog(@"现在是当前月，没有下一月");
        [QYDialogTool showDlg:@"考勤数据截止到当月"];
    }else{
        //并且刷新数据
        [self getApiDetailDataWithDictionary:[QYAttendanceDetailCellModel addMonthWithYeads:[_header.currentDictionary[@"localKey"][@"year"] integerValue]  andMonth:[_header.currentDictionary[@"localKey"][@"month"] integerValue]] isBaseData:NO];
    }
}

#pragma mark - private methods

//获取详情数据
-(void)getApiDetailDataWithDictionary:(NSDictionary *)dictionary isBaseData:(BOOL)base{
    
    __weak QYAttendanceDetailViewController *bSelf = self;
    [QYAttendanceApi getThisMonthDataWithData:dictionary succeed:^(NSString *responseString) {
        NSDictionary *result =[NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *transLateDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:dictionary,result, nil] forKeys:[NSArray arrayWithObjects:@"localKey", @"dataKey",nil]];
        bSelf.header.currentDictionary=transLateDictionary;
        
        if ([result[@"noData"] intValue]==0) {
            bSelf.attendanceNoData.hidden=YES;
            bSelf.tableView.dataArray=result[@"list"];
        }else{
            bSelf.attendanceNoData.hidden=NO;
            bSelf.tableView.dataArray=[[NSArray alloc] init];
        }

        //获得数据以后刷新头部，刷新列表
    } failure:^(NSString *alert) {
    }];
}

#pragma mark - getters and setters
@end
