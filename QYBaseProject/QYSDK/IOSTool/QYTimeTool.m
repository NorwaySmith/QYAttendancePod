//
//  QYTimeTool.m
//  IOSToolDemo
//
//  Created by 田 on 15/5/7.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYTimeTool.h"

@implementation QYTimeTool
+ (NSDateFormatter *)dateFormatter {
    static dispatch_once_t pred;
    static NSDateFormatter *dateFormatter = nil;
    dispatch_once(&pred, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getTimeDiffString:(NSString *)dateString
                         format:(NSString *)format {
    NSDate *date = [self dateWithString:dateString format:format];
    return [self getTimeDiffString:[date timeIntervalSince1970]];
}
#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
+ (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}
+ (NSString *)getTimeDiffString:(NSTimeInterval)timestamp {
    timestamp = timestamp / 1000.0f;
    NSCalendar *cal = [self currentCalendar];
    NSDate *todate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDate *today = [NSDate date]; //当前时间
    unsigned int unitFlag =
    NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *gap = [cal components:unitFlag
                                   fromDate:today
                                     toDate:todate
                                    options:0]; //计算时间差
    
    if (ABS([gap day]) > 0) {
        return [NSString stringWithFormat:@"%ld天前", (long)(ABS([gap day]))];
    } else if (ABS([gap hour]) > 0) {
        return [NSString stringWithFormat:@"%ld小时前", (long)(ABS([gap hour]))];
    } else {
        return [NSString stringWithFormat:@"%ld分钟前", (long)(ABS([gap minute]))];
    }
}

+ (NSString *)formatTime:(NSTimeInterval)timestamp
              formatWith:(NSString *)format {
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timestamp];
    if (time == 0) {
        return @"";
    } else {
        return [self formatDate:time formatWith:format];
    }
}

// format :yyyy-MM-dd
+ (NSString *)formatDate:(NSDate *)date formatWith:(NSString *)format {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

@end
