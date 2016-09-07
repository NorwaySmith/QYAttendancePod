//
//  QYSysTool.m
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYSysTool.h"
#include <sys/stat.h>
#include <dirent.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
@implementation QYSysTool
+ (QYSysTool *)sharedInstance
{
    static dispatch_once_t pred;
    static QYSysTool *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
+ (void)sendMail:(NSString *)mail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mail]];
}

+ (void)makePhoneCall:(NSString *)tel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

+ (void)sendSMS:(NSString *)tel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

+ (void)openURLWithSafari:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
@end
