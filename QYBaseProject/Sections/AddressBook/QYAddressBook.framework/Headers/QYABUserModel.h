//
//  QYABUserModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/29.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  人员数据模型
 */
#import "JSONModel.h"
#import "QYABEnum.h"

@interface QYABUserModel : JSONModel
/**
 *  本地唯一id
 */
@property (nonatomic,strong) NSNumber <Optional> *id;
/**
 *  用户编号
 */
@property (nonatomic,strong) NSNumber <Optional> *userId;
/**
 *  部门名称
 */
@property (nonatomic,copy) NSString <Optional> *groupName;
/**
 *  部门id
 */
@property (nonatomic,strong) NSNumber <Optional> *groupId;
/**
 *  联系电话
 */
@property (nonatomic,copy) NSString <Optional> *phone;
/**
 *  v网号码
 */
@property (nonatomic,copy) NSString <Optional> *vNum;
/**
 *  用户姓名
 */
@property (nonatomic,copy) NSString <Optional> *userName;
/**
 *  性别 0女 1男
 */
@property (nonatomic,strong) NSNumber <Optional> *sex;
/**
 *  办公电话
 */
@property (nonatomic,copy) NSString <Optional> *telephone;
/**
 *  家庭电话
 */
@property (nonatomic,copy) NSString <Optional> *telephone2;
/**
 *  其他号码
 */
@property (nonatomic,copy) NSString <Optional> *phone2;
/**
 *  V网号码段
 */
@property (nonatomic,copy) NSString <Optional> *vgroup;
/**
 *  职务
 */
@property (nonatomic,copy) NSString <Optional> *job;
/**
 *  称呼
 */
@property (nonatomic,copy) NSString <Optional> *title;
/**
 *  邮箱
 */
@property (nonatomic,copy) NSString <Optional> *email;
/**
 *  拼音
 */
@property (nonatomic,copy) NSString <Optional> *userPY;
/**
 *  总机分机
 */
@property (nonatomic,copy) NSString <Optional> *userNum;
/**
 *  隐藏号码类型 1.对外公开，0.对内公开，2.仅管理员可见
 */
@property (nonatomic,strong) NSNumber <Optional> *userPower;
/**
 *  隐藏号码 1.隐藏。0.正常
 */
@property (nonatomic,strong) NSNumber <Optional> *userState;
/**
 *  签名
 */
@property (nonatomic,copy) NSString <Optional> *signName;
/**
 *  角色权限 0.只可看本部门的 1.可以查看所有部门人员
 */
@property (nonatomic,strong)  NSNumber <Optional> *role;
/**
 *  头像
 */
@property (nonatomic,copy) NSString <Optional> *photo;
/**
 *  排序
 */
@property (nonatomic,strong) NSNumber <Optional> *orderIndex;
/**
 *  1. 增加2. 修改3. 删除
 */
@property (nonatomic,strong) NSNumber <Optional> *action;
/**
 *  是不是虚拟人 0 不是 1是
 */
@property (nonatomic,strong)  NSNumber <Optional> *isVirtual;
/**
 *  虚拟人的真实对应id
 */
@property (nonatomic,strong)  NSNumber <Optional> *linkId;
/**
 *  是否有登录记录 0.未登录 1.有登录
 */
@property (nonatomic,strong)  NSNumber <Optional> *isLogined;
/**
 *  t9搜索组合
 */
@property (nonatomic,copy) NSString <Optional>*formattedNumber;
/**
 *  姓名全拼
 */
@property (nonatomic,copy) NSString <Optional>*fullPy;
/**
 *  个人通讯录索引,非服务器返回
 */
@property (nonatomic,copy) NSString <Optional> *sectionNumber;
/**
 *  QYABUserType，人员类型
 */
@property (nonatomic,strong) NSNumber <Optional> *userType;
/**
 *  是否选中
 */
@property(nonatomic,strong) NSNumber <Optional> *isSelected;
@end
