//
//  QYAttendanceListTableView.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAttendanceListTableView : UIView

@property (nonatomic, strong)NSArray *dataArray;

/**
 *  查看备注
 */
@property (nonatomic ,copy)void (^cellDetail)(NSString *memo ,NSString *pushCardTime ,NSString *location);

/**
 *  刷新，重新打卡
 */
@property (nonatomic ,copy)void (^refreshNewAttention)(NSString *attType);

//是否为考勤日（休息日也可以打卡）
@property (nonatomic, assign)BOOL isNeedAttendance;

@end
