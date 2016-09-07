//
//  QYDES.h
//  QYBaseProject
//
//  Created by 田 on 16/2/2.
//  Copyright © 2016年 田. All rights reserved.
//
/**
 *  DES加密解密
 */
#import <Foundation/Foundation.h>

@interface QYDESUtil : NSObject

/**
 *  DES加密
 *
 *  @param plainText 明文
 *  @param key       key
 *
 *  @return 密文  16进制字符串
 */
+(NSString  *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

/**
 *  DES解密
 *
 *  @param cipherText 16进制密文
 *  @param key        key
 *
 *  @return 明文
 */
+(NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;


@end
