//
//  QYInitData.h
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYInitData : NSObject
+ (QYInitData *)shared;
/**
 *  初始化rootViewController。如果默认账户为空，则初始化登录，否则初始化tabbar
 */
-(void)initData;
@end
