//
//  QYH5DatePicker.m
//  QYBaseProject
//
//  Created by 田 on 15/8/11.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYH5DatePicker.h"

@interface QYH5DatePicker()

/**
 *  最底层的点击事件监测view，点击后关闭时间选择
 */
@property(nonatomic,strong)UIControl *bgControl;

/**
 *  需要初始化为的字符串
 */
@property(nonatomic,copy)NSString *format;

/**
 *  时间选择上的工具栏，暂时无用
 */
@property(nonatomic,strong)UIToolbar *toolbar;

@end

@implementation QYH5DatePicker

/**
 *  初始化时间选择picker
 *
 *  @param defaulDate     默认时间
 *  @param datePickerMode picker类型
 *  @param format         需要初始化为的字符串
 *
 *  @return datePicker
 */

-(instancetype)initWithDefaulDate:(NSString *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode format:(NSString *)format {
    self = [super init];
    if (self) {
        self.datePickerMode = datePickerMode;
        if (format&&![format isEqualToString:@""]) {
            self.format = format;
        }else{
            self.format = @"yyyy-MM-dd HH:mm:ss";
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = _format;
        NSDate *date = [dateFormatter dateFromString:defaulDate];
        if (date) {
            [self setDate:date animated:NO];
        }
        [self configBgControl];
        [self configToolBar];
    }
    return self;
}
/**
 *  显示
 */
-(void)show {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat pickerHeight = CGRectGetHeight(self.frame);
    self.toolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(_toolbar.frame));

    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+CGRectGetHeight(_toolbar.frame), [UIScreen mainScreen].bounds.size.width, pickerHeight);
    [[self window] addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^ {
        self.toolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - pickerHeight - CGRectGetHeight(_toolbar.frame), [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(_toolbar.frame));
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - pickerHeight, [UIScreen mainScreen].bounds.size.width, pickerHeight);
    }];
}

/**
 *  关闭
 */
-(void)close {
    CGFloat pickerHeight = CGRectGetHeight(self.frame);
    [[self window] addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.toolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(_toolbar.frame));
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+CGRectGetHeight(_toolbar.frame), [UIScreen mainScreen].bounds.size.width, pickerHeight);
    } completion:^(BOOL finished) {
        [_toolbar removeFromSuperview];
        [_bgControl removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)done {
    [self changeDate:self];
    [self close];
}

/**
 *  配置工具栏
 */
-(void)configToolBar {
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    _toolbar.barStyle = UIBarStyleDefault;
//    UIBarButtonItem *lefttem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成 " style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    _toolbar.items = @[centerSpace,right];
    [[self window] addSubview:_toolbar];
}

/**
 *  配置背景点击
 */
-(void)configBgControl {
    
    self.bgControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_bgControl addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [[self window] addSubview:_bgControl];
}
/**
 *  时间改变事件
 *
 *  @param datePicker datePicker对象
 */
-(void)changeDate:(UIDatePicker *)datePicker {
    
    if (_datePickerChangeBlock) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = _format;
        NSString *dateStr = [dateFormatter stringFromDate:datePicker.date];
        _datePickerChangeBlock(dateStr);
    }
}

/**
 *  得到window
 *
 *  @return window
 */
-(UIWindow *)window {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return window;
}

@end
