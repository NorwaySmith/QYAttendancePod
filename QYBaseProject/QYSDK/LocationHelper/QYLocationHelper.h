//
//  QYLocationHelper.h
//  QYBaseProject
//
//  Created by lin on 15/11/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QYLocationHelper : NSObject

+ (QYLocationHelper *)shared;

/**
 *  判断邮箱的正确性
 */
- (BOOL)isValidateEmailWithString:(NSString *)email;

/**
 *  获取归属地
 */
- (NSString *)thePhoneForPathWithPhone:(NSString *)phone;

/**
 *  判断电话号码的正确性
 */
- (BOOL)isMobileNumberWithPhone:(NSString *)phone;

/**
 *  归属地专用
 */
- (BOOL)isMobileNumber1WithString:(NSString *)string;

@end
