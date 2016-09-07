//
//  QYURLHelperNetworkApi.h
//  QYBaseProject
//
//  Created by 田 on 15/6/11.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYNetworkHelper.h"

@interface QYURLHelperNetworkApi : NSObject

+(void)allUrlWithProjectName:(NSString *)projectName
                 surrounding:(NSString *)surrounding
               lastVisitTime:(NSString *)lastVisitTime
                     success:(void (^)(NSString *responseString))success
                     failure:(void (^)(NSString *alert))failure;
@end
