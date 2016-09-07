//
//  IOSTool.h
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//
/*
 工具类
 
 
 __一、网络状态监测
 需求：1、得到当前网络状态。2、实时监测网络状态的改变。
 需研究：研究AFNetworkReachabilityManager是否可满足需求
 __二、验证电话邮箱是否正确
 需求：1、能够方便验证电话、邮箱是否合法。
 __三、各种样式提示
 需求：1、能够方便弹出各种样式的提示。2、能够将UIAlertView的协议方法用block实现，方便调用
 参考：easy iOS中的dialog
 ---四、时间格式化
 需求：1、能够快速格式化各种时间
 参考：easy iOS、TimeTool
 __五、得到设备信息
 需求：1、能够快速得到系统版本 。 2、得到当前设备。
 __六、快速得到沙盒路径
 需求：1、快速得到Document路径   2、快速得到tmp路径
 参考：easy iOS
 七、程序中常用的字体和颜色
 需求：1、和设计沟通统一程序中常用颜色  2、和设计沟通统一程序中常用字体。方便程序维护
 __八、检测设备存储容量
 需求：1、能够方便读取设备剩余存储空间。
 __九、SysTool系统工具
 需求：1、发邮件  2、打电话  3、发短信   4、打开url     6、获取某个文件大小
 参考：easy iOS中的SysTool
 --十、字符串处理
 需求：1、非空判断。2、计算字符串大小
 */
#import <UIKit/UIKit.h>
#import "QYSysTool.h"
#import "QYDeviceInfo.h"
#import "QYNetworkInfo.h"
#import "QYVerifiTool.h"
#import "QYTimeTool.h"
#import "QYDialogTool.h"
#import "NSString+ToolExtend.h"
#import "UIImage+ToolExtend.h"
#import "QYSandboxPath.h"
#import "QYDevicePermission.h"

#ifndef IOSToolDemo_IOSTool_h
#define IOSToolDemo_IOSTool_h


#endif
