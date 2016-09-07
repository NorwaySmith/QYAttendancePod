//
//  QYIMProtocol.h
//  QYBaseProject
//
//  Created by lin on 16/1/6.
//  Copyright (c) 2016年 田. All rights reserved.
//

/**
 *  IM模块的协议
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//
//#import <QYAddressBook/QYABUserModel.h>

@class QYABUserModel;
@class QYIMChatUserModel;

@protocol QYIMProtocol <NSObject>

/**
 *  将要选择人员
 *
 *  @param presentViewController presentViewController 选择人员需要弹出在这个控制器上
 *  @param alreadySelectUsers    userArray 选择的人员QYChatUser
 *  @param userBlock
 */
- (void)shouldPresentViewController:(id)presentViewController alreadySelectUser:(NSArray *)alreadySelectUsers selectUser:(void (^)(NSArray *userArray))userBlock;

/**
 *  根据userId得到QYChatUser
 *
 *  @param userId userId 用户id
 *
 *  @return 人员实体类
 */
- (QYIMChatUserModel *)userWithUserId:(NSString *)userId;

/**
 *  根据userId集合得到QYChatUser数组
 *
 *  @param userIds 用户id集合，以逗号分开
 *
 *  @return User集合
 */
- (NSMutableArray *)usersWithUserIds:(NSString*)userIds;

/**
 *  企业内刊、分享号、新闻中心
 */
- (void)goToNew;

/**
 *  <#Description#>
 *
 *  @param userModel User
 */
- (void)gotoDIDIFromIMWithUserModel:(QYABUserModel *)userModel;

/**
 *  根据模块类型返回模块信息(分享号专用)
 *
 *  @param moduleType 模块类型
 *  @param moduleInfo 模块信息
 */
- (void)moduleInfoWithModuleTypeIsNEWS:(NSString *)moduleType moduleInfo:(void (^)(NSDictionary *moduleInfo))moduleInfo;

@end
