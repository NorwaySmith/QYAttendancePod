//
//  UIColor+Base.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "UIColor+Base.h"

@implementation UIColor (Base)

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

//文字颜色黑
+(UIColor*)baseTextBlack
{
    return [self colorWithHexString:@"#353535"];
}
//文字颜色黑,透明度一半
+(UIColor*)baseTextBlackHalf
{
    return [self colorWithHexString:@"#88353535"];
}
//文字颜色灰
+(UIColor*)baseTextGrey
{
    return [self colorWithHexString:@"#AAAAAA"];
}
//文字颜色中灰
+(UIColor*)baseTextGreyMiddle
{
    return [self colorWithHexString:@"#555555"];
}
//文字颜色浅灰
+(UIColor*)baseTextGreyLight
{
    return [self colorWithHexString:@"#bbbbbb"];
}
//文字颜色纯黑
+(UIColor*)baseTextBlackDark
{
    return [self colorWithHexString:@"#000000"];
}
//文字颜色白
+(UIColor*)baseTextWhite
{
    return [self colorWithHexString:@"#ffffff"];
}
//文字颜色白，点击
+(UIColor*)baseTextWhiteHalf
{
    return [self colorWithHexString:@"#88ffffff"];
}
//文字颜色绿
+(UIColor*)baseTextGreen
{
    return [self colorWithHexString:@"#55cd55"];
}
//文字颜色红
+(UIColor*)baseTextRed
{
    return [self colorWithHexString:@"#ff5454"];
}
//文字颜色链接蓝
+(UIColor*)baseTextBlue
{
    return [self colorWithHexString:@"#617FA5"];
}
//文字颜色橘色
+(UIColor*)baseTextOrange
{
    return [self colorWithHexString:@"#efb935"];
}
//文字颜色，单选按钮选中色
+(UIColor*)baseTextRbChecked
{
    return [self colorWithHexString:@"#25b6ed"];
}
//文字颜色橘色
+(UIColor *)baseTextTheme
{
    return [self colorWithHexString:@"#25b6ed"];
}

//表的背景颜色
+(UIColor *)baseTableViewBgColor
{
    return [self colorWithHexString:@"#ebebeb"];
}

//UISwitch 打开颜色
+(UIColor *)baseSwitchOnTintColor
{
    return [self colorWithHexString:@"#32b7eb"];
}

//拨号搜索字体颜色
+ (UIColor *)baseDialSearchTintColor
{
    return [self colorWithHexString:@"#3ab2df"];
}

+(UIColor*)baseMeetingHeaderTextbase{
    return [self colorWithHexString:@"#888888"];
}

//app中统一分割线颜色
+ (UIColor *)appSeparatorColor
{
    return [self colorWithHexString:@"#d9d9d9"];  //RGB  217 217 217
}



@end
