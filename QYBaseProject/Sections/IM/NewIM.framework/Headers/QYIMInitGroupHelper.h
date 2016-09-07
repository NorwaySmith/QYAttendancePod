//
//  QYIMInitGroupHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/8/28.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  IM 初始化的helper
 */

#import <Foundation/Foundation.h>

@interface QYIMInitGroupHelper : NSObject

+ (QYIMInitGroupHelper *)shared;
/**
 *  初始化聊天群组
 */
- (void)initGroup;

@end
