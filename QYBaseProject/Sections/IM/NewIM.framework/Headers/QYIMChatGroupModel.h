//
//  QYIMChatGroupModel.h
//  QYBaseProject
//
//  Created by lin on 15/8/26.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  IM群组对象
 */

#import "JSONModel.h"

@interface QYIMChatGroupModel : JSONModel
/**
 *  群组的Id
 */
@property (nonatomic, strong) NSNumber <Optional> *chatId;
/**
 *  成员列表，逗号分割
 */
@property (nonatomic, copy) NSString <Optional> *userIds;
/**
 *  群组名
 */
@property (nonatomic, copy) NSString <Optional> *name;
/**
 *  最新消息内容
 */
@property (nonatomic, strong) NSString <Optional> *lastMsg;
/**
 *  最后一条消息的时间
 */
@property (nonatomic, strong) NSString <Optional> *lastTime;
/**
 *  排序字段
 */
@property (nonatomic, copy) NSString <Optional> *sortTime;
/**
 *  最新消息状态，QYMessageSendState
 */
@property (nonatomic, strong) NSNumber <Optional> *lastMsgSendStatue;
/**
 *  是否置顶
 */
@property (nonatomic, strong) NSNumber <Optional> *top;
/**
 *  是否消息提醒
 */
@property (nonatomic, strong) NSNumber <Optional> *remind;
/**
 *  消息未读数
 */
@property (nonatomic, strong) NSNumber <Optional> *unReadNum;
/**
 *  标为未读
 */
@property (nonatomic, strong) NSNumber <Optional> *markUnread;
/**
 *  群组类型，QYChatGroupType
 */
@property (nonatomic, strong) NSNumber <Optional> *chatGroupType;
/**
 *  单聊对方的userId
 */
@property (nonatomic, strong) NSNumber <Optional> *anotherUserId;
/**
 *  是否管理员
 */
@property (nonatomic, strong) NSNumber <Optional> *admin;
/**
 *  此群组是否删除
 */
@property (nonatomic, strong) NSNumber <Optional> *isDelete;
/**
 *  是否存在群组中
 */
@property (nonatomic, strong) NSNumber <Optional> *notInGroup;
/**
 *  群组名称是否是默认名称
 */
@property (nonatomic, strong) NSNumber <Optional> *isDefaultName;


//@property (nonatomic, copy) NSNumber <Optional> *chatId;         //群组的Id
////@property (nonatomic, copy) NSNumber *chatType;       //消息类型,弃用，群组类型用chatGroupType
//@property (nonatomic, copy) NSString <Optional> *isAdmin;        //是否为管理员（群主）
//@property (nonatomic, copy) NSString <Optional> *photo;          //群组头像
//@property (nonatomic, copy) NSNumber <Optional> *unreadNum;      //未读消息数
//@property (nonatomic, copy) NSString <Optional> *name;           //群组名称
//@property (nonatomic, copy) NSString <Optional> *theLastTime;    //最后一条数据时间
//@property (nonatomic, copy) NSString <Optional> *theLastContent; //最后一条消息内容
//@property (nonatomic, copy) NSString <Optional> *theLastState;   //最后一条消息状态
//@property (nonatomic, copy) NSString <Optional> *isMessageRemind;
//@property (nonatomic, copy) NSString <Optional> *isTop;          //是否置顶
//@property (nonatomic, copy) NSString <Optional> *chatCreateTime; //创建表的时间
//@property (nonatomic, copy) NSString <Optional> *isDelete;       //是否删除（假删除）
//@property (nonatomic, copy) NSString <Optional> *isCanSee;       //新消息提醒
//
@property (nonatomic, strong) NSArray <Optional> *userArray;        //群组内成员数组
//
//@property (nonatomic, copy) NSNumber <Optional> *chatGroupType;     //群组类型
//@property (nonatomic, copy) NSNumber <Optional> *anotherUser;       // 单聊 对方Id

@end
