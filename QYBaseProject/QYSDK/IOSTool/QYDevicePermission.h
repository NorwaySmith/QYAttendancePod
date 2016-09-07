//
//  QYDevicePermission.h
//  QYBaseProject
//
//  Created by lin on 16/2/1.
//  Copyright (c) 2016年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

static NSString *RecordingServiceAlertTitle   = @"无法录音";
static NSString *RecordingServiceAlertMessage = @"请在iPhone的“设置-隐私-麦克风”选项中，允许乐工作访问你的手机麦克风。";

static NSString *LocationServiceAlertTitle   = @"无法获取位置";
static NSString *LocationServiceAlertMessage = @"请在iPhone的“设置-隐私-定位服务”中打开定位服务，允许乐工作使用定位服务。";

typedef void (^DidUpdateLocationServiceStatus)(BOOL granted);
typedef void (^DidUpdatePhotoServiceStatus)(BOOL granted);
typedef void (^DidUpdateCameraServiceStatus)(BOOL granted);
typedef void (^DidUpdateLocationAddressBookServiceStatus)(BOOL granted);

@interface QYDevicePermission : NSObject
+ (QYDevicePermission *)shared;

/**
 *  录音权限的判断
 */
+ (void)systemRecordingServiceCallBack:(void (^)(BOOL granted))callBack;
+ (BOOL)systemRecordingService;
/**
 *  定位权限的判断
 */
- (void)systemLocationServiceCallBack:(DidUpdateLocationServiceStatus)callBack;

/**
 *  通讯录权限的判断
 */
- (void)systemLocationAddressBookServiceCallBack:(DidUpdateLocationAddressBookServiceStatus)callBack;

/**
 *  相机权限的判断
 */
- (void)systemCameraServiceCallBack:(DidUpdateCameraServiceStatus)callBack;

/**
 *  照片权限的判断
 */
- (void)systemPhotoServiceCallBack:(DidUpdatePhotoServiceStatus)callBack;

/**
 *  蓝牙权限的判断
 */
+ (BOOL)systemBluetoothService;

/**
 *  日历（提醒事件）权限的判断
 *
 *  @param entityType 类型
 */
+ (BOOL)systemCalendarServiceForEntityType:(EKEntityType)entityType;

@end
