//
//  QYIMChatUserModel.h
//  QYBaseProject
//
//  Created by lin on 15/8/26.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  IM人员对象
 */

#import "JSONModel.h"

@interface QYIMChatUserModel : JSONModel

@property (nonatomic, strong) NSNumber <Optional> *TableVer;

@property (nonatomic, strong) NSNumber <Optional> *userId;    // 人员ID
@property (nonatomic, strong) NSNumber <Optional> *chatId;    // 所在聊天群组id
@property (nonatomic, copy) NSString <Optional> *isDelete;  // 是否被删除

@property (nonatomic, copy) NSString <Optional> *userName;  // 人员名字
@property (nonatomic, copy) NSString <Optional> *photo;     // 人员头像地址
@property (nonatomic, copy) NSString <Optional> *job;       // 人员称位
@property (nonatomic, copy) NSString <Optional> *email;     // 人员邮箱
@property (nonatomic, copy) NSString <Optional> *phone;     // 电话号码
@property (nonatomic, strong) NSNumber <Optional> *sex;       // 性别
@property (nonatomic, copy) NSString <Optional> *isAdmin;   // 是否管理员
@property (nonatomic, strong) NSNumber <Optional>*isLogined;     // 是否登录过

@end
