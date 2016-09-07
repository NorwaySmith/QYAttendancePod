//
//  QYShaUtil.m
//  QYBaseProject
//
//  Created by 田 on 16/2/2.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYShaUtil.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation QYShaUtil

/**
 *  sha1加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
+ (NSString *)sha1:(NSString *)plainText {
    const char *cstr = [plainText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:plainText.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

/**
 *  sha224加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
+ (NSString *)sha224:(NSString *)plainText {
    const char *cstr = [plainText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:plainText.length];
    
    uint8_t digest[CC_SHA224_DIGEST_LENGTH];
    
    CC_SHA224(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

/**
 *  sha256加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
- (NSString*)sha256:(NSString*)plainText{
    const char *cstr = [plainText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:plainText.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

/**
 *  sha384加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
- (NSString*)sha384:(NSString*)plainText{
    const char *cstr = [plainText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:plainText.length];
    
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

/**
 *  sha512加密
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
- (NSString*)sha512:(NSString*)plainText{
    const char *cstr = [plainText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:plainText.length];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes,  (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
