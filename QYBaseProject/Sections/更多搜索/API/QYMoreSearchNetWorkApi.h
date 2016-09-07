//
//  QYMoreSearchNetWorkApi.h
//  QYBaseProject
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYNetworkHelper.h"

@interface QYMoreSearchNetWorkApi : NSObject

/**
 *  搜索结果列表
 *
 *  @param searchName searchName description
 *  @param pageIndex pageIndex description
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)loadListWithsearchName:(NSString *)searchName
                    pageIndex:(int)pageIndex
                      success:(void (^)(NSString *responseString))success
                      failure:(void (^)(NSString *alert))failure;
@end
