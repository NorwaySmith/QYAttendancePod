//
//  QYJieKouOperation.h
//  CommunicationAssistant
//
//  Created by wialliams on 15-3-3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYJieKouOperation : NSObject

/**
 *  存储接口数据
 *
 *  @param dic <#dic description#>
 */
+ (void)storeJieKouOperatrion:(NSDictionary *)dic;

/**
 *  获得单一的接口如ydzjMobil下的某一个接口等
 *
 *  @param string   <#string description#>
 *  @param urlKey   <#urlKey description#>
 *  @param localUrl <#localUrl description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getJieKouOperation:(NSString *)string WithUrlKey:(NSString *)urlKey WithLocalUrl:(NSString *)localUrl;

/**
 *  判断能否从本地取到接口数据
 *
 *  @return <#return value description#>
 */
+ (BOOL)exitJieKou;

/**
 *  获得所有的接口数据
 *
 *  @return <#return value description#>
 */
+ (NSDictionary *)getAllJieKouOperation;


/**
 *  请求所有接口 urlString 是请求的接口
 *
 *  @param urlString 请求url
 *  @param dic       请求的参数
 */
+ (void)requestJiekouWithUrl:(NSString *)urlString WithRequestData:(NSDictionary *)dic;

@end
