//
//  QYABEnum.h
//  QYBaseProject
//
//  Created by 田 on 15/7/3.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  通讯录通用枚举类型
 */
#import <Foundation/Foundation.h>

/**
 *  选人控件打开方式
 */
typedef NS_ENUM(NSInteger, QYABPickerDisplayMode){
    //推出
    QYABPickerDisplayModePush = 0,
    //弹出
    QYABPickerDisplayModePresent = 1,
};
//搜索状态
typedef NS_ENUM(NSInteger, QYABPickerSearchStatus)
{
    QYABPickerSearchStatusNo = 0,
    QYABPickerSearchStatusYes = 1,
};
//通讯录类型
typedef NS_ENUM(NSUInteger, AddressBookType){
    //单位
    AddressBookTypeUnits = 0,
    //个人
    AddressBookTypePrivate = 1,
    //群组
    AddressBookTypeGroup = 2
};

//通讯录是否为乐工作使用
typedef NS_ENUM(NSInteger, AddressBookDetailType){
    //乐工作app
    AddressBookDetailTypeLgz = 0,
    //非乐工作app
    AddressBookDetailTypeOther
};


//选择人员类型
typedef NS_ENUM(NSInteger, QYABSelectType){
    //多选
    QYABSelectTypeMultiple = 0,
    //单选
    QYABSelectTypeSingle = 1,

};

//人员详情样式
typedef NS_ENUM(NSInteger, QYABUserDetailsContainBottomView){
    //不显示嘀一下、发消息
    QYABUserDetailsContainBottomViewNo = 0,
    //显示嘀一下、发消息
    QYABUserDetailsContainBottomViewYes = 1,
};

//QYABGroupModel,部门单位通讯录中的通讯录类型
typedef NS_ENUM(NSInteger, QYABUnitType)
{
    QYABUnitTypeUnit = 1,           //企业通讯录
    QYABUnitTypePublic = 2,         //公共通讯录
    QYABUnitTypePrivate = 3,        //私人通讯录
    QYABUnitTypePublicGroup = 4,    //公共群组
    QYABUnitTypePrivateGroup = 5    //个人群组
};

//QYABUserModel，人员单位通讯录中的通讯录类型
typedef NS_ENUM(NSInteger, QYABUserType)
{
    QYABUserTypeUnit = 0,       //企业通讯录
    QYABUserTypePrivate = 1,    //私人通讯录
    
};
//查看人员详情，滴滴跳转
typedef NS_ENUM(NSInteger, QYTheWayJump)
{
    QYJumpFromIM = 0,           //从IM跳入人员详情，进行滴滴跳转
    QYJumpFromAddressbook = 1,         //从通讯录进入单位人员详情，进行滴滴跳转
 };

typedef void(^QYABSelectComplete)(NSArray *users);

