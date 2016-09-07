//
//  QYAttendanceManagerSettingModel.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/14.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceManagerSettingModel.h"

@implementation QYAttendanceManagerSettingModel
-(instancetype)init{
    self=[super init];
    if (self) {
        [self confirmArray];
    }
    return self;
}
-(void)confirmArray{
    NSArray *array1 =[NSArray arrayWithObjects:@"上班时间",@"下班时间",@"考勤地点",@"允许偏差", nil];
    NSArray *array2 =[NSArray arrayWithObjects:@"请选择",@"请选择",@"未设置",@"未设置", nil];
    self.leftDataArray =[[NSMutableArray alloc] initWithArray:array1];
    self.rightDataArray =[[NSMutableArray alloc] initWithArray:array2];
}
@end
