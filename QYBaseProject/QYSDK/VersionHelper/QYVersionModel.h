//
//  QYVersionModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/10.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "JSONModel.h"

@interface QYVersionModel : JSONModel

//是否强制更新
@property(nonatomic,assign)BOOL isStrong;
//版本名
@property(nonatomic,copy)NSString *versionName;
//新版本地址
@property(nonatomic,copy)NSString *versionSrc;
//新版本简介
@property(nonatomic,copy)NSString *versionContent;


@end
