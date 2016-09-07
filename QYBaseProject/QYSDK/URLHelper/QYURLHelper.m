//
//  QYURLHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/11.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYURLHelper.h"
#import "QYURLHelperNetworkApi.h"
#import "IOSTool.h"
/**
 *  每个项目唯一的code
 */
static NSString  *ProjectName           = @"ydzjcbb";
/**
 *  正式版还是测试版
 */
static NSString *const Surrounding      = @"beta";
/**
 *  接口版本号，接口发生重大改变调用
 */
//static NSInteger  const URLVersionCode  =1;
static NSString * const URLHelperDateKey    = @"com.quanya.URLHelper.DateKey";

@interface QYURLHelper()

@property(nonatomic,strong)NSDictionary *urlDic;

@end

@implementation QYURLHelper

+ (QYURLHelper *)shared
{
    static dispatch_once_t pred;
    static QYURLHelper *sharedInstance = nil;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)initURLHelper
{
//    [self readNetworkJson];
    
    [self readDefaultJson];

}

-(id)jsonAnalysis:(NSString *)jsonString
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    return result;
}

/**
 *  读取本地默认json
 */
-(void)readDefaultJson
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"app_inter_data" ofType:@"json"];
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:&error];
    NSAssert(jsonString, @"error 未正确配置接口配置化app_inter_data.json");

    NSArray *jsonArray = [self jsonAnalysis:jsonString];
    if ([jsonArray count] > 0)
    {
        self.urlDic = jsonArray[0];
    }
}

-(NSString *)getUrlWithModule:(NSString *)module urlKey:(NSString *)urlKey
{
    NSAssert(module, @"error 接口管理，model不能为空");
    NSAssert(urlKey, @"error 接口管理，urlKey不能为空");
    
//    if (!_urlDic)
//    {
//        [self useOldData];
//    }
    NSArray *modelArray = _urlDic[module];
    NSDictionary *moduleDic = nil;
    if ([modelArray count] > 0)
    {
        moduleDic = modelArray[0];
    }
    NSString *urlString = moduleDic[urlKey];
    
    return urlString;
}

/**
 *  请求失败，异常用老数据
 */
//-(void)useOldData
//{
//    self.urlDic = [NSDictionary dictionaryWithContentsOfFile:[self urlDicPath]];
//    if (!_urlDic)
//    {
//        [self readDefaultJson];
//    }
//}

/**
 *  读取网络上的json
 */
//-(void)readNetworkJson
//{
//    NSString *lastVisitTime = [[NSUserDefaults standardUserDefaults] objectForKey:URLHelperDateKey];
//    if (!lastVisitTime)
//    {
//        lastVisitTime = @"";
//    }
//    [QYURLHelperNetworkApi allUrlWithProjectName:ProjectName
//                                     surrounding:Surrounding
//                                   lastVisitTime:lastVisitTime
//                                         success:^(NSString *responseString)
//     {
//         NSDictionary *resultDic = [self jsonAnalysis:responseString];
//         [self readNetworkJsonDone:resultDic];
//     }
//     failure:^(NSString *alert)
//     {
//         [self useOldData];
//     }];
//}
/**
 *  读取网络上的json完成
 */
//-(void)readNetworkJsonDone:(NSDictionary *)resultDic
//{
//    //全量更新
//    if ([resultDic[@"type"] isEqualToString:@"all"])
//    {
//       NSArray *dataArray = resultDic[@"data"];
//        if ([dataArray count] > 0)
//        {
//            self.urlDic = dataArray[0];
//        }
//        //NSLog(@"[self urlDicPath]:%@",[self urlDicPath]);
//        BOOL isSuccess = [_urlDic writeToFile:[self urlDicPath] atomically:YES];
//        if (!isSuccess)
//        {
//            //NSLog(@"写入本地失败");
//        }
//    }
//    else
//    {
//        //本地数据
//        //NSLog(@"[self urlDicPath]:%@",[self urlDicPath]);
//        
//        NSMutableDictionary *localDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self urlDicPath]];
//        NSArray *dataArray = resultDic[@"data"];
//        if (dataArray && [dataArray isKindOfClass:[NSArray class]])
//        {
//            for (NSDictionary *moduleDic  in dataArray)
//            {
//                NSString *moduleName = moduleDic[@"moduleName"];
//                NSArray *interfaceList = moduleDic[@"interfaceList"];
//                for (NSDictionary *interfaceDic in interfaceList)
//                {
//                    NSString *interfaceName = interfaceDic[@"interfaceName"];
//                    NSString *url = interfaceDic[@"url"];
//                    ////////////此处开始找本地数组，并变量更新本地数组中的数据//////////
//                    NSArray *moduleArray = localDic[moduleName];
//                    NSMutableDictionary *moduleDic = nil;
//                    if ([moduleArray count] > 0)
//                    {
//                        moduleDic = [[NSMutableDictionary alloc] initWithDictionary:moduleArray[0]];
//                        [moduleDic setObject:url forKey:interfaceName];
//                        NSArray *newModuleArray = @[moduleDic];
//                        [localDic setObject:newModuleArray forKey:moduleName];
//                    }
//                    /////////////////////////////////////////////////////////////////////////////////////////////////////////
//                }
//            }
//        }
//        self.urlDic = localDic;
//        [_urlDic writeToFile:[self urlDicPath] atomically:YES];
//    }
//    if (resultDic[@"responseTime"])
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:resultDic[@"responseTime"] forKey:URLHelperDateKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//}
//
//-(NSString *)urlDicPath
//{
//    //NSLog(@"dzqdzq====%@",[[QYSandboxPath documentPath] stringByAppendingFormat:@"/URLHelperUrlDic.plist"]);
//    return  [[QYSandboxPath documentPath] stringByAppendingFormat:@"/URLHelperUrlDic.plist"];
//}


@end
