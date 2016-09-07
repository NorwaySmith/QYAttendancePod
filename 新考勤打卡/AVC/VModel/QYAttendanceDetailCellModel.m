//
//  QYAttendanceDetailCellModel.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceDetailCellModel.h"

@implementation QYAttendanceDetailCellModel
+(QYAttendanceDetailCellModel *)configureSignOrOut:(BOOL)signInOrOut
{
    QYAttendanceDetailCellModel *model = [[QYAttendanceDetailCellModel alloc] init];
    model.signOrOut=signInOrOut;
    return model;
}
//获取当前年月
+(NSDictionary *)getCurrentMonthAndYead{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger nowMonth= [components month];
    NSInteger nowYear= [components year];
    NSString *newMonth;
    if (nowMonth<10) {
        newMonth=[NSString stringWithFormat:@"0%ld",(long)nowMonth];
    }else{
        newMonth=[NSString stringWithFormat:@"%ld",(long)nowMonth];
    }
    return  [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",nowYear],[NSString stringWithFormat:@"%@",newMonth], nil] forKeys:[NSArray arrayWithObjects:@"year",@"month", nil]];
}

//下一月
+(NSDictionary *)addMonthWithYeads:(NSInteger)year andMonth:(NSInteger)month{
    if (month==12) {
        //跨年
        year+=1;
        month=1;
    }else{
        //跨月
        month+=1;
    }
    NSString *newMonth;
    if (month<10) {
        newMonth=[NSString stringWithFormat:@"0%ld",(long)month];
    }else{
        newMonth=[NSString stringWithFormat:@"%ld",(long)month];
    }
    NSDictionary *monthAndYeadrDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",year],[NSString stringWithFormat:@"%@",newMonth], nil] forKeys:[NSArray arrayWithObjects:@"year",@"month", nil]];
    return monthAndYeadrDictionary;
 }
//上一月
+(NSDictionary *)reduceMonthWithYeads:(NSInteger)year andMonth:(NSInteger)month{
    if (month==1) {
        //跨年
        year-=1;
        month=12;
    }else{
        //跨月
        month-=1;
    }
    NSString *newMonth;
    if (month<10) {
        newMonth=[NSString stringWithFormat:@"0%ld",(long)month];
    }else{
        newMonth=[NSString stringWithFormat:@"%ld",(long)month];
    }
    NSDictionary *monthAndYeadrDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",year],[NSString stringWithFormat:@"%@",newMonth], nil] forKeys:[NSArray arrayWithObjects:@"year",@"month", nil]];
    return monthAndYeadrDictionary;
}
//判断该月是不是当年当月
+(BOOL)juedgeIfIsCurrentMonthWithYeads:(NSInteger)year andMonth:(NSInteger)month{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger nowMonth= [components month];
    NSInteger nowYear= [components year];

    //年月都一样，为当前年月,不考虑大于当前时间的月份
    if (year==nowYear) {
        if (month==nowMonth) {
            return year;
        }
    }
    return NO;
}
@end
