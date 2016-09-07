//
//  QYMapHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/26.
//  Copyright (c) 2015年 田. All rights reserved.
//  开启百度地图

#import <Foundation/Foundation.h>

@interface QYMapHelper : NSObject


+ (QYMapHelper *)shared;

- (void)configBaiduMap:(NSString*)key;


@end
