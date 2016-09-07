//
//  QYABGroupModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/29.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  部门数据模型
 */
#import "JSONModel.h"
#import "QYABEnum.h"

@interface QYABGroupModel : JSONModel
/**
 *  部门id
 */
@property (nonatomic,copy) NSNumber <Optional> *groupId;
/**
 *  上级部门
 */
@property (nonatomic,copy) NSNumber <Optional> *parentId;
/**
 *  部门名称
 */
@property (nonatomic,copy) NSString <Optional> *groupName;
/**
 *  创建人ID
 */
@property (nonatomic,copy) NSNumber <Optional> *createUserId;
/**
 *  QYABUnitType
 */
@property (nonatomic,strong) NSNumber <Optional> *unitType;
/**
 *  部门path 格式1,2,3
 */
@property (nonatomic,copy) NSString <Optional> *path;
/**
 *  层级等级
 */
@property (nonatomic,strong) NSNumber <Optional> *grade;
/**
 *  部门人数
 */
@property (nonatomic,strong) NSNumber <Optional> *groupUserNum;
/**
 *  排序
 */
@property (nonatomic,strong) NSNumber <Optional> *orderIndex;
/**
 *  本地唯一id
 */
@property (nonatomic,strong) NSNumber <Optional> *id;
/**
 *  用户列表
 */
@property (nonatomic,copy) NSString <Optional> *userIdstr;
/**
 *  群组选中状态 0 未选中,1 选中
 */
@property (nonatomic,strong) NSNumber <Optional> *selectType;

/**
 *  是否展开
 */
@property(nonatomic,strong) NSNumber <Optional> *isExpand;

/**
 *  是否有孩子
 */
@property(nonatomic,strong) NSNumber <Optional> *isSon;

@end

