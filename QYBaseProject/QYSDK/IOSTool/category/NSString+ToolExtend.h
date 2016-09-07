//
//  NSString+ToolExtend.h
//  IOSToolDemo
//
//  Created by 田 on 15/5/7.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (ToolExtend)
//是否不为空
-(BOOL)isNotNil;

/**
 *  @author 田鹏涛, 15-05-07 11:05:13
 *
 *  字符串是否为空
 *
 *  @return YES or NO
 */
-(BOOL)isNil;

/**
 *  @author 田鹏涛, 15-05-07 11:05:56
 *
 *  去掉左右空格换行
 *
 *  @return 去掉左右空格换行后的字符串
 */
- (NSString *)removeWhiteSpaces;

/**
 *  @author 田鹏涛, 15-05-07 11:05:58
 *
 *  统计字符个数
 *
 *  @return 字符个数
 */
- (NSUInteger)countWords;
/**
 *  @author 田鹏涛, 15-05-07 11:05:58
 *
 *  计算 Size
 *
 *  @return Size
 */
-(CGSize)getStringSizeForFont:(UIFont*)aFont maxSize:(CGSize)maxSize;


/**
 *  语音通知，计算size 2012-10-23 - 01:17
 *
 *  计算 Size
 *
 *  @return Size
 */
-(CGSize)TZgetStringSizeForFont:(UIFont*)aFont maxSize:(CGSize)maxSize;


/**
 *  @author Mak-er, 16-02-25
 *
 *  @brief  电话号码
 *
 *  @param aString 需要处理的电话号
 *
 *  @return 处理后的电话号
 */
- (NSString *)telephoneWithReformat;

- (NSUInteger)numberOfLines;


@end
