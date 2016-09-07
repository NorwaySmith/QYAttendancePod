//
//  QYAttendanceDetailCellModel.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYAttendanceDetailCellModel : NSObject
@property (nonatomic, assign)BOOL signOrOut;

+(QYAttendanceDetailCellModel *)configureSignOrOut:(BOOL)signInOrOut;

/**
 *  获取当前年月
 *
 *  @return key(year , month)
 */
+(NSDictionary *)getCurrentMonthAndYead;
/**
 *  点击下月，月年的自增
 *
 *  @param year  传递过来的年
 *  @param month 传递过来的月
 *
 *  @return 下月数据 year month
 */
+(NSDictionary *)addMonthWithYeads:(NSInteger)year andMonth:(NSInteger)month;

/**
 *  点击上月，月年的自减、
 *
 *  @param year   传递过来的年
 *  @param month 传递过来的月
 *
 *  @return 上月数据 year month
 */
+(NSDictionary *)reduceMonthWithYeads:(NSInteger)year andMonth:(NSInteger)month;

/**
 *  判断传递过来的年月是否为当前年月
 *
 *  @param year  传递过来的年
 *  @param month 传递过来的月
 *
 *  @return YES 本年本月
 */
+(BOOL)juedgeIfIsCurrentMonthWithYeads:(NSInteger)year andMonth:(NSInteger)month;

@end
