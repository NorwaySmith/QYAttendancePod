//
//  QYIMListViewModel.h
//  QYBaseProject
//
//  Created by lin on 15/9/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  聊天列表的ViewModel
 */

#import <Foundation/Foundation.h>

@protocol QYIMListViewModelDelegate <NSObject>

/**
 *  创建群组成功，跳转到群组命名
 *
 *  @param chatId 群组Id
 */
- (void)createGroupChatSuccessWithChatId:(NSNumber *)chatId;

/**
 *  创建单聊成功，跳转到聊天会话
 *
 *  @param chatId 单聊的chatId，对方的userId
 */
- (void)createSingleChatSuccessWithChatId:(NSNumber *)chatId;

@end


@interface QYIMListViewModel : NSObject

@property (assign) id<QYIMListViewModelDelegate> delegate;

/**
 *  新建群组会话
 */
-(void)newChatWithUserArray:(NSArray*)userArray;

@end
