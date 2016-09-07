//
//  UIImage+ToolExtend.h
//  QYBaseProject
//
//  Created by quanya on 15/12/28.
//  Copyright © 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ToolExtend)

/**
 *  根据颜色生成图片
 *  @param color 颜色对象
 *
 *  @return 图片对象
 */
+ (UIImage *)imageWithColor: (UIColor *)color;

/**
 *  根据颜色生成图片
 *  @param color 颜色对象
 *
 *  @return 图片对象
 */
- (UIImage *)imageWithColor: (UIColor *)color;

@end
