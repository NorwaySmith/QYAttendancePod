//
//  QYABLocalPhoneHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/7/1.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  本地通讯录操作
 */
#import <Foundation/Foundation.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "QYABConstant.h"

@class QYABUserModel;
@interface QYABLocalPhoneHelper : NSObject

@property (nonatomic) ABAddressBookRef addressBook;
/**
 *  已分组数据
 */
@property (nonatomic,strong) NSMutableArray *localArray;
+ (QYABLocalPhoneHelper *)shared;

/**
 *  加载本地通讯录
 *
 *  @param complete 完成回调
 */
-(void)loadAddressBookComplete:(void (^)(NSArray *addressBookArray))complete;

/**
 *  根据id得到本地人员对象
 *
 *  @param recordID id
 *
 *  @return 本地人员对象
 */
-(ABRecordRef)getPersonWithRecordID:(int32_t)recordID;
/**
 *  模糊查询手机通讯录人员
 *
 *  @param keyword 关键字
 *
 *  @return 人员数组
 */
-(NSArray *)userWithKeyword:(NSString *)keyword;
/**
 *  根据recorId查询头像
 *
 *  @param recordID 人员id
 *
 *  @return 头像image
 */
-(UIImage *)photoWithRecordID:(int32_t)recordID;
/**
 *  根据id查姓名
 *
 *  @param recordID id
 *
 *  @return 姓名
 */
-(NSString *)userNameWithRecordID:(int32_t)recordID;
/**
 *  添加联系人到通讯录
 *
 *  @param userModel 联系人数据
 */
-(void)addToContact:(QYABUserModel *)userModel withViewController:(UINavigationController *)viewController;

/**
 *  添加到现有联系人
 *
 *  @param userModel 联系人数据
 */
-(void)refreshToContct:(QYABUserModel *)userModel withViewController:(UINavigationController *)viewController;

/**
 *  根据用户标识集合获取所有本地通讯录用户
 *
 *  @param ids 用户标识集合
 */
-(NSArray *)getUsersWithIds:(NSArray *)ids;
@end
