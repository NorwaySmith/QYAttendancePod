//
//  QYAttendanceListModel.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceListModel.h"
#import <CoreLocation/CoreLocation.h>
#import "QYAccountService.h"
#import "QYAccount.h"
#import "QYAttendanceConstant.h"

@implementation QYAttendanceListModel
+(QYAttendanceListModel *)configureSignOrOut:(BOOL)signInOrOut
{
    QYAttendanceListModel *model = [[QYAttendanceListModel alloc] init];
    model.signOrOut=signInOrOut;
    return model;
}
+(NSString *)formatWithData:(NSString *)dataFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dataFormat];
    dateFormatter.dateFormat=@"HH:mm";
    NSString *timeString = [dateFormatter stringFromDate:date];
    return timeString;
}
+(NSString *)newfFormatWithData:(NSString *)dataFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dataFormat];
    dateFormatter.dateFormat=@"HH:mm";
    NSString *timeString = [dateFormatter stringFromDate:date];
    return timeString;
}
+(NSString *)secondFormatWithData:(NSString *)dataFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dataFormat];
    dateFormatter.dateFormat=@"dd日";
    NSString *timeString = [dateFormatter stringFromDate:date];
    return timeString;
}
+(NSDictionary *)getDayWeek{
    
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:now];

    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int minute = [comps minute];
    int   seconds = [comps second];

    int w = [comps weekday];
    NSString *weekStr=nil;
    
    if(w==1){
        weekStr=@"周日";
    }else if(w==2){
        weekStr=@"周一";
        
    }else if(w==3){
        weekStr=@"周二";
        
    }else if(w==4){
        weekStr=@"周三";
        
    }else if(w==5){
        weekStr=@"周四";
        
    }else if(w==6){
        weekStr=@"周五";
        
    }else if(w==7){
        weekStr=@"周六";
        
    }
    else {
        //NSLog(@"error!");
    }
    NSString *newMinute;
    if (minute<10) {
        newMinute = [NSString stringWithFormat:@"0%d",minute];
    }else{
        newMinute = [NSString stringWithFormat:@"%d",minute];
    }
    NSString *newMonth;

    if (month<10) {
        newMonth=[NSString stringWithFormat:@"0%d",month];
    }else{
        newMonth=[NSString stringWithFormat:@"%d",month];
    }
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",seconds],[NSString stringWithFormat:@"%d:%@",hour,newMinute],[NSString stringWithFormat:@"%@/%d  %@",newMonth,day,weekStr], nil] forKeys:[NSArray arrayWithObjects:@"seconds",@"time",@"day",nil]];
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d:%@",hour,newMinute],[NSString stringWithFormat:@"%d月%d日  %@",month,day,weekStr], nil] forKeys:[NSArray arrayWithObjects:@"time",@"day",nil]];

    return dictionary;
    
}

+(BOOL)compareAndDecidedWhichFirstOneDay:(NSString *)oneDayStr withAnotherDay:(NSString *)anotherDayStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
//    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
//    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //NSLog(@"date1 : %@, date2 : %@", oneDayStr, anotherDayStr);
    if (result == NSOrderedDescending) {
        ////NSLog(@"Date1  is in the future");
        return NO;
    }
    else if (result == NSOrderedAscending){
        ////NSLog(@"Date1 is in the past");
        return YES;
    }
    ////NSLog(@"Both dates are the same");
    return YES;
    
}

+(NSDictionary *)splitNomalDataFormat:(NSString *)dataFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dataFormat];
    dateFormatter.dateFormat=@"HH:mm";
    NSString *timeString = [dateFormatter stringFromDate:date];
    
    NSString *dateState;
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    if ([array[0] intValue]>12) {
        dateState=@"下午";
    }else{
        dateState=@"上午";
    }
    return [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:dateState, timeString,nil] forKeys:[NSArray arrayWithObjects:@"dateState",@"dateTime", nil]];
}
/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
+ (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    week =[self weekIncreaseweek:week];
    switch (week) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    return nil;
}

/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 ) {
        NSLog(@"0天0小时0分钟");
        return days;
    }
    else {
        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}
+(long)weekIncreaseweek:(long)week{
    if (week<=0) {
        week+=7;
        week = [self weekIncreaseweek:week];
    }
    return week;
}
// 获取当前是星期几
+ (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}
+(BOOL)DidGetSystermPower{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    if (account.signName&&[account.signName rangeOfString:QYAttendanceLocaleString(@"QYAttendanceListViewController_systermPowerTime")].location!=NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}
+(NSString *)GetRangeRandTimeWithTypeString:(NSString *)typeString needTime:(NSString *)needTime{
    if ([needTime rangeOfString:@":"].location==NSNotFound) {
        return @"";
    }
    if ([typeString isEqualToString:@"10"]) {
    return [self decreaseTimeWithTime:needTime];
        //上午签到，那么打卡时间规定在这个打卡时间前的半小时之内
    }else if ([typeString isEqualToString:@"21"]){
        return [self increaseTimeWithTime:needTime];
        //下午签退，那么打卡时间规定在这个打卡时间后的半小时之内
        
    }else{
        return @"";
    }
}
//11:45
+(NSString *)decreaseTimeWithTime:(NSString *)needTime{
    
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:now];
    
    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int minute = [comps minute];
    int   seconds = [comps second];
    NSString *uselessMonth ;
    if (month<10) {
        uselessMonth=[NSString stringWithFormat:@"0%d",month];
    }else{
        uselessMonth=[NSString stringWithFormat:@"%d",month];
    }
    NSString *uselessDay ;
    if (day<10) {
        uselessDay=[NSString stringWithFormat:@"0%d",day];
    }else{
        uselessDay=[NSString stringWithFormat:@"%d",day];
    }

    NSString *dataString = [NSString stringWithFormat:@"%d-%@-%@",year,uselessMonth,uselessDay];
    NSString *timeString;
    NSArray *separatorArray = [needTime componentsSeparatedByString:@":"];
    if (separatorArray.count>1) {
        int hourNew =[separatorArray[0] intValue];
        int minuteNew=[separatorArray[1] intValue];
        if (minuteNew>30) {
            minuteNew = minuteNew-[self getRangeNumber];
        }else{
            int another =[self getRangeNumber];
            if (minuteNew<another) {
                if (hourNew>0) {
                    minuteNew=minuteNew+60-[self getRangeNumber];
                    hourNew-=1;
                }
            }else{
                minuteNew=minuteNew-[self getRangeNumber];
            }
        }
        
        NSString *newMinute;
        if (minute<10) {
            newMinute = [NSString stringWithFormat:@"0%d",minuteNew];
        }else{
            newMinute = [NSString stringWithFormat:@"%d",minuteNew];
        }
        NSString *newhour;
        
        if (hourNew<10) {
            newhour=[NSString stringWithFormat:@"0%d",hourNew];
        }else{
            newhour=[NSString stringWithFormat:@"%d",hourNew];
        }

        NSString *newsecond;
        
        if (seconds<10) {
            newsecond=[NSString stringWithFormat:@"0%d",seconds];
        }else{
            newsecond=[NSString stringWithFormat:@"%d",seconds];
        }

        timeString = [NSString stringWithFormat:@"%@:%@",newhour,newMinute];
        return [NSString stringWithFormat:@"%@ %@:%@",dataString,timeString,newsecond];
    }else{
        return @"";
    }
}
+(NSString *)increaseTimeWithTime:(NSString *)needTime{
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:now];
    
    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int minute = [comps minute];
    int   seconds = [comps second];
    
    NSString *uselessMonth ;
    if (month<10) {
        uselessMonth=[NSString stringWithFormat:@"0%d",month];
    }else{
        uselessMonth=[NSString stringWithFormat:@"%d",month];
    }
    NSString *uselessDay ;
    if (day<10) {
        uselessDay=[NSString stringWithFormat:@"0%d",day];
    }else{
        uselessDay=[NSString stringWithFormat:@"%d",day];
    }

    NSString *dataString = [NSString stringWithFormat:@"%d-%@-%@",year,uselessMonth,uselessDay];
    NSString *timeString;
    NSArray *separatorArray = [needTime componentsSeparatedByString:@":"];
    if (separatorArray.count>1) {
        int hourNew =[separatorArray[0] intValue];
        int minuteNew=[separatorArray[1] intValue];
        minuteNew=minuteNew+[self getRangeNumber];
        if (minuteNew>=60) {
            if (hourNew>=23) {
                return @"";
            }else{
                minuteNew=minuteNew-60;
                hourNew+=1;
            }
        }
        NSString *newMinute;
        if (minuteNew<10) {
            newMinute = [NSString stringWithFormat:@"0%d",minuteNew];
        }else{
            newMinute = [NSString stringWithFormat:@"%d",minuteNew];
        }
        NSString *newhour;
        
        if (hourNew<10) {
            newhour=[NSString stringWithFormat:@"0%d",hourNew];
        }else{
            newhour=[NSString stringWithFormat:@"%d",hourNew];
        }

        NSString *newsecond;
        
        if (seconds<10) {
            newsecond=[NSString stringWithFormat:@"0%d",seconds];
        }else{
            newsecond=[NSString stringWithFormat:@"%d",seconds];
        }

        timeString = [NSString stringWithFormat:@"%@:%@",newhour,newMinute];
        return [NSString stringWithFormat:@"%@ %@:%@",dataString,timeString,newsecond];
    }else{
        return @"";
    }

}
//获取一个0-29的随机数
+(int)getRangeNumber{
    return arc4random() %30;
}
@end
