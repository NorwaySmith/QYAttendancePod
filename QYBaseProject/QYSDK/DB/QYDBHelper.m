//
//  QYDBHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/23.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYDBHelper.h"
#import "IOSTool.h"

@implementation QYDBHelper

+ (QYDBHelper *)shared
{
    static dispatch_once_t pred;
    static QYDBHelper *sharedInstance = nil;
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(BOOL)execSql:(NSString *)sql dbPath:(NSString *)dbPath
{
    NSAssert(![sql isNil], @"Error ：sql不能为空");
    NSAssert(![dbPath isNil], @"Error ：dbPath不能为空");

    __block BOOL isSucess = NO;
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [dbQueue inDatabase:^(FMDatabase *db)
    {
        NSError *error = nil;
        BOOL isSql = [db validateSQL:sql error:&error];
        if (!isSql)
        {
            NSString *errorTip = [NSString stringWithFormat:@"Error: %@不是正确的sql语句 ",sql];
            //NSLog(@"%@",errorTip);
        }
        isSucess = [db executeUpdate:sql] ;
    }];
    return isSucess;
}

/**
 *  插入一条语句，并返回id
 *
 *  @param sql    sql语句
 *  @param dbPath 数据库路径
 *
 *  @return id
 */
-(long long int)insertSql:(NSString*)sql dbPath:(NSString *)dbPath
{
    NSAssert(![sql isNil], @"Error ：sql不能为空");
    NSAssert(![dbPath isNil], @"Error ：dbPath不能为空");
    
    __block BOOL isSucess = NO;
    __block long long int lastInsertRowId = 0;
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [dbQueue inDatabase:^(FMDatabase *db)
    {
        NSError *error = nil;
        BOOL isSql = [db validateSQL:sql error:&error];
        if (!isSql)
        {
            NSString *errorTip = [NSString stringWithFormat:@"Error: %@不是正确的sql语句 ",sql];
            //NSLog(@"%@",errorTip);
        }
        isSucess = [db executeUpdate:sql] ;
        lastInsertRowId = [db lastInsertRowId];
    }];
    return lastInsertRowId;
}

-(BOOL)execSqls:(NSArray *)sqls dbPath:(NSString *)dbPath
{
    NSAssert(![dbPath isNil], @"Error ：dbPath不能为空");
    __block BOOL isSucess = NO;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        for (NSString *sql in sqls)
        {
            NSError *error = nil;
           BOOL isSql = [db validateSQL:sql error:&error];
            if (!isSql)
            {
                NSString *errorTip = [NSString stringWithFormat:@"Error: %@不是正确的sql语句 ",sql];
                //NSLog(@"%@",errorTip);
            }
            isSucess = [db executeUpdate:sql];
        }
    }];
    return isSucess;
}

-(NSArray *)searchSql:(NSString *)sql dbPath:(NSString*)dbPath
{
    NSAssert(![sql isNil], @"Error ：sql不能为空");
    NSAssert(![dbPath isNil], @"Error ：dbPath不能为空");
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [queue inDatabase:^(FMDatabase *db)
    {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
        {
            [resultArray addObject:rs.resultDictionary];
        }
    }];
    return resultArray;
}

/**
 *  查询数据
 *
 *  @param sqls     sql数组
 *  @param dbPath 数据库路径
 *
 *  @return 数据字典
 */
-(NSArray *)searchSqls:(NSArray *)sqls dbPath:(NSString *)dbPath
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        for (NSString *sql in sqls)
        {
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next])
            {
                [resultArray addObject:rs.resultDictionary];
            }
        }
    }];
    return resultArray;
}

- (BOOL)tableExists:(NSString *)tableName dbPath:(NSString*)dbPath
{
    NSAssert(![tableName isNil], @"Error ：tableName不能为空");
    NSAssert(![dbPath isNil], @"Error ：dbPath不能为空");
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    return [db tableExists:tableName];
}


@end
