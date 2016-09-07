//
//  QYDiDiRemindEnum.h
//  QYBaseProject
//
//  Created by lin on 16/1/14.
//  Copyright (c) 2016年 田. All rights reserved.
//

/**
 *  嘀嘀模块 枚举类型
 */

#ifndef QYBaseProject_QYDiDiRemindEnum_h
#define QYBaseProject_QYDiDiRemindEnum_h

/**
 *   发送嘀嘀提醒的类型
 */
typedef enum : NSUInteger {
    QYDiDiRemindTypeForSMSAndApp,           //短信和app内，默认
    QYDiDiRemindTypeForTelephoneAndApp,     //电话和app内
    QYDiDiRemindTypeForApp,                 //app内
} QYDiDiRemindType;

/**
 *   发送嘀嘀内容的类型
 */
typedef enum : NSUInteger {
    QYDiDiContentTypeForVoice           = 0,      //语音
    QYDiDiContentTypeForPhrase          = 1,      //短语，默认
    QYDiDiContentTypeForText            = 2,      //文本
} QYDiDiContentType;

/**
 *   接收到的嘀嘀，提醒方式
 */
typedef enum :  NSUInteger {
    QYDIDIConfirmApp                    = 0,          //@"已发送客户端App内提醒"
    QYDIDIConfirmText                   = 1,          //文本嘀嘀、电话提醒
    QYDIDIConfirmPhone                  = 4,          //语音嘀嘀、电话提醒
    QYDIDIConfirmMsg                    = 8           //@"已发送短信提醒"
} QYDIDIConfirm;

/**
 *   电话提醒的各个状态
 */
typedef enum :  NSUInteger {
    QYDIDIConfirmPrepareCall_1          = -1,   //准备拨通
    QYDIDIConfirmPrepareCall_0          = 0,    //
    QYDIDIConfirmCalling                = 1,    //振铃
    QYDIDIConfirmCalled_2               = 2,    //接通
    QYDIDIConfirmCalled_3               = 3,    //接通挂断
    QYDIDIConfirmNoCall_4               = 4,    //未接通
    QYDIDIConfirmNoCall_5               = 5,    //确认
    QYDIDIConfirmNoCall_6               = 6,    //没有通道
    QYDIDIConfirmNoCall_8               = 8,    //录音中
} QYDIDIConfirmPhoneState;

/**
 *  摇一摇的呼叫状态
 */
//0:开始呼叫 1：振铃 2：接通 3：接通后挂断 4：没有接通 5：确认 6：没有通道 8:录音中   服务端
//0:正在连线   2: 接听中  8:回复中  4:已挂断   5:已确认                          客户端
typedef NS_ENUM(NSInteger, QYDIDICallState) {
    QYDIDICallStateCalling              = 0,        //开始呼叫
    QYDIDICallStateRinging              = 1,        //振铃
    QYDIDICallStateAnswering            = 2,        //接通
    QYDIDICallStateHangUp               = 3,        //接通后挂断
    QYDIDICallStateBlockCall            = 4,        //没有接通
    QYDIDICallStateConfirmed            = 5,        //确认
    QYDIDICallStateNoRoad               = 6,        //没有通道
    QYDIDICallStateReplying             = 8         //录音中
};

#endif
