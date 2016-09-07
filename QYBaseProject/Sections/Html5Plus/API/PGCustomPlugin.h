//
//  PluginTest.m
//  HBuilder-Hello
//
//  Created by zhaotengfei on 15/9/24.
//  Copyright (c) 2015年 田. All rights reserved.//

// h5+native接口实现

#include "PGPlugin.h"
#include "PGMethod.h"
#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

@protocol PGPluginDelegate <NSObject>

@optional
-(void)selectPerson;

@end

@interface PGCustomPlugin : PGPlugin<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong) id <PGPluginDelegate> pgDelegate;

@property (nonatomic,strong) BMKLocationService *locService;

@property (nonatomic,assign) BOOL isSearchNearSuccess;   //是不是搜索成功  用于控制表中是否选择图片的显示

@property (nonatomic,strong) BMKGeoCodeSearch *codeSearch;
//地图定位的cbid
@property (nonatomic,copy) NSString* locationCbId;


//+(PGPluginTest*)shareInstance;

/**
 *  调用选择人员
 *
 *  @param commands
 */
- (void)selectUsers:(PGMethod *)commands;

/**
 *  测调用选择部门
 *
 *  @param commands
 */
- (void)selectGroup:(PGMethod *)commands;

/**
 *  测调用选择时间
 *
 *  @param commands
 */
- (void)selectDateTime:(PGMethod *)commands;

/**
 *  测调用选择日期,半天
 *  此方法与selectDateTime 实现一致，时间格式不同
 *
 *  @param commands
 */
- (void)showDateTimeHalf:(PGMethod *)commands;

/**
 *  获取用户信息_登陆
 *
 *  @param commands
 */
- (NSData *)getLoginUserInfo:(PGMethod *)commands;

/**
 *  接口配置化
 *
 *  @param commands
 */
- (NSData *)getBaseUrlPath:(PGMethod *)commands;

/**
 *  退出html5，最外层返回按钮
 *
 *  @param commands
 */
- (NSData *)goBackDesk:(PGMethod *)commands;

/**
 *  H5 Runtime ready
 *
 *  @param commands
 */
- (NSData *)appReady:(PGMethod *)commands;

/**
 *  H5 控制台输出
 *
 *  @param commands
 */
- (NSData *)log:(PGMethod *)commands;

/**
 *  获取位置信息
 *
 *  @param commands
 */
- (void)localMessage:(PGMethod *)commands;

/**
 *  关闭定位，需要手动关闭
 *
 *  @param commands
 */
- (void)stopUserLocationService:(PGMethod *)commands;

/**
 *  拍照
 *
 *  @param commands
 */
- (void)takePhoto:(PGMethod *)commands;

/**
 *  关闭键盘
 *
 *  @param commands
 */
- (void)closeKeyboard:(PGMethod *)commands;
/**
 *  显示等待框
 *
 *  @param commands text
 */
- (void)showWaiting:(PGMethod *)commands;
/**
 *  关闭等待框
 *
 *  @param commands
 */
- (void)closeWaiting:(PGMethod *)commands;

@end
