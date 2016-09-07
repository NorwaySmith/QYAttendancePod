//
//  QYIconGengerator.h
//  QYIconGeneration
//
//  Created by opera on 15/9/25.
//  Copyright (c) 2015年 qytx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface QYABIconGengerator : NSObject

/**
 *  Get header image use user name.
 *
 *  @param name user name
 *
 *  @return the header image corresponding to the user name.
 */
- (UIImage *)getHeaderIconFromName: (NSString *)name;

/**
 *  删除所有根据名字生成的图片
 *
 *  @return 是否删除成功
 */
- (BOOL)clearDiskCaches;

@end
