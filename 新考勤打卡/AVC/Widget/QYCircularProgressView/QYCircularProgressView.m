//
//  QYCircularProgressView.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYCircularProgressView.h"
#import "QYDeviceInfo.h"

#define RADIUS (CGFloat)[QYDeviceInfo screenWidth]/320*240/4   //指示器半径
#define POINT_RADIUS 3   //头部圆点宽度
#define CIRCLE_WIDTH 1  //指示器环形半径
#define PROGRESS_WIDTH 1  //进度环形半径
#define TEXT_SIZE 30
#define TIMER_INTERVAL 0.1  //秒表跳帧


@implementation QYCircularProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
    // 圆周为 2 * pi * R, 默认起始点于正右方向为 0 度， 改为正上为起始点
    startAngle = -0.5 * M_PI;
    endAngle = startAngle;
    _firstNumber=0.00;

    totalTime = 0;
    /*
     //里面秒表字体颜色
     textFont = [UIFont fontWithName: @"Helvetica Neue" size: TEXT_SIZE];
     textColor = [UIColor whiteColor];
     textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
     textStyle.lineBreakMode = NSLineBreakByWordWrapping;
     textStyle.alignment = NSTextAlignmentCenter;
     */
    b_timerRunning = NO;
    
}

- (void)initView {
    self.backgroundColor = [UIColor darkGrayColor];
}

- (void)drawRect:(CGRect)rect {
    //NSLog(@"1111");

    if (totalTime == 0){
        endAngle = startAngle;
    }else{
        //第一次点进来，获取到一个不是从0开始的秒数
        if (_firstNumber!=0.00) {
            //计算y所在的弧度坐标点
            endAngle = (1 - (double)(60-_firstNumber) / 60) * 2 * M_PI + startAngle;
            
        }else{
            //第一个弧度圈走完，走第二个圆形弧度圈
            endAngle = (1 - self.time_left / totalTime) * 2 * M_PI + startAngle;
        }
    }
    
    //画白色的圆圈
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                      radius:RADIUS
                  startAngle:0
                    endAngle:2 * M_PI
                   clockwise:YES];
    circle.lineWidth = CIRCLE_WIDTH;
    [[UIColor whiteColor] setStroke];
    [circle stroke];

    
    //画弧度，以圆心为坐标原点画图，右下为正
    UIBezierPath *progress = [UIBezierPath bezierPath];
    [progress addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                        radius:RADIUS
                    startAngle:startAngle
                      endAngle:endAngle
                     clockwise:YES];
    progress.lineWidth = PROGRESS_WIDTH;
    //    [[UIColor redColor] setStroke];
    [[UIColor colorWithRed:244.0/255.0 green:154.0/255.0 blue:12.0/255.0 alpha:1.0f]  set];
    [progress stroke];
    
    //根据最终y坐标酸圆圈的坐标
    CGPoint pos = [self getCurrentPointAtAngle:endAngle inRect:rect];
    [self drawPointAt:pos];
}

//设置初始值
-(void)setFirstNumber:(CGFloat)firstNumber{
    if (firstNumber==0.00) {
        return;
    }
    _firstNumber=firstNumber;
}
- (CGPoint)getCurrentPointAtAngle:(CGFloat)angle inRect:(CGRect)rect {
    //画个图就知道怎么用角度算了
    CGFloat y = sin(angle) * RADIUS;
    CGFloat x = cos(angle) * RADIUS;
    
    CGPoint pos = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    pos.x += x;
    pos.y += y;
    return pos;
}

//画点
- (void)drawPointAt:(CGPoint)point {
    
    UIBezierPath *dot = [UIBezierPath bezierPath];
    [dot addArcWithCenter:CGPointMake(point.x, point.y)
                   radius:POINT_RADIUS
               startAngle:0
                 endAngle:2 * M_PI
                clockwise:YES];
    dot.lineWidth = 1;
    //    [[UIColor redColor] setFill];
    [dot fill];
}

//按秒数赋转一圈需要的时间
- (void)setTotalSecondTime:(CGFloat)time {
    totalTime = time;
    self.time_left = totalTime;
}

//按分赋转一圈需要的时间
- (void)setTotalMinuteTime:(CGFloat)time {
    totalTime = time * 60;
    self.time_left = totalTime;
}

//启动定时去
- (void)startTimer {
    if (!b_timerRunning) {
        m_timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(setProgress) userInfo:nil repeats:YES];
        //timer加入到NSRunLoopCommonModes模式下，否则会被tableview的滑动阻碍
        [[NSRunLoop currentRunLoop] addTimer:m_timer forMode:NSRunLoopCommonModes];
        b_timerRunning = YES;
    }
}

//释放
- (void)pauseTimer {
    if (b_timerRunning) {
        [m_timer invalidate];
        m_timer = nil;
        b_timerRunning = NO;
    }
}

//不停drawRect
- (void)setProgress {
        //NSLog(@"gogogo:%f",self.time_left);
        if (self.time_left > 0) {
            self.time_left -= TIMER_INTERVAL;
            if (_firstNumber>0.00) {
                //若是开始的半个弧度，则自增
                _firstNumber+=TIMER_INTERVAL;
            }
            if ([self performSelector:@selector(setNeedsDisplay)]) {
                [self setNeedsDisplay];
            }
            if (_firstNumber>=60.00) {
// 第一圈半个弧度            一圈转满
                //NSLog(@"stop111111111111111");
                _firstNumber=0.00;
                [self setTotalMinuteTime:1];
                self.time_left=totalTime;
                [_delegate CircularProgressOneCircle];
            }
            
        } else {
//            其他圈弧度转完
            _firstNumber=0.00;
            [self setTotalMinuteTime:1];
            self.time_left=totalTime;
            [_delegate CircularProgressOneCircle];
         }
 }

//暂停，暂时用不到
- (void)stopTimer {
    [self pauseTimer];
    
    startAngle = -0.5 * M_PI;
    endAngle = startAngle;
    self.time_left = totalTime;
    [self setNeedsDisplay];
    
}
-(void)dealloc{
    
}
@end
