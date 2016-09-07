//
//  QYOperationTouchableView.h
//  BeiWenProject
//
//  Created by 田 on 14-8-7.
//  Copyright (c) 2014年 ZhangPengHai. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * delegate to receive touch events
 */
@class QYOperationTouchableView;

@protocol QYOperationTouchableViewDelegate<NSObject>

- (void)viewWasTouched:(QYOperationTouchableView *)view;

@end
@interface QYOperationTouchableView : UIView
@property (nonatomic, assign) BOOL touchForwardingDisabled;
@property (nonatomic, assign) id <QYOperationTouchableViewDelegate> delegate;
@property (nonatomic, copy) NSArray *passthroughViews;
@property (nonatomic, assign)BOOL testHits;
@end
