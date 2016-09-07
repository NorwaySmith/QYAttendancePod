//
//  QYShakeView.m
//  QYBaseProject
//
//  Created by 田 on 15/12/29.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYShakeView.h"
#import "QYShakeHelper.h"

@implementation QYShakeView

/**
 *  我可以被响应
 */
-(BOOL)canBecomeFirstResponder {
    [super canBecomeFirstResponder];
    return YES;
}

/**
 *  检测到摇动
 */
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [[QYShakeHelper shared] motionBegan];
}

/**
 *  摇动取消
 */
- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [[QYShakeHelper shared] motionCancelled];
}

/**
 *  摇动结束
 */
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        //something happens
        [[QYShakeHelper shared] motionEnded];
    }
}

@end
