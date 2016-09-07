//
//  QYIMDiskCacheManage.h
//  QYBaseProject
//
//  Created by 田 on 16/1/19.
//  Copyright © 2016年 田. All rights reserved.
//

/**
 *  IM 磁盘缓存处理类
 */

#import <Foundation/Foundation.h>

@interface QYIMDiskCacheManager : NSObject
+ (QYIMDiskCacheManager *)shared;
/**
 *  在退出登录及清除缓存操作时，请调用此方法。删除IM中缓存的图片、语音
 *
 *  @return 是否删除成功
 */
- (BOOL)clearDiskCaches;
@end
