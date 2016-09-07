//
//  NSString+StringOperation.h
//  QYNSStringOperationViewController
//
//  Created by wialliams on 14-6-19.
//  Copyright (c) 2014年 QYIOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (StringOperation)

- (BOOL)isValidateEmail;        //判断邮箱的正确性
- (BOOL)isMobileNumber;         //判断电话号码的正确性
- (NSString *)flattenHTML;      //去掉HTML中的特殊字符
- (CGSize)getStringSizeForFont:(UIFont*)aFont maxSize:(CGSize)maxSize;  //得到string的Size
- (NSString *)removeTheComma;   //去掉最后一个字符
- (NSString *)removeTwoComma;   //去掉字符串第一个字符
- (NSString *)dataFilePath;     //获得doucument下的一个路径
- (BOOL)isValidatePassword;     //判断密码的合法性
- (BOOL)isNull;                 //是否为空
- (BOOL)isUrlLink;              //判断URL链接的合法性


//对URL进行编码
- (NSString *)encodeToPercentEscapeString;
//获取归属地
- (NSString *)thePhoneForPath;

@end
