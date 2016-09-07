//
//  QYRedDotStorage.m
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYRedDotStorage.h"
#import "QYRedDotDB.h"
@interface QYRedDotStorage()
@end
@implementation QYRedDotStorage
+ (QYRedDotStorage *)shared
{
    static dispatch_once_t pred;
    static QYRedDotStorage *sharedInstance = nil;
    
    dispatch_once(&pred, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    if (self) {

    }
    return self;
}
/**
 *  存储来自网络的json数据
 *
 *  @param json 来自网络的json数据
 *
 *  @return 是否存储成功
 */
-(BOOL)storageFromNetwok:(NSString *)json
{
    if (!json)
    {
        return NO;
    }
    NSError *error = nil;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    NSInteger questionUnDoneCount = [dic[QYRedDotStorageQuestion] integerValue];
    [self storageRedPointNum:questionUnDoneCount moduleCode:QYRedDotStorageQuestion];

    NSInteger workflowApproveCount = [dic[QYRedDotStorageWorkflow] integerValue];
    [self storageRedPointNum:workflowApproveCount moduleCode:QYRedDotStorageWorkflow];

    NSInteger newsUnReadCount = [dic[QYRedDotStorageNews] integerValue];
    [self storageRedPointNum:newsUnReadCount moduleCode:QYRedDotStorageNews];

    NSInteger notifyUnReadCount = [dic[QYRedDotStorageNotify] integerValue];
    [self storageRedPointNum:notifyUnReadCount moduleCode:QYRedDotStorageNotify];

    NSInteger updateStatus = [dic[QYRedDotStorageUpdateStatus] integerValue];
    [self storageRedPointNum:updateStatus moduleCode:QYRedDotStorageUpdateStatus];

    NSInteger didiReplyUnReadCount = [dic[QYRedDotStorageDidiReply] integerValue];
    [self storageRedPointNum:didiReplyUnReadCount moduleCode:QYRedDotStorageDidiReply];

    NSInteger didiUnConfirmCount = [dic[QYRedDotStorageDidiUnConfirm] integerValue];
    [self storageRedPointNum:didiUnConfirmCount moduleCode:QYRedDotStorageDidiUnConfirm];

    NSInteger salaryUnReadCount = [dic[QYRedDotStorageSalary] integerValue];
    [self storageRedPointNum:salaryUnReadCount moduleCode:QYRedDotStorageSalary];

    NSInteger speakUnReadCount = [dic[QYRedDotStorageSpeak] integerValue];
    [self storageRedPointNum:speakUnReadCount moduleCode:QYRedDotStorageSpeak];
    
    return YES;
}
/**
  *  存储红点数到某模块
  *
  *  @param pointNum   红点数
  *  @param moduleCode 模块标识
  *
  *  @return 是否存储成功
  */
-(BOOL)storageRedPointNum:(NSInteger)pointNum
               moduleCode:(NSString*)moduleCode
{
    [QYRedDotDB storageRedPointNum:pointNum moduleCode:moduleCode];
    return YES;
}


@end

