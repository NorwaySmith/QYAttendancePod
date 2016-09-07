//
//  QYIMEnum.h
//  QYBaseProject
//
//  Created by lin on 16/1/6.
//  Copyright (c) 2016年 田. All rights reserved.
//

/**
 *  IM模块的枚举类型
 */

#ifndef QYBaseProject_QYIMEnum_h
#define QYBaseProject_QYIMEnum_h

//群组类型
typedef NS_ENUM(NSInteger, QYChatGroupType)
{
    QYChatGroupTypeTXZL       = 0,        //通讯助理群组（系统群组）
    QYChatGroupTypeCustom     = 1,        //自定义群组，自己创建的群组
    QYChatGroupTypeUnit       = 2,        //固定群组，单位讨论组、部门讨论组
    QYChatGroupTypeTemporary  = 3,        //临时群组(栏目群组)
    QYChatGroupTypeManage     = 4,        //单位管理员
    QYChatGroupTypeSingle     = 5,        //单聊
    QYChatGroupTypeLgz        = 6         //乐工作团队

};

//消息类型（服务器返回消息）
typedef NS_ENUM (NSInteger, QYChatType)
{
    QYChatTypeCommonMessage      = 0,        //普通消息
    QYChatTypeOperationMessage   = 1         //操作消息
};

//发送状态
typedef NS_ENUM (NSInteger, QYMessageSendState) {
    QYMessageSendStateDone      = 0,             //完成
    QYMessageSendStateIng       = 1,             //发送中
    QYMessageSendStateFaild     = 2,             //发送失败
};

//语音的播放状态
typedef NS_ENUM (NSInteger, QYVoiceBubbleState) {
    QYVoiceBubbleStateStop    = 0,             //语音静止状态
    QYVoiceBubbleStatePlaying = 1              //语音播放状态
};

//消息类型（本地消息）
typedef NS_ENUM (NSInteger, QYBubbleMessageType) {
    QYBubbleMessageStyleOutgoing  = 0,         //发送的消息
    QYBubbleMessageStyleIncoming  = 1,         //接收的消息
    QYBubbleMessageStyleOperation = 2          //操作消息
};

//inputView的输入类型
typedef NS_ENUM(NSUInteger, QYTextViewInputViewType) {
    QYTextViewNormalInputType = 0,
    QYTextViewTextInputType,
    QYTextViewFaceInputType,
    QYTextViewShareMenuInputType,
};

#endif
