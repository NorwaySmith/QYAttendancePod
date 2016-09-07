//
//  QYVersionNetworkApi.h
//  QYBaseProject
//
//  Created by 田 on 15/6/10.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYNetworkHelper.h"

@interface QYVersionNetworkApi : NSObject
//更新版本
+(void)updateVersion:(NSInteger)versionCode
              userId:(NSString*)userId
           companyId:(NSString*)companyId
             showHud:(BOOL)showHud
             success:(void (^)(NSString *responseString))success
             failure:(void (^)(NSString *alert))failure;
@end
