//
//  QYDevicePermission.m
//  QYBaseProject
//
//  Created by lin on 16/2/1.
//  Copyright (c) 2016年 田. All rights reserved.
//

#import "QYDevicePermission.h"
#import <AVFoundation/AVAudioSession.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

@interface QYDevicePermission () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager                     *locationManager;
@property (nonatomic, copy) DidUpdateLocationServiceStatus          locationCallBack;
@property (nonatomic, copy) DidUpdatePhotoServiceStatus             photoCallBack;
@property (nonatomic, copy) DidUpdateCameraServiceStatus            cameraCallBack;
@end

@implementation QYDevicePermission

+ (QYDevicePermission *)shared{
    static dispatch_once_t pred;
    static QYDevicePermission *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

/**
 *  录音权限的判断
 */
+ (void)systemRecordingServiceCallBack:(void (^)(BOOL))callBack {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                callBack(YES);
            } else {
                callBack(NO);
            }
        }];
    }
}

+ (BOOL)systemRecordingService {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                return YES;
            } else {
                [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在iPhone的“设置-隐私-麦克风”选项中，允许乐工作访问你的手机麦克风。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return NO;
            }
        }];
    }
    return YES;
}

/**
 *  定位权限的判断
 */
static CLLocationManager *locationManager;
- (void)systemLocationServiceCallBack:(DidUpdateLocationServiceStatus)callBack {
    self.locationCallBack = callBack;
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        //定位功能可用，开始定位
        _locationCallBack(YES);
    }else if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)){
        // 定位功能不可用，提示用户或忽略
        _locationCallBack(NO);
    }else if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        if(!locationManager){
        locationManager = [[CLLocationManager alloc] init];
        }
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
    }
}
// [[[UIAlertView alloc] initWithTitle:LocationServiceAlertTitle message:LocationServiceAlertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
/**
 *  通讯录权限的判断
 */
- (void)systemLocationAddressBookServiceCallBack:(DidUpdateLocationAddressBookServiceStatus)callBack {
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        //授权成功
        callBack(YES);
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            callBack(granted);
        });
        //释放book
        CFRelease(book);
    }else{
        [[[UIAlertView alloc] initWithTitle:@"无法使用通讯录" message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许乐工作访问你的通讯录。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        callBack(YES);
    }
}

/**
 *  相机权限的判断
 */
- (void)systemCameraServiceCallBack:(DidUpdateCameraServiceStatus)callBack {
    self.cameraCallBack = callBack;
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized) {
        self.cameraCallBack(YES);
    }else if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            self.cameraCallBack(granted);
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的“设置-隐私-相机”选项中，允许乐工作访问你的相机。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

/**
 *  照片权限的判断
 */
- (void)systemPhotoServiceCallBack:(DidUpdatePhotoServiceStatus)callBack {
    self.photoCallBack = callBack;
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
        self.photoCallBack(YES);
    }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined){
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                self.photoCallBack(YES);
            }
        } failureBlock:^(NSError *error) {
            self.photoCallBack(NO);
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"无法使用相片" message:@"请在iPhone的“设置-隐私-相片”选项中，允许乐工作访问你的相片。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

/**
 *  蓝牙权限的判断
 */
+ (BOOL)systemBluetoothService {
    if ([CBPeripheralManager authorizationStatus] == CBPeripheralManagerAuthorizationStatusAuthorized) {
        return YES;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"无法使用蓝牙" message:@"请在iPhone的“设置-隐私-蓝牙”选项中，允许乐工作访问你的蓝牙。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return NO;
    }
    
    return YES;
}

/**
 *  日历（提醒事件）权限的判断
 *
 *  @param entityType 类型
 */
+ (BOOL)systemCalendarServiceForEntityType:(EKEntityType)entityType {
    if (entityType == EKEntityTypeEvent) {
        //日历
        if ([EKEventStore authorizationStatusForEntityType:entityType] == EKAuthorizationStatusAuthorized) {
            return YES;
        }else{
            [[[UIAlertView alloc] initWithTitle:@"无法使用日历" message:@"请在iPhone的“设置-隐私-日历”选项中，允许乐工作访问你的日历。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return NO;
        }
    }else{
        //提醒事件
        if ([EKEventStore authorizationStatusForEntityType:entityType] == EKAuthorizationStatusAuthorized) {
            return YES;
        }else{
            [[[UIAlertView alloc] initWithTitle:@"无法使用提醒事件" message:@"请在iPhone的“设置-隐私-提醒事件”选项中，允许乐工作访问你的提醒事件。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return NO;
        }
    }
    return YES;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _locationCallBack(YES);
    }
}

@end
