//
//  QYABUnitListViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/6/29.
//  Copyright (c) 2015年 田. All rights reserved.
/**
 *   通讯录主页面
 */
#import "QYViewController.h"
#import "QYABConstant.h"


@interface QYABViewController : QYViewController
/**
 *  通讯录代理
 */
@property(weak,nonatomic)id <QYABProtocol>delegate;
/**
 *  应用的名字，是否为乐工作
 */
@property(assign,nonatomic) AddressBookDetailType addressBookDetailType;
/**
 *  初始化通讯录
 *
 *  @param showItems 初始化通讯录类型NSNumber类型的 AddressBookType
 *
 *  @return
 */
-(instancetype)initWithShowItems:(NSArray *)showItems;

@end
