//
//  QYAccount.h
//  QYBaseProject
//
//  Created by 田 on 15/6/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "JSONModel.h"
/*
@interface QYModuleRoleMap : JSONModel<NSCoding,NSCopying>

@property (assign, nonatomic) BOOL cOpen;

@property (assign, nonatomic) BOOL uOpen;

@property (assign, nonatomic) BOOL menu;

@property (strong, nonatomic) NSString* groups;
//uOpen,
//cOpen,
//groups,
//menu

@end


@interface QYUserRoleMap : JSONModel<NSCoding,NSCopying>
//@property( strong, nonatomic)NSDictionary *approve;
//@property( strong, nonatomic)NSDictionary *attendance;
//@property( strong, nonatomic)NSDictionary *businessmeeting;
//@property( strong, nonatomic)NSDictionary *exam;
//@property( strong, nonatomic)NSDictionary *meeting;
//@property( strong, nonatomic)NSDictionary *news;
//@property( strong, nonatomic)NSDictionary *notifyManger;
//@property( strong, nonatomic)NSDictionary *notifyView;
//@property( strong, nonatomic)NSDictionary *roleGroup;
//@property( strong, nonatomic)NSDictionary *salary;
//@property( strong, nonatomic)NSDictionary *sms;
//@property( strong, nonatomic)NSDictionary *tzt;
//@property( strong, nonatomic)NSDictionary *workflow;
//@property( strong, nonatomic)NSDictionary *ydzj;

@property( strong, nonatomic)QYModuleRoleMap *approve;
@property( strong, nonatomic)QYModuleRoleMap *attendance;
@property( strong, nonatomic)QYModuleRoleMap *businessmeeting;
@property( strong, nonatomic)QYModuleRoleMap *exam;
@property( strong, nonatomic)QYModuleRoleMap *meeting;
@property( strong, nonatomic)QYModuleRoleMap *news;
@property( strong, nonatomic)QYModuleRoleMap *notifyManger;
@property( strong, nonatomic)QYModuleRoleMap *notifyView;
@property( strong, nonatomic)QYModuleRoleMap *roleGroup;
@property( strong, nonatomic)QYModuleRoleMap *salary;
@property( strong, nonatomic)QYModuleRoleMap *sms;
@property( strong, nonatomic)QYModuleRoleMap *tzt;
@property( strong, nonatomic)QYModuleRoleMap *workflow;
@property( strong, nonatomic)QYModuleRoleMap *ydzj;
@end
*/


@interface QYAccount : JSONModel<NSCoding,NSCopying>
/**
 *  群组名
 */
@property (strong, nonatomic) NSString* groupName;
/**
 *  性别
 */
@property (assign, nonatomic) BOOL sex;
/**
 *  手机号
 */
@property (strong, nonatomic) NSString* phone;

/**
 *  总机号码
 */
@property (strong, nonatomic) NSString* companyPhone;

/**
 *  是否停机1、正常
 */
@property (assign, nonatomic) NSInteger regesiter;
/**
 *  口号
 */
@property (strong, nonatomic) NSString* slogan;
/**
 *  用户id
 */
@property (strong, nonatomic) NSString* userId;
/**
 *  v网段
 */
@property (strong, nonatomic) NSString* vgroup;
/**
 *  用户名
 */
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* role;
@property (strong, nonatomic) NSString* power;
@property (assign, nonatomic) BOOL clientCanLogin;
@property (assign, nonatomic) BOOL hangUpSms;
@property (strong, nonatomic) NSString* adminPhone;
@property (assign, nonatomic) BOOL isCompleted;
@property (strong, nonatomic) NSString* adminName;
@property (assign, nonatomic) NSInteger orderType;
@property (strong, nonatomic) NSString* signName;
@property (strong, nonatomic) NSString* job;
@property (strong, nonatomic) NSString* userAno;
@property (strong, nonatomic) NSString* companyName;
@property (strong, nonatomic) NSString* serviceInfo;
@property (strong, nonatomic) NSString* companyCode;
@property (strong, nonatomic) NSString* groupId;
@property (strong, nonatomic) NSString* adminId;
@property (strong, nonatomic) NSString* needCompleted;
/**
 *  公司logo
 */
@property (strong, nonatomic) NSString* companyLogo;
/**
 *  公司id
 */
@property (strong, nonatomic) NSString* companyId;
@property (strong, nonatomic) NSString* vnum;
//@property (assign, nonatomic) QYUserRoleMap *userRoleMap;
@end
//
//[userRoleMap]: {
//    approve =     {
//        cOpen = 0;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    attendance =     {
//        cOpen = 0;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    businessmeeting =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    exam =     {
//        cOpen = 0;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    meeting =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    news =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    notifyManger =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    notifyView =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    roleGroup =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    salary =     {
//        cOpen = 0;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    sms =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    tzt =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    workflow =     {
//        cOpen = 0;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//    ydzj =     {
//        cOpen = 1;
//        groups = "135872,108558,88596,155446,155447,155448,166903,134724,356898,273257,273256,273255,137239,88599,273244,273248,273249,191707,348270,356899,273252,273254,352978,357651";
//        menu = 1;
//        uOpen = 1;
//    };
//}
