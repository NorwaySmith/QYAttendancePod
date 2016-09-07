//
//  QYMapHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/26.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMapHelper.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface QYMapHelper()

@property (nonatomic,strong)BMKMapManager *mapManager;

@end

@implementation QYMapHelper

+ (QYMapHelper *)shared
{
    static dispatch_once_t pred;
    static QYMapHelper *sharedInstance = nil;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)configBaiduMap:(NSString*)key
{
    //初始化百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:key generalDelegate:nil];
    if (!ret) {
        //NSLog(@"manager start failed!");
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

}
- (void)applicationWillResignActive:(UIApplication *)application{
    [BMKMapView willBackGround];
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [BMKMapView didForeGround];
}
@end
