//
//  UIColor+QYColorToHtmlColor.m
//  NewAssistant
//
//  Created by 田 on 13-12-17.
//  Copyright (c) 2013年 ZhangPengHai. All rights reserved.
//

#import "UIColor+QYColorToHtmlColor.h"

@implementation UIColor (QYColorToHtmlColor)
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
/*
 白色：#ffffff
 黑色：#000000
 深灰：#333333
 中灰：#888888
 浅灰：#adadad
 深蓝：#335588
 天蓝：#0066cc
 绿色：#008000
 红色：#ff0000
 橘黄：#ff6600
 选中效果：#abd2eb
 */
// 白色
+(UIColor*)cWhiteColor{
    return [UIColor colorWithHexString:@"#ffffff"];
}
//黑色
+(UIColor*)cBlackColor{
    return [UIColor colorWithHexString:@"#000000"];
}
// 深灰
+(UIColor*)cDarkgrayColor{
    return [UIColor colorWithHexString:@"#333333"];
}
//中灰
+(UIColor*)cMediumGreyColor{
    return [UIColor colorWithHexString:@"#888888"];
}
// 浅灰
+(UIColor*)cLightGrayColor{
    return [UIColor colorWithHexString:@"#adadad"];
}
// 天蓝
+(UIColor*)cSkyBlueColor{
    return [UIColor colorWithHexString:@"#0066cc"];
}
// 绿色
+(UIColor*)cGreenColor{
    return [UIColor colorWithHexString:@"#008000"];
}
// 红色
+(UIColor*)cRedColor{
    return [UIColor colorWithHexString:@"#ff0000"];
}
// 橘黄
+(UIColor*)cOrangeColor{
    return [UIColor colorWithHexString:@"#ff6600"];
}
// 分割线颜色
+(UIColor*)cSeparatorLineColor{
    return [UIColor colorWithHexString:@"#d9d9d9"];
}
// IM列表灰色字体部分
+(UIColor*)cImUserdDetailColor{
    return [UIColor colorWithHexString:@"#AAAAAA"];
}
// IM列表黑色字体部分
+(UIColor*)cImUserdTitleColor{
    return [UIColor colorWithHexString:@"#353535"];
}
// IM设置界面成员姓名颜色
+(UIColor*)cImSeetingUserdNameColor{
    return [UIColor colorWithHexString:@"#404040"];
}
// IM设置界面设置选项详情
+(UIColor*)cImSeetingDetailColor{
    return [UIColor colorWithHexString:@"#BBBBBB"];
}
// IM设置界面设置背景颜色
+(UIColor*)cImSeetingBackgroundColor{
    return [UIColor colorWithHexString:@"#EBEBEB"];
}

//cell选中效果
+(UIColor*)cCellSelectedColor{
    return [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
}

@end
