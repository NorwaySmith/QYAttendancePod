//
//  QYShaUtil.h
//  QYBaseProject
//
//  Created by 田 on 16/2/2.
//  Copyright © 2016年 田. All rights reserved.
//
/**
 *  各种SHA加密
 */
#import <Foundation/Foundation.h>

@interface QYShaUtil : NSObject

/**
 *  sha1加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
+ (NSString *)sha1:(NSString *)plainText;

/**
 *  sha224加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
+ (NSString *)sha224:(NSString *)plainText;

/**
 *  sha256加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
- (NSString *)sha256:(NSString *)plainText;

/**
 *  sha384加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
- (NSString *)sha384:(NSString *)plainText;

/**
 *  sha512加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
- (NSString *)sha512:(NSString *)plainText;


@end
