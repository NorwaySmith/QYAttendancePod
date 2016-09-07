//
//  QYABDb.h
//  QYBaseProject
//
//  Created by 田 on 15/6/29.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  通讯录数据库操作
 */
#import <Foundation/Foundation.h>
#import "QYABGroupModel.h"
#import "QYABUserModel.h"

static NSString *const GroupTableName = @"group_list";
static NSString *const UserTableName = @"user_list";

/**
 *  每页显示条数
 */
static NSInteger userPageSize = 50;

/**
 * 在滚到倒数第几个开始加载下一页数据
 */
static NSInteger startLoadNextPageOfNum = 10;


@interface QYABDb : NSObject
/**
 *  数据库存放路径
 *
 *  @return 数据库存放路径
 */
+(NSString *)dbPath;

/**
 *  执行多条sql语句
 *
 *  @param sqls sqls数组
 */
+(void)execSqls:(NSArray *)sqls;

/**
 *  公司部门
 *
 *  @param parentId 父部门groupId
 *
 *  @return
 */
+(NSMutableArray *)unitGroupWithParentId:(NSNumber *)parentId;

/**
 *  获取所有部门
 *
 *  @return
 */
+(NSMutableArray *)getAllUnitGroups;

/**
 *  群组部门
 *
 *  @param parentId 父部门groupId
 *
 *  @return
 */
+(NSMutableArray *)groupGroupWithParentId:(NSNumber *)parentId;

/**
 *  数据更新时间
 *
 *  @return 时间
 */
+(NSString *)updateTime;



/**
 *  查询通讯录中一个部门及子部门下所有用户
 *
 *  @param groupId   groupId 部门id
 *  @param page      page    页
 *  @param showHider 是否显示隐藏人员
 *
 *  @return 人员列表
 */
+(NSMutableArray *)userWithGroupId:(NSNumber *)groupId page:(NSInteger)page showHider:(BOOL)showHider;

/**
 *  查询通讯录中一个部门及子部门下有限个用户
 *
 *  @param groupId   groupId 部门id
 *  @param showHider 是否显示隐藏人员
 *
 *  @return 人员列表
 */
+(NSMutableArray *)userWithGroupId:(NSNumber *)groupId
                          limitNum:(NSInteger)limitNum
                         showHider:(BOOL)showHider;

/**
 *  得到当前群组部门下的所有人员
 *
 *  @param groupId 部门id
 *
 *  @return 是否全选
 */
+(NSMutableArray *)getAllUsersInGroupWithGroupId:(NSNumber *)groupId
                                       showHider:(BOOL)showHider;

/**
 *  查询所有数据库人员
 *
 *  @return 所有人员数组
 */
+(NSMutableArray *)allUsers;

/**
 *  根据号码匹配人，拨号使用
 *
 *  @param phone 手机号码、phone、phone2等
 *
 *  @return 人员数组
 */
+(NSMutableArray *)userWithPhone:(NSString *)phone;

/**
 *  删除数据库
 *
 *  @return 是否成功
 */
+(BOOL)removeDb;

/**
 *  根据groupId，查询group
 *
 *  @param groupId 部门id
 *
 *  @return QYABGroupModel数组
 */
+(NSMutableArray *)groupWithGroupId:(NSNumber *)groupId;

#pragma mark - 查询群组
/**
 *  查询群组通讯录中所有用户
 *
 *  @param UserIdstr 用户列表集合逗号分割
 *  @param page    页
 *
 *  @return 人员列表
 */
+(NSMutableArray *)groupUserWithUserIdstr:(NSString *)userIdstr page:(NSInteger)page;

/**
 *  查询群组通讯录中所有用户
 *
 *  @param UserIdstr 用户列表集合逗号分割
 *
 *  @return 人员列表
 */
+(NSMutableArray *)groupUserWithUserIdstr:(NSString *)userIdstr;

//群组管理
/**
 *  私人群组
 *
 *  @return
 */
+(NSMutableArray *)privateGroup;

/**
 *  新建群组
 *
 *  @param groupModel 群组实体类
 *
 */
+(BOOL)creatPrivateGroup:(QYABGroupModel *)groupModel;


/**
 *  根据groupId修改群组名
 *
 *  @param groupName 要修改为群组名
 *  @param groupId   要修改的群组id
 *
 *  @return 是否成功
 */
+(BOOL)updateGroupName:(NSString *)groupName groupId:(NSString *)groupId;

/**
 *  删除群组，用groupId
 *
 *  @param groupId 群组id
 *
 *  @return 是否成功
 */
+(BOOL)removeGroupWithGroupId:(NSString *)groupId;

/**
 *  根据groupId修改群组成员
 *
 *  @param userIdStr 群组成员逗号分割
 *  @param groupId   要修改的群组id
 *
 *  @return 是否成功
 */
+(BOOL)updateUserIdstr:(NSString *)userIdstr groupId:(NSString *)groupId;

/**
 *  根据userId查询人员
 *
 *  @param userId 人员id
 *
 *  @return 人员对象
 */
+(QYABUserModel *)userWithUserId:(NSString *)userId;


/**
 *  根据userIds查询人员
 *
 *  @param userIds userId列表，以逗号分割
 *
 *  @return QYABUserModel数组
 */
+(NSMutableArray *)usersWithUserIds:(NSString *)userIds;

#pragma mark - 人员搜索
//////////////////////人员搜索/////////////////////////////
/**
 *  根据关键字查询人员，显示前10个
 *
 *  @param keyword 关键字
 *
 *  @return 人员列表
 */
+(NSMutableArray *)userWithKeyword:(NSString *)keyword;
/**
 *  根据关键字查询单位部门
 *
 *  @param keyword 关键字
 *
 *  @return 人员列表
 */
+(NSMutableArray *)groupWithKeyword:(NSString *)keyword;
/**
 *  查询当前部门路径
 *
 *  @param groupIds groupId逗号分割
 *
 *  @return 部门数组
 */
+(NSMutableArray *)groupWithGroupIds:(NSString *)groupIds;



#pragma mark - 选择人员
  ///////////////////////////////选择人员///////////////////////////////////////

/**
 *  当前用户是否为选中状态
 *
 *  @param userId 用户Id
 *
 *  @return 是否选中
 */
+(BOOL)isSelectWithUserId:(NSNumber *)userId;
/**
 *  选中用户
 *
 *  @param userId 用户Id
 *
 *  @return 是否操作成功
 */
+(BOOL)selectUserWithUserId:(NSNumber *)userId;

/**
 *  取消选中用户
 *
 *  @param userId 用户Id
 *
 *  @return 是否操作成功
 */
+(BOOL)cancelSelectUserWithUserId:(NSNumber *)userId;

/**
 *  选中的所有人
 *
 *  @return 选中的所有人
 */
+(NSMutableArray*)selectUsersisSelectHidden:(BOOL)isSelectHidden;

/**
 *  重置选择人员
 *
 *  @return 是否重置成功
 */
+(BOOL)resetSelect;

/**
 *  选中的所有人数
 *
 *  @return 选中的所有人
 */
+(NSInteger)selectUserNum;

#pragma mark - 单位通讯录全选
///////////////////////////////单位通讯录全选///////////////////////////////////////

/**
 *  选中一个部门
 *
 *  @param groupId 部门Id
 *
 *  @param isSelectHidden 是否选择隐藏人员
 *
 *  @return 是否操作成功
 */
+(BOOL)selectUserWithGroupId:(NSNumber *)groupId isSelectHidden:(BOOL)isSelectHidden;

/**
 *  取消选中一个部门
 *
 *  @param groupId 部门Id
 *
 *  @return 是否操作成功
 */
+(BOOL)cancelSelectUserWithGroupId:(NSNumber *)groupId;

/**
 *  当前部门是否为全选
 *
 *  @param groupId 部门id
 *
 *  @param isSelectHidden 是否选择隐藏人员
 *
 *  @return 是否全选
 */
+(BOOL)isAllSelectUserWithGroupId:(NSNumber *)groupId isHidden:(BOOL)isSelectHidden;

#pragma mark - 群组全选

///////////////////////////////群组全选///////////////////////////////////////
/**
 *  选中群组部门下所有人
 *
 *  @param groupId 部门id
 *
 *  @return 是否成功
 */
+(BOOL)selectGroupUserWithUserIdstr:(NSString *)userIdstr;

/**
 *  取消选中群组部门下所有人
 *
 *  @param groupId 部门id
 *
 *  @return 是否成功
 */
+(BOOL)cancelSelectGroupUserWithUserIdstr:(NSString *)userIdstr;

/**
 *  当前群组部门下是否为全选
 *
 *  @param groupId 部门id
 *
 *  @return 是否全选
 */
+(BOOL)isAllSelectGroupUserWithUserIdstr:(NSString *)userIdstr;

#pragma mark - 个人中心

///////////////////////////////个人中心///////////////////////////////////////

/**
 *  更新自己的头像
 *
 *  @param photo 头像地址
 *
 *  @return 是否操作成功
 */
+(BOOL)updateSelfPhoto:(NSString *)photo;

/**
 *  更新自己性别
 *
 *  @param sex 性别 0女 1男
 *
 *  @return 是否操作成功
 */
+(BOOL)updateSelfSex:(BOOL)sex;

/**
 *  更新自己的签名
 *
 *  @param sign 签名
 *
 *  @return 是否操作成功
 */
+(BOOL)updateSelfSign:(NSString *)sign;

#pragma mark - V网


/**
 *   在本V网群组中查询所有V网人员
 *
 *  @param vgroup v网群组
 *
 *  @return 人员列表
 */
+(NSMutableArray *)vUsersWithVgroup:(NSString *)vgroup;

/**
 *  根据关键字搜索v网群组人员1
 *
 *  @param keyword 关键字
 *  @param vgroup  v网群组
 *
 *  @return 人员列表
 */
+(NSMutableArray *)searchVUsersWithKeyword:(NSString *)keyword
                                  atVgroup:(NSString *)vgroup;

/**
 *  根据模块创建联系人使用频率表
 *
 *  @param module 模块名
 *
 *  @return 是否成功
 */
+ (BOOL)createFrequencyTableForModule:(NSString *)module;

/**
 *  更新某模块人员使用频率表
 *
 *  @param module 模块名
 *  @param users  要更新的人员对象
 *
 *  @return 是否成功
 */
+ (BOOL)updateFrequencyTableForModule:(NSString *)module
                                users:(NSArray *)users;

/**
 *  获得可能联系人
 *
 *  @param module         模块名
 *  @param limit          获取前几个
 *  @param isContainUnit  是否包含单位通讯录
 *  @param isContainLocal 是否包含个人通讯录
 *
 *  @return QYABUserModel
 */
+ (NSMutableArray *)getTopOfUserForModule:(NSString *)module
                                    limit:(NSInteger)limit
                            isContainUnit:(BOOL)isContainUnit
                           isContainLocal:(BOOL)isContainLocal;


/**
 *  根据关键字搜索单位通讯录人员
 *
 *  @param keyword 关键字
 *
 *  @return QYABUserModel数组
 */
+ (NSMutableArray *)pickerSearchUsersWithKeyword:(NSString *)keyword;

@end
