//
//  QYABPickerApi.h
//  QYBaseProject
//
//  Created by quanya on 15/11/30.
//  Copyright © 2015年 田. All rights reserved.
//

/**
 新选择人员接口
 */
#import <Foundation/Foundation.h>
#import "QYABProtocol.h"
#import "QYABUserModel.h"
#import "QYABEnum.h"
#import "QYABConstant.h"
@interface QYABPickerApi : NSObject

/**
 *  初始化单选人员
 *
 *  @param delegate         委托
 *  @param permitModules    授权模块
 *  @param isHidden         是否显示隐藏人员
 *  @param moduleName       模块名
 *  @return QYABPickerApi
 */
-(instancetype)initSinglePickerWithDelegate:(id<QYABProtocol>)delegate
                              permitModules:(NSArray*)permitModules
                         isShowHiddenPerson:(BOOL)isHidden
                                 moduleName:(const NSString *)moduleName;

/**
 *  初始化多选人员
 *
 *  @param delegate         委托
 *  @param permitModules    授权模块
 *  @param isHidden         是否显示隐藏人员
 *  @param maximumSelect    最大选择人数
 *  @param moduleName       模块名
 *  @return QYABPickerApi
 */
-(instancetype)initMultiPickerWithDelegate:(id<QYABProtocol>)delegate
                             permitModules:(NSArray*)permitModules
                        isShowHiddenPerson:(BOOL)isHidden
                             maximumSelect:(NSUInteger)maximumSelect
                                moduleName:(const NSString *)moduleName;

/**
 *  再次发起会议时初始化多选人员     2016-01-17----添加
 *
 *  @param delegate         委托
 *  @param permitModules    授权模块
 *  @param isHidden         是否显示隐藏人员
 *  @param maximumSelect    最大选择人数
 *  @param moduleName       模块名
 *  @param selectedTitleString 已选人页面标题
 *  @param addUserString       已选人页面添加人员提示文字
 *
 *  @return QYABPickerApi
 */
-(instancetype)initMultiPickerWithDelegate:(id<QYABProtocol>)delegate
                             permitModules:(NSArray*)permitModules
                        isShowHiddenPerson:(BOOL)isHidden
                             maximumSelect:(NSUInteger)maximumSelect
                                moduleName:(NSString *)moduleName
                       selectedTitleString:(NSString *)selectedTitleString
                             addUserString:(NSString *)addUserString;

/**
 *  设置已选人员集合
 *
 *  @param selectedUsers    已选择人员集合, QYABUserModel类型数组
 */
- (void)setSelectedUsers: (NSArray*)selectedUsers;

/**
 *  设置锁定人员集合，在选人控件中不可变
 *
 *  @param lockedUsers      锁定人员集合, QYABUserModel类型数组
 */
- (void)setLockedUsers: (NSArray *)lockedUsers;

/**
 *  设置锁定人员集合，在选人控件中不可变
 *
 *  @param lockedUsers      锁定人员集合, QYABUserModel类型数组
 */
- (void)setDefaultSelectedUsers: (NSArray *)defaultSelectedUsers;

/**
 *  设置选择人员后回调
 *
 *  @param completeCallback      回调函数
 */
- (void)setCompleteCallback:(QYABSelectComplete)completeCallback;

/**
 *  显示选人控件
 *
 *  @param mode      显示模式，分为push和present显示
 */
- (void)show:(QYABPickerDisplayMode)mode;
@end
