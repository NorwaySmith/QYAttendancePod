//
//  QYOldAlertView.m
//  ConferenceCall
//
//  Created by 田 on 13-5-28.
//  Copyright (c) 2013年 田. All rights reserved.
//

#import "QYOldAlertView.h"

@implementation QYOldAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)show
{
    [super show];
    self.delegate=self;
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_didSelectIndex != NULL) {
        _didSelectIndex(buttonIndex);
    }
}

@end
