//
//  QYDBHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/23.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface QYDBHelper : NSObject

+ (QYDBHelper *)shared;
/**
 *  执行一条sql语句
 *
 *  @param sql    sql语句
 *  @param dbPath 数据库路径
 */
-(BOOL)execSql:(NSString *)sql dbPath:(NSString *)dbPath;

/**
 *  插入一条语句，并返回id
 *
 *  @param sql    sql语句
 *  @param dbPath 数据库路径
 *
 *  @return id
 */
-(long long int)insertSql:(NSString *)sql dbPath:(NSString *)dbPath;

/**
 *  执行多条sql语句，使用事务提升性能
 *
 *  @param sql    sql语句
 *  @param dbPath 数据库路径
 */
-(BOOL)execSqls:(NSArray *)sqls dbPath:(NSString *)dbPath;

/**
 *  查询数据
 *
 *  @param sql     sql语句
 *  @param dbPath 数据库路径
 *
 *  @return 数据字典
 */
-(NSArray *)searchSql:(NSString *)sql dbPath:(NSString *)dbPath;

/**
 *  查询数据
 *
 *  @param sqls     sql数组
 *  @param dbPath 数据库路径
 *
 *  @return 数据字典
 */
-(NSArray *)searchSqls:(NSArray *)sqls dbPath:(NSString *)dbPath;

/**
 *  数据库表是否从在
 *
 *  @param tableName 表名
 *  @param dbPath    数据库路径
 *
 *  @return 是否存在
 */
- (BOOL)tableExists:(NSString *)tableName dbPath:(NSString *)dbPath;


@end
