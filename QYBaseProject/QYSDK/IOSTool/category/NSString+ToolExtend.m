//
//  NSString+ToolExtend.m
//  IOSToolDemo
//
//  Created by 田 on 15/5/7.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "NSString+ToolExtend.h"

@implementation NSString (ToolExtend)
//是否为空
-(BOOL)isNil{
    
    if (!self) {
        return YES;
    }
    if (![self isKindOfClass:[NSString class]]) {
        //NSLog(@"---------%@ 不是字符串",self);
        return YES;
    }
    if ([[self removeWhiteSpaces] isEqualToString:@""]) {
        return YES;
    }
    if ([[self removeWhiteSpaces] isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([[self removeWhiteSpaces] isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}
//是否不为空
-(BOOL)isNotNil{
    if (!self) {
        return NO;
    }
    if (![self isKindOfClass:[NSString class]]) {
        return NO;
    }
 
    if (![[self removeWhiteSpaces] isEqualToString:@""]&&
        ![[self removeWhiteSpaces] isEqualToString:@"(null)"]&&
        ![[self removeWhiteSpaces] isEqualToString:@"<null>"]) {
        return YES;
    }
    
    return NO;
}
//删除空格换行
- (NSString *)removeWhiteSpaces
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}
//统计字符个数
- (NSUInteger)countWords{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil]) {
        count++;
    }
    
    return count;
}
/**
 * @brief 得到string的Size
 * @param aFont  这个字符串的font
 * @param aString  需要返回大小的在字符串
 * @param maxSize  划定一个最大区域
 * @return 返回字符串的大小
 */
-(CGSize)getStringSizeForFont:(UIFont*)aFont maxSize:(CGSize)maxSize
{
    CGFloat maxWidth = maxSize.width;
    CGFloat maxHeight = maxSize.height;
    CGRect stringRect = [self boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName :aFont }
                                           context:nil];
    //    CGSize labelsize = [self sizeWithFont:aFont constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    return stringRect.size;
}

-(CGSize)TZgetStringSizeForFont:(UIFont*)aFont maxSize:(CGSize)maxSize
{
    CGFloat maxWidth = maxSize.width;
    CGFloat maxHeight = maxSize.height;
    CGRect stringRect = [self boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                           options:NSStringDrawingUsesFontLeading
                                        attributes:@{ NSFontAttributeName :aFont }
                                           context:nil];
    return stringRect.size;
}

/**
 *  @author Mak-er, 16-02-25
 *
 *  @brief  电话号码
 *
 *  @param aString 需要处理的电话号
 *
 *  @return 处理后的电话号
 */
- (NSString *)telephoneWithReformat {
    if (!self) {
        return nil;
    }
    NSString *aString = self;
    
    if ([self containsString:@"+86" withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    }
    if ([self containsString:@"-" withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if ([self containsString:@"\\" withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    
    //英文括号
    if ([self containsString:@"(" withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if ([self containsString:@")" withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    //中文括号
    if ([self containsString:@"（" withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@"（" withString:@""];
    }
    if ([self containsString:@"）" withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@"）" withString:@""];
    }
    
    //中文空格
    if ([self containsString:@" " withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    //英文空格
    if ([self containsString:@" " withAllString:aString]) {
        aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return aString;
}
- (BOOL)containsString:(NSString *)aString withAllString:(NSString *)allString
{
    NSRange range = [[allString lowercaseString] rangeOfString:[aString lowercaseString]];
    return range.location != NSNotFound;
}

- (NSUInteger)numberOfLines
{
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

@end
