//
//  QYCircularProgressView.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//
//环形进度view
#import <UIKit/UIKit.h>

@protocol CircularProgressDelegate

/**
 *  定时器走完，暂时不用
 */
- (void)CircularProgressEnd;

/**
 *  定时器走完一圈
 */
- (void)CircularProgressOneCircle;

@end


@interface QYCircularProgressView : UIView
{
    /**
     *  起点坐标
     */
    CGFloat startAngle;
    /**
     *  重点坐标
     */
    CGFloat endAngle;
    /**
     *  一轮
     */
    int     totalTime;
    
    //    UIFont *textFont;
    //    UIColor *textColor;
    //    NSMutableParagraphStyle *textStyle;
    
    /**
     *  定时器
     */
    NSTimer *m_timer;
    /**
     *  bool值，定时器是否开启
     */
    bool b_timerRunning;
}

@property(nonatomic, assign) id<CircularProgressDelegate> delegate;

//计算值
@property(nonatomic)CGFloat time_left;

//第一次半个弧度秒数
@property(nonatomic)CGFloat firstNumber;

/**
 *  按秒数赋转一圈需要的时间
 *
 *  @param time 多少秒
 */
- (void)setTotalSecondTime:(CGFloat)time;

/**
 *  按分数赋转一圈需要的时间
 *
 *  @param time 几分钟
 */
- (void)setTotalMinuteTime:(CGFloat)time;

/**
 *  定时器开始
 */
- (void)startTimer;

/**
 *  定时器暂停
 */
- (void)stopTimer;

/**
 *  定时器释放
 */
- (void)pauseTimer;

@end
