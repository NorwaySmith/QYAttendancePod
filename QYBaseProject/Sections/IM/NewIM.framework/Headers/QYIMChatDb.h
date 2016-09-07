//
//  QYIMChatDb.h
//  QYBaseProject
//
//  Created by 田 on 15/8/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  IM chatGroup表的DB处理
 */

#import "QYIMBasicDb.h"
#import "QYIMConstant.h"

@class QYIMChatGroupModel;

@interface QYIMChatDb : QYIMBasicDb
+ (QYIMChatDb *)shared;

- (BOOL)createTable;

/**
 *  更新chat中时间
 *
 *  @param theLastTime 时间
 *  @param chatId      聊天id
 */
- (void)updateLastTime:(NSString *)theLastTime chatId:(NSNumber *)chatId;

/**
 *  更新chat的排序时间
 *
 *  @param theSortTime 时间
 *  @param chatId      聊天id
 */
- (void)updateSortTime:(NSString *)theSortTime chatId:(NSNumber *)chatId;

/**
 *  更新chatId
 *
 *  @param newChatId 新的chatId
 *  @param chatId    老chatId
 */
- (void)updateNewChatId:(NSNumber *)newChatId chatId:(NSNumber *)chatId;

/**
 *  得到所有未隐藏的聊天群组
 *
 *  @return 群组数组
 */
- (NSMutableArray *)allNotHiddenChatGroup;


/**
 *  得到所有已隐藏、未隐藏的聊天群组
 *
 *  @return 群组数组
 */
- (NSMutableArray *)allChatGroup;

/**
 *  得到最新n个未隐藏的聊天群组（不包括单聊、单位管理员和企业内刊）
 *
 *  @param number 最新的数量限制
 *  @return 最新的n个群组
 */
- (NSMutableArray *)getNewestChatGroupWithLimitNumber:(NSInteger)number;

/**
 *  是否存在会话群组
 *
 *  @return 是否存在
 */
- (BOOL)isExistChatGroup;

/**
 *  新建群聊
 *
 *  @param chatId      群聊id
 *  @param time       群组创建时间
 *  @param userIdArray 群聊成员
 */
- (void)newChatWithChatId:(NSNumber *)chatId
                     time:(NSString *)time
              userIdArray:(NSArray*)userIdArray
                     name:(NSString*)name;

/**
 *  是否置顶
 */
- (void)updateIsTop:(BOOL)isTop
             chatId:(NSNumber *)chatId;

/**
 *  删除群组，非真删除，更改isDelete
 */
- (void)updateIsDeleteWithChatId:(NSNumber *)chatId;

/**
 *  根据chatId获取群组对象
 *
 *  @return 群组对象
 */
- (QYIMChatGroupModel *)getGroupModelWithChatId:(NSNumber *)chatId;


/**
 *  修改群组名称
 *
 *  @param chatId    群组chatId
 *  @param groupName 群组名称
 */
- (void)updateGroupNameWithChatId:(NSNumber *)chatId
                        groupName:(NSString *)groupName
                    isDefaultName:(NSNumber *)isDefaultName;

/**
 *  删除群组，真删除
 */
- (void)deleteGroupWithChatId:(NSNumber *)chatId;

/**
 *  是否接受新消息提醒
 *
 *  @param chatId   群组chatId
 *  @param isCanSee YES NO
 */
- (void)updateIsCanSeeWithChatId:(NSNumber *)chatId
                        isCanSee:(int)isCanSee;

/**
 *  删除消息时更新lastMsg字段
 *
 *  @param chatId      群组chatId
 *  @param lastMsg     内容
 *  @param theLastTime 时间
 *  @param sendState    上条消息的发送状态
 */
- (void)updateLastMsgForDeleteWithChatId:(NSNumber *)chatId
                                 lastMsg:(NSString *)lastMsg
                                lastTime:(NSString *)theLastTime
                               sendState:(QYMessageSendState)sendState;

/**
 *  添加或修改消息时更新lastMsg字段
 *
 *  @param chatId      群组chatId
 *  @param lastMsg     内容
 *  @param theLastTime 时间
 *  @param chatType    消息的类别，操作消息及普通消息
 */
- (void)updateLastMsgWithChatId:(NSNumber *)chatId
                        lastMsg:(NSString *)lastMsg
                       lastTime:(NSString *)theLastTime
                       chatType:(QYChatType)chatType;

/**
 *  更新lastMsgSendStatus
 *
 *  @param chatId            群组chatId
 *  @param lastMsgSendStatue 发送状态
 */
- (void)updateLastMsgWithChatId:(NSNumber *)chatId
              lastMsgSendStatue:(QYMessageSendState)lastMsgSendStatue;

/**
 *  更新群组头像字段
 *
 *  @param chatId  群组chatId
 *  @param userIds userIds
 */
- (void)updateUserIdsWithChatId:(NSNumber *)chatId
                        userIds:(NSString *)userIds;

/**
 *  得到未读数
 */
- (NSInteger)getAllGroupUnreadNum;


////////************** 单聊 ***************////////////

/**
 *  新建单聊
 *
 *  @param userId      用户Id
 *  @param userName    用户名
 *  @param theLastTime 时间
 */
- (void)newSingleChatWithAnotherUserId:(NSNumber *)userId
                              userName:(NSString *)userName
                           theLastTime:(NSString *)theLastTime;
/**
 *  判断单聊数组
 *
 *  @param userId 用户Id
 *
 *  @return 数组
 */
- (NSMutableArray *)isSingleChatExistWithAnotherUserId:(NSNumber *)userId;

/**
 *  更改状态、是否显示单聊
 *
 *  @param userId   用户Id
 *  @param isDelete isDelete
 */
- (void)updateSingleChatIsDeleteWithAnotherUserId:(NSNumber *)userId
                                         isDelete:(NSNumber *)isDelete;


@end
