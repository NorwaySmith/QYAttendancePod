//
//  QYInitData.m
//  QYBaseProject
//
//  Created by 田 on 15/6/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYInitData.h"
#import "QYVersionHelper.h"


@implementation QYInitData


+ (QYInitData *)shared
{
    static QYInitData *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)initData{
    
}


@end
