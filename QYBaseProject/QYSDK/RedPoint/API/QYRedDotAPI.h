//
//  QYRedDotAPI.h
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//  网络层

#import <Foundation/Foundation.h>

@interface QYRedDotAPI : NSObject
/**
 *  全部红点
 *
 *  @param success 成功
 *  @param failure 失败
 */
+(void)allRedPointSuccess:(void (^)(NSString *responseString))success
                  failure:(void (^)(NSString *alert))failure;
@end
