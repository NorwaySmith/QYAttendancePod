//
//  QYRedDotStorage.h
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//  红点存储

#import <Foundation/Foundation.h>

//问卷
static NSString *const QYRedDotStorageQuestion = @"questionUnDoneCount";
//公告审批，暂时无用
static NSString *const QYRedDotStorageApprove = @"notifyApproveCount";
//工作流审批
static NSString *const QYRedDotStorageWorkflow = @"workflowApproveCount";
//新闻
static NSString *const QYRedDotStorageNews = @"newsUnReadCount";
//公告
static NSString *const QYRedDotStorageNotify = @"notifyUnReadCount";

//未知
static NSString *const QYRedDotStorageUpdateStatus = @"updateStatus";
//嘀嘀回复
static NSString *const QYRedDotStorageDidiReply = @"didiReplyUnReadCount";
//嘀嘀未确认
static NSString *const QYRedDotStorageDidiUnConfirm = @"didiUnConfirmCount";
//工资未读
static NSString *const QYRedDotStorageSalary = @"salaryUnReadCount";
//开讲了未读
static NSString *const QYRedDotStorageSpeak = @"speakUnReadCount";

//本地定义
//IM消息
static NSString *const QYRedDotStorageMes = @"消息";
//嘀嘀
static NSString *const QYRedDotStorageDidi = @"嘀一下";
//工作
static NSString *const QYRedDotStorageWork = @"工作";
//乐工作
static NSString *const QYRedDotStorageLework = @"乐工作";



@interface QYRedDotStorage : NSObject


+ (QYRedDotStorage *)shared;
/**
 *  存储来自网络的json数据
 *
 *  @param json 来自网络的json数据
 *
 *  @return 是否存储成功
 */
-(BOOL)storageFromNetwok:(NSString*)json;
/**
 *  存储红点数到某模块
 *
 *  @param pointNum   红点数
 *  @param moduleCode 模块标识
 *
 *  @return 是否存储成功
 */
-(BOOL)storageRedPointNum:(NSInteger)pointNum
               moduleCode:(NSString*)moduleCode;


@end
