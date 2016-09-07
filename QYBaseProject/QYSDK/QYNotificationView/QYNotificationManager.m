//
//  QYNotificationManager.m
//  QYNotificationViewTest
//
//  Created by 田 on 16/1/26.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYNotificationManager.h"
#import "QYNotificationView.h"
#import "Masonry.h"
/**
 *  notificationView左间距
 */
static CGFloat notificationView_left=8;
/**
 *  notificationView右间距
 */
static CGFloat notificationView_right=-8;
/**
 *  notificationView高度
 */
static CGFloat notificationView_height=62;
/**
 *  上部间隔
 */
static CGFloat currentNotificationView_top=72;


@interface QYNotificationManager()
/**
 *  当前正在显示的notificationView
 */
@property(nonatomic,strong)NSMutableArray *notificationViewArray;
/**
 *  当前显示的
 */
@property(nonatomic,strong)QYNotificationView *currentNotificationView;

@end

@implementation QYNotificationManager

/**
 *  单例
 *
 *  @return QYNotificationManager对象
 */
+ (QYNotificationManager *)shared{
    static dispatch_once_t pred;
    static QYNotificationManager *sharedInstance = nil;
    dispatch_once(&pred, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        _notificationViewArray=[[NSMutableArray alloc] init];
        
    }
    return self;
    
}

/**
 *  向队列中添加notificationView
 *
 *  @param notificationView 弹出view
 */
-(void)addNotificationView:(QYNotificationView*)notificationView{
    UIWindow *window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:notificationView];
    
    [notificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(-notificationView_height));
        make.left.equalTo(@(notificationView_left));
        make.right.equalTo(@(notificationView_right));
        make.height.equalTo(@(notificationView_height));
    }];
    
    [_notificationViewArray insertObject:notificationView atIndex:0];
    
    if (!_currentNotificationView) {
        [self performSelector:@selector(showNextNotificationView)
                   withObject:nil
                   afterDelay:0.1];
    }
}

/**
 *  排队显示NotificationView
 */
-(void)showNextNotificationView{
    
    self.currentNotificationView=[_notificationViewArray firstObject];
    if (_currentNotificationView) {
        //显示动画
        [_currentNotificationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(currentNotificationView_top));
        }];
        UIWindow *window=[UIApplication sharedApplication].delegate.window;
        [UIView animateWithDuration:0.3 animations:^{
             [window setNeedsLayout];
             [window layoutIfNeeded];
         }completion:^(BOOL finished){
             [self performSelector:@selector(removeCurrentNotificationView)
                        withObject:nil
                        afterDelay:_currentNotificationView.duration];
         } ];
        
    }
    
}

/**
 *  删除当前显示的NotificationView
 */
-(void)removeCurrentNotificationView{
    if (_currentNotificationView) {
        [self removeNotificationView:_currentNotificationView];
    }
}

/**
 *  从队列中删除notificationView
 *
 *  @param notificationView 删除view
 */
-(void)removeNotificationView:(QYNotificationView*)notificationView{
    if (notificationView) {
        //取消runLoop中事件的响应
        [[self class] cancelPreviousPerformRequestsWithTarget:self
                                                     selector:@selector(removeCurrentNotificationView)
                                                       object:nil];
        //消失动画
        [UIView animateWithDuration:0.3 animations:^{
             notificationView.alpha=0;
         }completion:^(BOOL finished){
             [_notificationViewArray removeObject:notificationView];
             [notificationView removeFromSuperview];
             [self showNextNotificationView];
         }];
    }
}

@end
