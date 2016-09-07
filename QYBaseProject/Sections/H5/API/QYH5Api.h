//
//  QYH5Api.h
//  QYBaseProject
//
//  Created by 田 on 15/8/14.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYNetworkHelper.h"

@interface QYH5Api : NSObject
/**
 *  h5图片上传及进度获取
 *
 *  @param fileData   data格式图片
 *  @param UpLoadproGress    进度块
 *  @param success 请求成功
 *  @param failure 请求失败
 */

+(void)upLoadImage:(NSData *)fileData
         urlString:(NSString *)urlString
        moduleCode:(NSString *)moduleCode
           success:(void (^)(NSString *responseString))success
           failure:(void (^)(NSString *alert))failure
    UpLoadproGress:(void(^)(float progress))UpLoadproGress;

@end
