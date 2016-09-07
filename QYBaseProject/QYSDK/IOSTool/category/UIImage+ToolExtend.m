//
//  UIImage+ToolExtend.m
//  QYBaseProject
//
//  Created by quanya on 15/12/28.
//  Copyright © 2015年 田. All rights reserved.
//

#import "UIImage+ToolExtend.h"

@implementation UIImage (ToolExtend)

/**
 *  根据颜色生成图片
 *  @param color 颜色对象
 *
 *  @return 图片对象
 */
+ (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 64.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  根据颜色生成图片
 *  @param color 颜色对象
 *
 *  @return 图片对象
 */
- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 64.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
