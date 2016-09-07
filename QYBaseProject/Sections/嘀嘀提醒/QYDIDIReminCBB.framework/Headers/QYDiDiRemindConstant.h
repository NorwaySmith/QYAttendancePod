//
//  QYDiDiRemindConstant.h
//  QYBaseProject
//
//  Created by lin on 16/1/14.
//  Copyright (c) 2016年 田. All rights reserved.
//

/**
 *  嘀嘀模块  通知、常量
 */

#ifndef QYBaseProject_QYDiDiRemindConstant_h
#define QYBaseProject_QYDiDiRemindConstant_h

#pragma mark - Notification
// 嘀嘀提醒发送成功后刷新列表
#define DiDi_reloadDataAfterNewDiDi         @"reloadDataAfterNewDiDi"
// 嘀嘀提醒删除的通知
#define DiDi_deleteDiDiModel                @"DiDi_deleteDiDiModel"
// 嘀嘀提醒得到新回复
#define DiDi_GetNewReplyNoticeForDIDI       @"GetNewReplyNoticeForDIDI"
// theRecordStop停止录音
#define DiDi_NewDiDiTheRecordStop           @"DiDi_NewDiDiTheRecordStop"

// 摇一摇通知
#define GotoDidiListNotification            @"GotoDidiListNotification"


#pragma mark - constString


#pragma mark - 配置
/**
 *  发送嘀嘀的最大人数
 */
#define kDiDiUserPickerMaximumCount         60



#import "QYDiDiRemindEnum.h"

#endif
