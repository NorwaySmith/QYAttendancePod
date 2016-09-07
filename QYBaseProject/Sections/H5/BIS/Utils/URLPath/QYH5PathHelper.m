//
//  QYH5PathHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/8/19.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYH5PathHelper.h"
@interface QYH5PathHelper()
@property(nonatomic,strong)NSMutableArray *urlRequestArray;
@end

@implementation QYH5PathHelper

-(instancetype)init{
    self=[super init];
    if (self) {
        _urlRequestArray=[[NSMutableArray alloc] init];
    }
    return self;
}
/**
 *  压栈
 *
 *  @param URLRequest 页面请求
 */
-(void)pushURLRequest:(NSURLRequest*)URLRequest{
    NSString *scheme=URLRequest.URL.scheme;
    //如果是跳转链接
    if ([scheme isEqualToString:@"http"]||[scheme isEqualToString:@"https"]) {
        //最后一个对象不等于要添加的对象
        [self popToURLRequest:URLRequest];
        
        if (![self compareURLRequest1:URLRequest
                          URLRequest2:[_urlRequestArray lastObject]]) {
            [_urlRequestArray addObject:URLRequest];
        }
    }
}

/**
 *  出栈并返回最后的urlRequest
 *
 *  @return urlRequest
 */
-(NSURLRequest*)popURLRequest
{
    if ([_urlRequestArray count]>0)
    {
        //删除栈中最后一个对象
        [_urlRequestArray  removeLastObject];
        //取出栈中最后一个对象
        NSURLRequest *lastURLRequest = [_urlRequestArray lastObject];
        [self popToURLRequest:lastURLRequest];
        return lastURLRequest;
    }
    return nil;
}
/**
 *  出栈到URLRequest
 *
 *  @param URLRequest 页面请求
 */
-(void)popToURLRequest:(NSURLRequest*)URLRequest{
    if (URLRequest) {
        //找到栈中和最后一个对象相同的最早加入的对象，并将从这个对象将顶层对象从栈中抛出
        __block NSInteger index=-1;
        [_urlRequestArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([self compareURLRequest1:URLRequest URLRequest2:obj]) {
                if (index==-1) {
                    index=idx;
                }
            }
        }];
        //如果栈中无此对象
        if(index>-1){
            NSInteger loc=index+1;
            NSInteger len= [_urlRequestArray count]-loc;
            [_urlRequestArray removeObjectsInRange:NSMakeRange(loc,len)];
        }
    }
}
/**
 *  比较URLRequest1和URLRequest2基础不带参数的url是否一致
 *
 *  @param URLRequest1
 *  @param URLRequest2
 *
 *  @return 是否一致
 */
-(BOOL)compareURLRequest1:(NSURLRequest*)URLRequest1 URLRequest2:(NSURLRequest*)URLRequest2{
    if (URLRequest1&&URLRequest2) {
        NSString *url1=[[URLRequest1.URL.absoluteString componentsSeparatedByString:@"?"] firstObject];
        NSString *url2=[[URLRequest2.URL.absoluteString componentsSeparatedByString:@"?"] firstObject];
        if ([url1 isEqualToString:url2]) {
            return YES;
        }
    }
    return NO;
}

@end
