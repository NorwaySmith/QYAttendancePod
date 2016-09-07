//
//  QYRedDotDB.m
//  QYBaseProject
//
//  Created by 田 on 15/12/4.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYRedDotDB.h"
#import "IOSTool.h"
#import "QYDBHelper.h"

@implementation QYRedDotDB

+(NSString *)dbPath
{
    return  [[QYSandboxPath documentPath] stringByAppendingString:@"/redDot.db"];
}
+(void)createTable
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE RedDotTable (id integer primary key autoincrement, moduleCode    VCHAR(200), type    INT default 0,parentCode    VCHAR(200),redPointNum INT default 0)"];
    [[QYDBHelper shared] execSql:sql dbPath:[self dbPath]];

}
+(void)execSqls:(NSArray *)sqls
{
    [[QYDBHelper shared] execSqls:sqls dbPath:[self dbPath]];
}
+(void)storageRedPointNum:(NSInteger)pointNum
               moduleCode:(NSString*)moduleCode
{
    NSString *sql = [NSString stringWithFormat:@"update RedDotTable set redPointNum=%ld where moduleCode='%@'",(long)pointNum,moduleCode];
   [[QYDBHelper shared] execSql:sql dbPath:[self dbPath]];
}

+(QYRedDotModel *)redDotModelWithModuleCode:(NSString *)moduleCode
{
    NSString *sql = [NSString stringWithFormat:@"select *from RedDotTable where moduleCode='%@' ",moduleCode];
    NSArray *array = [[QYDBHelper shared] searchSql:sql dbPath:[self dbPath]];
    if ([array count] > 0)
    {
        NSDictionary *dic = array[0];
        QYRedDotModel *redDotModel = [[QYRedDotModel alloc] init];
        redDotModel.type = [dic[@"type"] integerValue];
        redDotModel.moduleCode = dic[@"moduleCode"];
        redDotModel.parentCode = dic[@"parentCode"];
        
        if (redDotModel.type == QYRedPointTypeNumbers)
        {
            NSInteger totalNum = [self redPointNumWithParentCode:redDotModel.moduleCode
                                                 initRedPointNum:[dic[@"redPointNum"] integerValue]];
            
            redDotModel.redPointNum = totalNum;
        }
        else
        {
            redDotModel.redPointNum=[dic[@"redPointNum"] integerValue];
        }
    
        return redDotModel;
    }
    return nil;
}
/**
 *  递归从本地读取所有子项的未读数
 *
 *  @param parentCode      父模块标识
 *  @param initRedPointNum 初始未读数
 *
 *  @return 未读数
 */
+(NSInteger)redPointNumWithParentCode:(NSString *)parentCode
                      initRedPointNum:(NSInteger)initRedPointNum
{
    NSString *sql = [NSString stringWithFormat:@"select *from RedDotTable where parentCode='%@' ",parentCode];
    NSArray *array = [[QYDBHelper shared] searchSql:sql dbPath:[self dbPath]];
    NSInteger totalNum = initRedPointNum;
    for (NSDictionary *dic in array)
    {
        NSInteger redPointNum = 0;

        if (![dic[@"redPointNum"] isKindOfClass:[NSNull class]])
        {
            redPointNum = [dic[@"redPointNum"] integerValue];
        }
        
        NSString *moduleCode = dic[@"moduleCode"];
        
        if([dic[@"type"] integerValue] == QYRedPointTypeNumbers)
        {
            totalNum =[self redPointNumWithParentCode:moduleCode
                                      initRedPointNum:redPointNum]+totalNum;
        }
    }
    
    return totalNum;
}


+(BOOL)resetData
{
    NSString *sql=[NSString stringWithFormat:@"update RedDotTable set redPointNum=0"];
   return  [[QYDBHelper shared] execSql:sql dbPath:[self dbPath]];

}


@end
