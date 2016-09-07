//
//  QYAccount.h
//  QYBaseProject
//
//  Created by 田 on 15/6/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "JSONModel.h"


@interface QYAccount : JSONModel<NSCoding,NSCopying>
/**
 *  群组名
 */
@property (strong, nonatomic) NSString<Optional> *groupName;
/**
 *  性别
 */
@property (assign, nonatomic) BOOL sex;
/**
 *  手机号
 */
@property (strong, nonatomic) NSString<Optional> *phone;

/**
 *  总机号码
 */
@property (strong, nonatomic) NSString<Optional> *companyPhone;

/**
 *  是否停机1、正常
 */
@property (assign, nonatomic) NSInteger regesiter;
/**
 *  口号
 */
@property (strong, nonatomic) NSString<Optional> *slogan;
/**
 *  用户id
 */
@property (strong, nonatomic) NSString<Optional> *userId;
/**
 *  v网段
 */
@property (strong, nonatomic) NSString<Optional> *vgroup;
/**
 *  用户名
 */
@property (strong, nonatomic) NSString<Optional> *userName;
@property (strong, nonatomic) NSString <Optional> *role;
@property (strong, nonatomic) NSString <Optional>*power;    //权限
@property (assign, nonatomic) BOOL clientCanLogin;
@property (assign, nonatomic) BOOL hangUpSms;
@property (strong, nonatomic) NSString<Optional> *adminPhone;
@property (assign, nonatomic) BOOL isCompleted;
@property (strong, nonatomic) NSString<Optional> *adminName;
@property (assign, nonatomic) NSInteger orderType;
/**
 *  个性签名
 */
@property (strong, nonatomic) NSString<Optional> *signName;
@property (strong, nonatomic) NSString<Optional> *job;
@property (strong, nonatomic) NSString<Optional> *userAno;
@property (strong, nonatomic) NSString<Optional> *companyName;
@property (strong, nonatomic) NSString<Optional> *serviceInfo;
@property (strong, nonatomic) NSString<Optional> *companyCode;
@property (strong, nonatomic) NSString<Optional> *groupId;
@property (strong, nonatomic) NSString<Optional> *adminId;
@property (strong, nonatomic) NSString<Optional> *needCompleted;
/**
 *  公司logo
 */
@property (strong, nonatomic) NSString<Optional> *companyLogo;
/**
 *  公司id
 */
@property (strong, nonatomic) NSString<Optional> *companyId;
/**
 *  V网号
 */
@property (strong, nonatomic) NSString<Optional> *vnum;
/**
 *  密码
 */
@property (strong, nonatomic) NSString<Optional> *password;

/**
 *  @author 杨峰, 16-04-13 09:04:21
 *
 *  工作模块的权限
 */
@property (nonatomic, strong) NSDictionary<Optional> *userRoleMap;

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
