//
//  UIImage+Theme.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "UIImage+Theme.h"

@implementation UIImage (Theme)

+(UIImage *)themeNavBg
{
    return [UIImage imageNamed:@"base_navBarBg"];
};

+(UIImage *)themeBackButton
{
    return [[UIImage imageNamed:@"base_navBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
+(UIImage *)themeRightAddButton
{
    return [[UIImage imageNamed:@"base_navAdd"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


@end
