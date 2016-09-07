//
//  QYH5ModuleManage.m
//  QYBaseProject
//
//  Created by 田 on 15/8/12.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYH5ModuleManage.h"
#import "IOSTool.h"
@implementation QYH5ModuleManage
/**
 *  h5模块存放路径
 *
 *  @return 路径
 */
-(NSString*)h5ModulePath{
    NSString *path=[[QYSandboxPath documentPath] stringByAppendingFormat:@"/h5Module"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
    }
   return path;
}
/**
 *  添加一个模块
 *
 *  @param modulePath 模块路径
 *  @param moduleName 模块名
 */
-(void)addModuleAtModulePath:(NSString*)modulePath moduleName:(NSString*)moduleName{

}
/**
 *  根据模块名删除一个模块
 *
 *  @param moduleName 模块名
 */
-(void)delModuleWithModuleName:(NSString*)moduleName{
    NSError *error=nil;
    [[NSFileManager defaultManager] removeItemAtPath:[[self h5ModulePath] stringByAppendingString:moduleName] error:&error];
    //NSLog(@"delModuleWithModuleName:%@",error);
}
/**
 *  更具模块名得到模块路径
 *
 *  @param moduleName 模块名
 *
 *  @return 模块路径
 */
-(NSURL*)moduleURLWithModuleName:(NSString*)moduleName{
    NSString *path=[[[self h5ModulePath] stringByAppendingString:moduleName] stringByAppendingString:@"index.html"];
    return [NSURL fileURLWithPath:path];
}
/**
 *  删除所有模块
 */
-(void)delAllModule{
    NSError *error=nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self h5ModulePath] error:&error];
    //NSLog(@"delAllModule:%@",error);
}
@end
