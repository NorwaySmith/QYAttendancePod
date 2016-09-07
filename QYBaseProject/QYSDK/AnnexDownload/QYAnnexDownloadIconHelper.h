//
//  QYAnnexDownloadIconHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/8/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAnnexDownloadIconHelper : NSObject
/**
 *  根据名称后缀得到小图标
 *
 *  @param annexName 附件名称
 *
 *  @return 附件图标
 */
+(UIImage *)iconWithAnnexName:(NSString*)annexName;
/**
 *  根据名称后缀得到大图标
 *
 *  @param annexName 附件名称
 *
 *  @return 附件图标
 */
+(UIImage *)bigIconWithAnnexName:(NSString*)annexName;

@end
