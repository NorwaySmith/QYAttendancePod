//
//  QYNetworkCache.m
//  QYBaseProject
//
//  Created by 田 on 16/5/4.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYDBHelper.h"
#import "QYNetworkCache.h"
#import "QYNetworkCache.h"
#import "QYSandboxPath.h"
#import <YYCache/YYCache.h>
@interface QYNetworkCache ()
@property(nonatomic, strong) YYDiskCache *diskCache;
@end
@implementation QYNetworkCache
+ (QYNetworkCache *)shared {
  static dispatch_once_t pred;
  static QYNetworkCache *sharedInstance = nil;

  dispatch_once(&pred, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}
- (instancetype)init {
  self = [super init];
  if (self) {
    self.diskCache = [[YYDiskCache alloc]
        initWithPath:[[QYSandboxPath documentPath]
                         stringByAppendingPathComponent:@"DiskCache"]];
  }
  return self;
}

/**
 *  根据key获取缓存数据
 *
 *  @param key key
 *
 *  @return 缓存对象
 */
- (id)cachedObjectForKey:(NSString *)key {
  NSData *data = (NSData *)[_diskCache objectForKey:key];
  return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

/**
 *  根据key存储缓存对象
 *
 *  @param object 缓存对象
 *  @param key    key
 */
- (void)cacheObject:(id)object forKey:(NSString *)key {
  if (object && key) {
    [_diskCache setObject:[NSKeyedArchiver archivedDataWithRootObject:object]
                   forKey:key];
  }
}
@end
