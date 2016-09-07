//
//  QYInitUI.h
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  初始化rootViewController、初始化应用数据
 */
#import <Foundation/Foundation.h>

@interface QYInitUI : NSObject
/**
 *  获取QYInitUI单例对象
 *
 *  @return QYInitUI单例对象
 */
+ (QYInitUI *)shared;

/**
 *  初始化rootViewController。如果默认账户为空，则初始化登录，否则初始化tabbar
 *
 *  @param launchOptions 入口类中启动配置
 */
- (void)initUI:(NSDictionary *)launchOptions;

/**
 *  设置别名和tag
 *
 *  @param isTextServer 是否测试服务器
 */
-(void)setTagsAndAlias:(BOOL)isTextServer;


@end
