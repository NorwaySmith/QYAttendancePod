//
//  QYRedDotDB.h
//  QYBaseProject
//
//  Created by 田 on 15/12/4.
//  Copyright © 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYRedDotModel.h"

@interface QYRedDotDB : NSObject

+(NSString *)dbPath;
+(void)createTable;

/**
 *  执行多条sql语句
 *
 *  @param sqls sqls数组
 */
+(void)execSqls:(NSArray*)sqls;

+(void)storageRedPointNum:(NSInteger)pointNum
               moduleCode:(NSString*)moduleCode;

+(QYRedDotModel *)redDotModelWithModuleCode:(NSString*)moduleCode;

+(BOOL)resetData;

@end
