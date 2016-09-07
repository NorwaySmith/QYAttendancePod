//
//  QYRedDotHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYRedDotHelper.h"
#import "QYRDPushMonitoring.h"
#import "QYRedDotAPI.h"
#import "QYRedDotDB.h"
#import "QYRDMappingRelation.h"
#import "QYAccountService.h"

NSString *const kQYRedDotChangeNotification = @"redDotChangeNotification";

@interface QYRedDotHelper()

//红点映射关系
@property(nonatomic,strong)QYRDMappingRelation *mappingRelation;


@end

@implementation QYRedDotHelper

+ (QYRedDotHelper *)shared
{
    static dispatch_once_t pred;
    static QYRedDotHelper *sharedInstance = nil;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        //初始化红点存储
        self.mappingRelation = [[QYRDMappingRelation alloc] init];
        [self createDb];
        [self openPushMonitoring];
        [self allRedPointFromNetwork];
    }
    return self;
}

/**
 *  创建红点存储
 */
-(void)createDb
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    if(!account)
    {
        return;
    }
    [QYRedDotDB createTable];
    [_mappingRelation mappingRelation];
}

/**
 *  从网络获取所有红点
 */
-(void)allRedPointFromNetwork
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    if(!account)
    {
        return;
    }
    
    [QYRedDotAPI allRedPointSuccess:^(NSString *json)
    {
        [[QYRedDotStorage shared] storageFromNetwok:json];

        [self postLocalNotification];
    }
    failure:^(NSString *alert)
    {
        
    }];
}


/**
 *  打开红点推送监听
 */
-(void)openPushMonitoring
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    if(!account)
    {
        return;
    }
    [[QYRDPushMonitoring shared] openPushMonitoring];
}

-(QYRedDotModel *)redDotModelWithModuleCode:(NSString *)moduleCode
{
  return  [QYRedDotDB redDotModelWithModuleCode:moduleCode];
}

-(void)postLocalNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kQYRedDotChangeNotification object:nil];
}

/**
 *  某模块红点改变
 *
 *  @param changeNum  红点改变，+则红点数增加，－红点数减少
 *  @param moduleCode 模块标识
 *
 */
-(void)redDotChangeNum:(NSInteger)changeNum
            moduleCode:(NSString*)moduleCode
{
    QYRedDotModel *redDotModel = [QYRedDotDB redDotModelWithModuleCode:moduleCode];
    NSInteger redDot = redDotModel.redPointNum+changeNum;
    [QYRedDotDB storageRedPointNum:redDot moduleCode:moduleCode];
    [self postLocalNotification];
}

/**
 *  清除某个模块的红点
 *
 *  @param moduleCode 模块标识
 */
-(void)cleanRedDotAtModuleCode:(NSString*)moduleCode
{
    [QYRedDotDB storageRedPointNum:0 moduleCode:moduleCode];
}

/**
 *  重置红点数据
 */
-(void)resetData
{
    [QYRedDotDB resetData];
}


@end
