//
//  QYAttendanceDetailHeader.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//
//详情头部
#import <UIKit/UIKit.h>
@protocol QYAttendanceHeaderDelegate<NSObject>

/**
 *  上月按钮点击
 */
-(void)lastMonthClick;

/**
 *  下月按钮点击
 */
-(void)nextMonthClick;
@end

@interface QYAttendanceDetailHeader : UIView
//获取屏幕高度
+(CGFloat)getHoleViewHeight;
@property (nonatomic, weak)id <QYAttendanceHeaderDelegate>headerDelegate;

//年月字典
@property (nonatomic, strong)NSDictionary *currentDictionary;
@end
