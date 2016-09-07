//
//  QYH5PathHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/8/19.
//  Copyright (c) 2015年 田. All rights reserved.
//  URL轨迹管理

#import <Foundation/Foundation.h>

@interface QYH5PathHelper : NSObject
/**
 *  压栈
 *
 *  @param URLRequest 页面请求
 */
-(void)pushURLRequest:(NSURLRequest*)URLRequest;
/**
 *  出栈并返回最后的urlRequest
 *
 *  @return urlRequest
 */
-(NSURLRequest*)popURLRequest;
/**
 *  出栈到URLRequest
 *
 *  @param URLRequest 页面请求
 */
-(void)popToURLRequest:(NSURLRequest*)URLRequest;

@end
