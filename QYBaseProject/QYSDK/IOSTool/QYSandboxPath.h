//
//  QYSandboxPath.h
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYSandboxPath : NSObject
+ (NSString *)homePath;//应用程序目录的路径，在该目录下有三个文件夹：Documents、Library、temp以及一个.app包！该目录下就是应用程序的沙盒，应用程序只能访问该目录下的文件夹！！！
+ (NSString *)libraryPath;
+ (NSString *)desktopPath;//数据所存桌面的绝对路径
+ (NSString *)documentPath;// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrePath; // 配置目录，配置文件存这里
+ (NSString *)libCachePath; // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)appPath;  // .app 程序相对目录，不能存任何东西
+ (NSString *)tmpPath;	// 缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)resourcePath; // .app 程序绝对目录，不能存任何东西
@end
