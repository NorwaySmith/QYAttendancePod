//
//  QYAttendanceListCell.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYAttendanceListModel.h"

@interface QYAttendanceListCell : UITableViewCell

@property (nonatomic ,strong)QYAttendanceListModel *model;

@property (nonatomic ,strong)NSDictionary *dataDictionary;

/**
 *  查看备注
 */
@property (nonatomic, copy)void (^gotoDetail)(NSString *memo ,NSString *pushCardTime ,NSString *location);

/**
 *  新，重新打卡 打卡类型，签到or签退
 */
@property (nonatomic, copy)void (^refreshAttention)(NSString *attType);
@end
