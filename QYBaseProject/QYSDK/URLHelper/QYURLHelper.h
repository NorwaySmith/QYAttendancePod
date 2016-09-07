//
//  QYURLHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/11.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYURLHelper : NSObject

+ (QYURLHelper *)shared;

-(void)initURLHelper;

-(NSString*)getUrlWithModule:(NSString*)module  urlKey:(NSString*)urlKey;


@end
