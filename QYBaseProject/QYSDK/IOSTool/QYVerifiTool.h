//
//  QYVerifiTool.h
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//  一切验证在这里扩展

#import <Foundation/Foundation.h>

@interface QYVerifiTool : NSObject

//验证邮箱是否合法
+ (BOOL) validateEmail:(NSString *)candidate;
//验证手机是否合法
+ (BOOL) validPhone:(NSString*)value;
//是否为url
+ (BOOL)validUrl;
@end
