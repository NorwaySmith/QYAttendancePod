//
//  QYCallNumberDb.h
//  QYBaseProject
//
//  Created by lin on 15/6/29.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYCallNumberDb : NSObject

/**
 *  创建数据库的表
 *
 *  @return <#return value description#>
 */
+ (void)createDatabaseTable;

/**
 *  查询call表数据
 *
 *  @return 数组
 */
+ (NSMutableArray *)getCallTableData;

/**
 *  条件查询call表数据
 *
 *  @return return value description
 */
+ (NSMutableArray *)getCallTableDataWithPhone:(NSString *)phone;

/**
 *  按条件更新call表数据
 *
 *  @return <#return value description#>
 */
+ (BOOL)updateCallTableDataWithPhone:(NSString *)phone WithTime:(NSString *)time;

/**
 *  在call表中插入一条数据
 *
 *  @return <#return value description#>
 */
+ (BOOL)insertCallTableDataWithPhone:(NSString *)phone WithuId:(int)uId WithTime:(NSString *)time;

/**
 *  在callHistory表中插入一条数据
 *
 *  @param phone <#phone description#>
 *  @param uId   <#uId description#>
 *  @param cId   <#cId description#>
 *  @param time  <#time description#>
 */
+ (BOOL)insertCallHistoryTableDataWithPhone:(NSString *)phone WithuId:(int)uId WithcId:(int)cId WithTime:(NSString *)time;

/**
 *  条件查询call历史表数据
 *
 *  @return 历史记录数组
 */
+ (NSMutableArray *)getCallHistoryTableDataAsCallHestoryEntityWithPhone:(NSString *)phone;

/**
 *  删除 Call表的一条数据
 */
+ (void)deleteCallTableWithUid:(NSString *)uId;

/**
 *  删除 CallHistory表的一条数据
 */
+ (void)deleteCallHistoryWithPhone:(NSString *)phone Phone2:(NSString *)phone2 telePhone:(NSString *)telePhone telePhone2:(NSString *)telePhone2;
@end
