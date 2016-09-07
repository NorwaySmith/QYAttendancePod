//
//  QYIMBasicDb.h
//  QYBaseProject
//
//  Created by 田 on 15/8/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  IM 基础的DB处理
 */

#import <Foundation/Foundation.h>

@interface QYIMBasicDb : NSObject
+ (QYIMBasicDb*)shared;

+ (NSString*)dbPath;
/**
 *  获得登录人userId
 *
 *  @return userId
 */
- (NSNumber*)loginUserId;

/**
 *  执行多条sql语句
 *
 *  @param sqls sqls数组
 */
- (void)execSqls:(NSArray*)sqls;

@end
