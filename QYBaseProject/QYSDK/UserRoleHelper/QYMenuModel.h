//
//  QYMenuModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "JSONModel.h"
@protocol QYMenuModel @end
@interface QYMenuModel : JSONModel
/**
 *  模块id
 */
@property(nonatomic,copy)NSString *moduleId;
/**
 *  子模块
 */
@property(nonatomic,strong)NSArray<QYMenuModel,Optional>*childModile;
/**
 *  排序
 */
@property(nonatomic,assign)NSInteger order;
/**
 *  个人权限
 */
@property(nonatomic,assign)BOOL uOpen;
/**
 *  模块名
 */
@property(nonatomic,copy)NSString *moduleName;
/**
 *  公司权限
 */
@property(nonatomic,assign)BOOL cOpen;
@property(nonatomic,assign)BOOL menu;
@property(nonatomic,copy)NSString *groups;

@end
