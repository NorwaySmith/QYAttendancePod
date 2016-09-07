//
//  UINavigationItem+correct_offset.m
//  QYBaseProject
//
//  Created by 田 on 15/7/10.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "UINavigationItem+correct_offset.h"
#import "QYDeviceInfo.h"

@implementation UINavigationItem (correct_offset)

- (void)setLeftBarButtonItem:( UIBarButtonItem *)leftBarButtonItem
{
    
    if ( [QYDeviceInfo systemVersion] >= 7.0)
    {
        // Add a spacer on when running lower than iOS 7.0
        UIBarButtonItem *negativeSpacer =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        negativeSpacer.width = - 10 ;
        [ self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem,nil ]];
    }
    else
    {
        // Just set the UIBarButtonItem as you would normally
//        [ self setLeftBarButtonItem :leftBarButtonItem];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    
    if ([QYDeviceInfo systemVersion] >= 7.0)
    {
        // Add a spacer on when running lower than iOS 7.0
        UIBarButtonItem *negativeSpacer =
        [[ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        
        negativeSpacer.width = -10;
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,rightBarButtonItem,nil ]];
    }
    else
    {
        // Just set the UIBarButtonItem as you would normally
//        [ self setRightBarButtonItem :rightBarButtonItem];
    }
}


@end
