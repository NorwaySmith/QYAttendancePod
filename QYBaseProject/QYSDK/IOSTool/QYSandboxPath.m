//
//  QYSandboxPath.m
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYSandboxPath.h"

@implementation QYSandboxPath
+ (NSString *)homePath {
    return NSHomeDirectory();
}
+ (NSString *)libraryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}

+ (NSString *)desktopPath {
    return [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)libPrePath{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

+ (NSString *)tmpPath{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
}

+ (NSString *)appPath {
    return [[NSBundle mainBundle] bundlePath];
}

+ (NSString *)resourcePath {
    return [[NSBundle mainBundle] resourcePath];
}

@end
