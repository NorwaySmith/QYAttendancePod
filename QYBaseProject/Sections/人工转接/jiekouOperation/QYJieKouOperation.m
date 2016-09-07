//
//  QYJieKouOperation.m
//  CommunicationAssistant
//
//  Created by wialliams on 15-3-3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYJieKouOperation.h"
//#import "QYHttpRequest.h"

@implementation QYJieKouOperation
/**
 * @brief     存储请求到的所有接口
 * @param     dic  请求到的接口数据
 * @return
 */
+ (void)storeJieKouOperatrion:(NSDictionary *)dic
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/urlFile.plist"];
    [dic writeToFile:filePath atomically:YES];
}

/**
 * @brief     返回单一请求的接口
 * @param     string 所在的分类的key  urlKey  URL链接的key值
 * @return
 */
+ (NSString *)getJieKouOperation:(NSString *)string WithUrlKey:(NSString *)urlKey WithLocalUrl:(NSString *)localUrl
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/urlFile.plist"];
    NSDictionary *allUrlDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if ([self exitJieKou])
    {
        NSArray *array = [allUrlDic objectForKey:@"data"];
        NSDictionary *urlDic = [array firstObject];
         NSArray *urlArr = [urlDic objectForKey:string];
        
        __block NSString *urlString = @"";
        [urlArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            NSDictionary *dic = (NSDictionary *)obj;
            NSArray *allKeys = [dic allKeys];
            for (int i = 0; i < allKeys.count; i ++)
            {
                NSString *key = [allKeys objectAtIndex:i];
                if ([key isEqualToString:urlKey])
                {
                    urlString = [dic objectForKey:urlKey];
                    if (urlString == nil || [urlString isEqualToString:@""])
                    {
                        urlString = localUrl;
                    }
                }
            }
        }];
        return urlString;
    }
    return localUrl;
    
}

/**
 * @brief     得到本地存储的所有接口的数据
 * @param
 * @return
 */
+ (NSDictionary *)getAllJieKouOperation
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/urlFile.plist"];
    NSDictionary *allUrlDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if ([self exitJieKou])
    {
        return allUrlDic;
    }
    return nil;
    
}

/**
 * @brief     判断本地存储的接口文件是否存在
 * @param
 * @return
 */
+ (BOOL)exitJieKou
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/urlFile.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dic == nil || dic.count == 0)
    {
        return NO;
    }
    return YES;
}

/**
 * @brief     请求项目所有接口的请求
 * @param     urlString  请求的链接   dic  请求的参数
 * @return
 */
+ (void)requestJiekouWithUrl:(NSString *)urlString WithRequestData:(NSDictionary *)dic
{
    NSString *responseTime = [[QYJieKouOperation getAllJieKouOperation] objectForKey:@"responseTime"];
    if (responseTime == nil)
    {
        responseTime = @"";
    }
//    QYHttpRequest *httpRequest = [[QYHttpRequest alloc] init];
//    [httpRequest willSendHttpRequest:urlString parameters:dic superView:[UIView new]];
//    httpRequest.didConnectHttpDone = ^(int state,id result){
//        if (state == 100) {
//            //NSLog(@"result:%@",result);
//            NSDictionary *urlDic = (NSDictionary *)result;
//            if ([urlDic objectForKey:@"data"] != nil && [[urlDic objectForKey:@"data"] count] != 0) {
//                if ([[urlDic objectForKey:@"type"] isEqualToString:@"part"]) {
//                    urlDic = [self updateUrlData:urlDic];
//                    
//                }
//                [QYJieKouOperation storeJieKouOperatrion:urlDic];
//            }
//        }else{
////            [self alert:result];
//        }
//        
//    };
}

/**
 * @brief     接口数据部分更新时的本地更新操作
 * @param     dic  部分更新请求到的参数
 * @return
 */
+ (NSDictionary *)updateUrlData:(NSDictionary *)dic
{
    NSMutableDictionary *allUrlDic = [NSMutableDictionary dictionaryWithDictionary:[QYJieKouOperation getAllJieKouOperation]];
    NSMutableArray *urlArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"data"]];
    NSMutableArray *localUrlArr = [NSMutableArray arrayWithArray:[[[allUrlDic objectForKey:@"data"] firstObject] objectForKey:@"bussiness"]];
    
    for (int i = 0;i < urlArray.count ; i ++)
    {
        NSDictionary *dic1 = [urlArray objectAtIndex:i];
        NSArray *newUrlArr = [dic1 objectForKey:@"interfaceList"];
        for (int j = 0; j < newUrlArr.count; j ++)
        {
            NSDictionary *dic2 = [newUrlArr objectAtIndex:j];
            for (int k = 0; k < localUrlArr.count; k ++)
            {
                NSDictionary *oneDic = [localUrlArr objectAtIndex:k];
                NSArray *keyArr = [oneDic allKeys];
                if ([[dic2 objectForKey:@"interfaceName"] isEqualToString:[keyArr firstObject]])
                {
                    [localUrlArr removeObjectAtIndex:i];
                    [localUrlArr addObject:dic1];
                }
                else
                {
                    NSDictionary *dic3 = [NSDictionary dictionaryWithObject:[dic2 objectForKey:@"url"] forKey:[dic2 objectForKey:@"interfaceName"]];
                    [localUrlArr addObject:dic3];
                }
            }
        }
    }
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[[allUrlDic objectForKey:@"data"] firstObject]];
    [dataDic removeObjectForKey:@"bussiness"];
    [dataDic setObject:localUrlArr forKey:@"bussiness"];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[allUrlDic objectForKey:@"data"]];
    [dataArr removeAllObjects];
    [dataArr addObject:dataDic];
    
    NSMutableDictionary *changeDic = [NSMutableDictionary dictionary];
    [changeDic setObject:dataArr forKey:@"data"];
    [changeDic setObject:[dic objectForKey:@"type"] forKey:@"type"];
    [changeDic setObject:[dic objectForKey:@"responseTime"] forKey:@"responseTime"];
    
    return changeDic;
}


@end
