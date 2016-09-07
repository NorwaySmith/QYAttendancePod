//
//  QYAttendanceViewController.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@interface QYAttendanceListViewController : QYViewController

//当前personLocation
@property (nonatomic, strong)CLLocation *personLocation;

@end
