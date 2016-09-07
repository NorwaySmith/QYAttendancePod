//
//  QYH5DatePicker.h
//  QYBaseProject
//
//  Created by 田 on 15/8/11.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  选中的时间回调
 *
 *  @param date 选中的时间
 */
typedef void (^QYH5DatePickerChangeBlock)(NSString *date);

@interface QYH5DatePicker : UIDatePicker
/**
 *  选中的时间回调
 */
@property(nonatomic,copy)QYH5DatePickerChangeBlock datePickerChangeBlock;
/**
 *  初始化时间选择picker
 *
 *  @param defaulDate     默认时间
 *  @param datePickerMode picker类型
 *  @param format         需要初始化为的字符串
 *
 *  @return datePicker
 */
-(instancetype)initWithDefaulDate:(NSString*)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode format:(NSString *)format;
/**
 *  显示
 */
-(void)show;
/**
 *  关闭
 */
-(void)close;

@end
