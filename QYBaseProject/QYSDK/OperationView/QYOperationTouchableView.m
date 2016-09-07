//
//  QYOperationTouchableView.m
//  BeiWenProject
//
//  Created by 田 on 14-8-7.
//  Copyright (c) 2014年 ZhangPengHai. All rights reserved.
//

#import "QYOperationTouchableView.h"
@interface QYOperationTouchableView(Private){

}

- (BOOL)isPassthroughView:(UIView *)v;

@end
@implementation QYOperationTouchableView
@synthesize touchForwardingDisabled, delegate, passthroughViews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)dealloc {

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if (_testHits) {
		return nil;
	} else if (touchForwardingDisabled) {
		return self;
	} else {
		UIView *hitView = [super hitTest:point withEvent:event];
		
		if (hitView == self) {
			//Test whether any of the passthrough views would handle this touch
			_testHits = YES;
			UIView *superHitView = [self.superview hitTest:point withEvent:event];
			_testHits = NO;
			
			if ([self isPassthroughView:superHitView]) {
				hitView = superHitView;
			}
		}
		
		return hitView;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate viewWasTouched:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
@implementation QYOperationTouchableView(Private)

- (BOOL)isPassthroughView:(UIView *)v {
	
	if (v == nil) {
		return NO;
	}
	
	if ([passthroughViews containsObject:v]) {
		return YES;
	}
	
	return [self isPassthroughView:v.superview];
}

@end
