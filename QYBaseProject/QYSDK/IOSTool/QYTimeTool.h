//
//  QYTimeTool.h
//  IOSToolDemo
//
//  Created by 田 on 15/5/7.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYTimeTool : NSObject

/**
 *  @author 田鹏涛, 15-05-07 10:05:19
 *
 *  根据字符串获取当前时间
 *
 *  @param dateString 字符串时间
 *  @param format     时间格式
 *
 *  @return 时间
 */
+ (NSDate *)dateWithString:(NSString*)dateString format:(NSString *)format;

/**
 *  @author 田鹏涛, 15-05-07 10:05:16
 *
 *  根据时间获取字符串时间
 *
 *  @param dateString 字符串时间
 *  @param format     时间格式
 *
 *  @return 字符串时间
 */
+ (NSString *)stringWithDate:(NSDate*)date format:(NSString *)format;

/**
 *  @author 田鹏涛, 15-05-07 09:05:07
 *
 *  Description
 *
 *  @param timestamp 距1970年多少秒
 *  @param format    时间格式
 *
 *  @return 时间
 */
+ (NSString *)formatTime:(NSTimeInterval)timestamp formatWith:(NSString *)format;

/**
 *  @author 田鹏涛, 15-05-07 09:05:57
 *
 *  根据date来获取日期
 *
 *  @param date   时间
 *  @param format 时间格式
 *
 *  @return 格式化后的时间字符串
 */
+ (NSString *)formatDate:(NSDate *)date formatWith:(NSString *)format;

/**
 *  @author 田鹏涛, 15-05-07 09:05:30
 *
 *  获取时间差
 *
 *  @param timestamp 距1970年多少秒
 *
 *  @return e.g. 3小时前 3小时前 3分钟前
 */
+ (NSString *)getTimeDiffString:(NSTimeInterval)timestamp;

/**
 *  @author 田鹏涛, 15-05-07 10:05:06
 *
 *  获取时间差
 *
 *  @param dateString 字符串时间
 *  @param format     时间格式
 *
 *  @return e.g. 3小时前 3小时前 3分钟前
 */
+(NSString*)getTimeDiffString:(NSString*)dateString format:(NSString *)format;

@end
