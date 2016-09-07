//
//  QYAttendanceManagerSettingModel.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/14.
//  Copyright © 2016年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface QYAttendanceManagerSettingModel : NSObject

@property (nonatomic, strong)NSMutableArray *leftDataArray;
@property (nonatomic, strong)NSMutableArray *rightDataArray;
@property (nonatomic, assign) CLLocationCoordinate2D                adminSelectCoordinate;

@end
