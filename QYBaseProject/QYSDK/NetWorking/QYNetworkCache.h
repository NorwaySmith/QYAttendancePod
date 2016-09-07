//
//  QYNetworkCache.h
//  QYBaseProject
//
//  Created by 田 on 16/5/4.
//  Copyright © 2016年 田. All rights reserved.
//  网络缓存管理类

#import <Foundation/Foundation.h>

@interface QYNetworkCache : NSCache
+ (QYNetworkCache *)shared;

/**
 *  根据key获取缓存数据
 *
 *  @param key key
 *
 *  @return 缓存对象
 */
- (id)cachedObjectForKey:(NSString *)key;

/**
 *  根据key存储缓存对象
 *
 *  @param object 缓存对象
 *  @param key    key
 */
- (void)cacheObject:(id)object forKey:(NSString *)key;
@end
