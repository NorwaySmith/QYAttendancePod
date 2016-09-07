//
//  QYAttendanceListModel.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYAttendanceListModel : NSObject

@property (nonatomic, assign)BOOL signOrOut;

+(QYAttendanceListModel *)configureSignOrOut:(BOOL)signInOrOut;

//格式化时间HH:mm
+(NSString *)formatWithData:(NSString *)dataFormat;

//格式化时间HH:mm:ss
+(NSString *)newfFormatWithData:(NSString *)dataFormat;

//获取日期
+(NSDictionary *)getDayWeek;

//日期比较(前面的日期是否在前)
+(BOOL)compareAndDecidedWhichFirstOneDay:(NSString *)oneDayStr withAnotherDay:(NSString *)anotherDayStr;

//拆分时间段为需要的格式（key：dateState  dateTime）
+(NSDictionary *)splitNomalDataFormat:(NSString *)dataFormat;

/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
+(NSString *)featureWeekdayWithDate:(NSString *)featureDate;
/**
 *  yyyy-MM-dd to  MM月DD日
 *
 *  @param dataFormat MM月DD日
 *
 *  @return MM月DD日
 */
+(NSString *)secondFormatWithData:(NSString *)dataFormat;

/**
 *  是否已经获得了特权
 *
 *  @return 是的
 */
+(BOOL)DidGetSystermPower;

/**
 *  根据typeString获取一个规定时间段内的时间 格式为 yyyy-MM-dd HH:mm:ss（要求）
 *
 *  @param typeString 类别 打卡类别
 *  @param needTime 系统规定时间，例如上午打开时间 08：45  下午打开时间18：15
 *
 *  @return yyyy-MM-dd HH:mm:ss
 */
+(NSString *)GetRangeRandTimeWithTypeString:(NSString *)typeString needTime:(NSString *)needTime;
@end
