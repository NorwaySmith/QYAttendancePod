//
//  QYOAuthManager.h
//  QYBaseProject
//
//  Created by 田 on 16/2/2.
//  Copyright © 2016年 田. All rights reserved.
//

/**
 *  生成oauth
 */
#import <Foundation/Foundation.h>
////////////////////////////////需加密处理的参数////////////////////////////////
/**
 *  用户id
 */
static NSString *UserIdKey = @"userId";
/**
 *  公司id
 */
static NSString *CompanyIdKey = @"companyId";
/**
 *  用户名
 */
static NSString *UserNameKey = @"userName";
/**
 *  密码
 */
static NSString *PassWordKey = @"passWord";
/**
 *  请求时间，默认当前时间
 */
static NSString *RequestTimeKey = @"requestTime";
/**
 *  接口版本，默认1.0
 */
static NSString *VersionKey = @"version";
/**
 *  来源 默认IOS
 */
static NSString *SourceKey = @"source";


@interface QYOAuthManager : NSObject


/**
 *  根据规则生成oauth
 *
 *  @param parameters 网络请求参数
 *
 *  @return oauth
 */
-(NSString *)generateOAuthWithParameters:(NSDictionary *)parameters;


@end
