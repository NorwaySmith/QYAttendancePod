//
//  QYIMConstant.h
//  QYBaseProject
//
//  Created by lin on 16/1/6.
//  Copyright (c) 2016年 田. All rights reserved.
//

/**
 *  IM模块的固定常量及通知
 */

#ifndef QYBaseProject_QYIMConstant_h
#define QYBaseProject_QYIMConstant_h

#pragma mark - Notification

// 接收新消息，刷新界面
#define IM_ReceiveNewMessageRefreshUI                   @"IM_ReceiveNewMessageRefreshUI"

// 清空聊天记录
#define IM_CleanMessageRefreshIMChatVC                  @"IM_CleanMessageRefreshIMChatVC"

// 消息发送成功
#define IM_SendMsgHelperSendSucessNotification          @"IM_SendMsgHelperSendSucessNotification"

// 消息发送失败
#define IM_SendMsgHelperSendFaildNotification           @"IM_SendMsgHelperSendFaildNotification"

// 重新发送消息的通知
#define IM_SendMsgHelperResendNotification              @"IM_SendMsgHelperResendNotification"

// 图片等消息发送进度
#define IM_SendMsgHelperUploadProgressNotification      @"IM_SendMsgHelperUploadProgressNotification"

// 发送位置消息通知
#define IM_SendPositionMessage                         @"IM_SendPositionMessage"

// 群组初始化成功
#define IM_IMInitGroupSuccess                           @"com.quanya.IMInitGroupDone"

// 群组初始化失败
#define IM_IMInitGroupFaild                             @"com.quanya.IMInitGroupFaild"

// 转发消息的通知
#define IM_TransmitMessageModel                         @"IM_TransmitMessageModel"


#pragma mark - constString
//IM应用的Id   正式服务器为9，测试服务器为10
static NSInteger IMAppId = 9;


//operationType   操作消息的类型
//同步群组
static NSString * const ChatSynchChatGroup              = @"synchChatGroup";
//同步群组名称
static NSString * const ChatSynchChatGroupName          = @"synchChatGroupName";
//同步群组管理员
static NSString * const ChatSynchChatGroupManager       = @"synchManager";
//添加人员
static NSString * const ChatSynchAddUsers               = @"synchAddUsers";
//移除人员
static NSString * const ChatSynchRemoveUsers            = @"synchRemoveUsers";
//移除群组
static NSString * const ChatSynchDeleteChatGroup        = @"synchDeleteChatGroup";


//新消息提醒
//开
static NSString * const ChatPushStateOpen               = @"open";
//关
static NSString * const ChatPushStateClose              = @"close";


//消息的类型
//文字
static NSString * const MessageText                     = @"TEXT";
//图片
static NSString * const MessagePhoto                    = @"IMG";
//语音
static NSString * const MessageVoice                    = @"VOICE";
//位置
static NSString * const MessagePosition                 = @"POSITION";
//文件
static NSString * const MessageFile                     = @"FILE";
//视频
static NSString * const MessageVideo                    = @"VIDEO";
//URL缩略图
static NSString * const MessageURL                      = @"URL";


//特殊的群组Id
//新闻
static NSString * const NEWS                            = @"news";
static NSInteger NEWSID                                 = 1;
//通知公告
static NSString * const NOTIFY                          = @"notify";
static NSInteger NOTIFYID                               = 2;
//通讯助理
static NSString * const COMMUNICATION                   = @"COMMUNICATION";
static NSInteger COMMUNICATIONID                        = 3;
//单位管理员
static NSString * const UNITADMIN                       = @"UNITADMIN";
static NSInteger UNITADMINID                            = 4;
//乐工作团队
static NSString * const LGZTeam                         = @"乐工作团队";
static NSInteger LGZTeamID                              = 5;

#pragma mark - 初始化配置信息
// 列表显示的最大消息数量
#define IMList_MaxMessageNum                            99
// 录音的时间
#define IMChat_TimeoutVoiceDuration                     50
// 录音倒数的时间
#define IMChat_TimeoutWarningDuration                   10
// 会话中消息每次加载消息的条数
#define IMChat_loadingMaxMessageNum                     10
/**
 *  IM聊天群组最大人数
 */
#define kIMGroupUserPickerMaximumCount                  200

#import "QYIMEnum.h"

#endif
