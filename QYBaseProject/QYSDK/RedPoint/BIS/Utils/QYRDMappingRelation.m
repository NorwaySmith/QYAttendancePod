//
//  QYRDMappingRelation.m
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYRDMappingRelation.h"
#import "QYRedDotDB.h"

@implementation QYRDMappingRelation

-(void)mappingRelation
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QYRDMappingRelation" ofType:@"plist"];
    NSArray *mappingArray = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *sqlArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in mappingArray)
    {
        if (![QYRedDotDB redDotModelWithModuleCode:dic[@"moduleCode"]])
        {
            NSString *sql = [NSString stringWithFormat:@"insert into RedDotTable (moduleCode,type,parentCode) values ('%@','%@','%@') ",dic[@"moduleCode"],dic[@"type"],dic[@"parentCode"]];
            [sqlArray addObject:sql];
        }
    }
    [QYRedDotDB execSqls:sqlArray];
}


@end
