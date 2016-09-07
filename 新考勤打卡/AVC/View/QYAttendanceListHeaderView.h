//
//  QYAttendanceListHeaderView.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYAttendanceEnum.h"
//环形进度view
#import "QYCircularProgressView.h"

@interface QYAttendanceListHeaderView : UIView

//签到签退按钮点击
@property (nonatomic, copy)void (^buttonClick)(QYUSerSignState *type);

@property (nonatomic, copy)void (^reLocation)(NSString *alert);
//
////考勤位置
//@property (nonatomic, copy)NSString *attendanceLocation;

//在打卡范围呢
@property (nonatomic, assign)BOOL isInRange;

//数据（是否可签到签退）
@property (nonatomic, strong)NSDictionary *dataDictionary;

//环形进度
@property (nonatomic,strong)QYCircularProgressView *circularProgress;

//签到状态变化
@property (nonatomic, assign)BOOL signInStatueChanged;

//签退状态变化
@property (nonatomic, assign)BOOL signOutStatueChanged;

/**
 *  地理位置信息更新
 */
-(void)localMessageChangedCanLocation:(BOOL)change location:(NSString *)location;

/**
 *  签到签退状态更新
 */
-(void)signOrsignOutStateChanged;



//重定位
@property (nonatomic, strong)UIButton *reLocationButton;

//上班打卡时间
@property (nonatomic,strong)UILabel *toWorkTimeLabel;

//下班打卡时间
@property (nonatomic,strong)UILabel *offWorkTimeLabel;

/**
 *  是否存在考勤方案
 */
@property (nonatomic,assign)BOOL isHavePlan;


@end
