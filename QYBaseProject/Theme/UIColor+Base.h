//
//  UIColor+Base.h
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Base)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
//文字颜色黑
+(UIColor*)baseTextBlack;
//文字颜色黑,透明度一半
+(UIColor*)baseTextBlackHalf;
//文字颜色灰
+(UIColor*)baseTextGrey;
//文字颜色中灰
+(UIColor*)baseTextGreyMiddle;
//文字颜色浅灰
+(UIColor*)baseTextGreyLight;
//文字颜色纯黑
+(UIColor*)baseTextBlackDark;
//文字颜色白
+(UIColor*)baseTextWhite;
//文字颜色白，点击
+(UIColor*)baseTextWhiteHalf;
//文字颜色绿
+(UIColor*)baseTextGreen;
//文字颜色红
+(UIColor*)baseTextRed;
//文字颜色链接蓝
+(UIColor*)baseTextBlue;
//文字颜色橘色
+(UIColor*)baseTextOrange;
//文字颜色，单选按钮选中色
+(UIColor*)baseTextRbChecked;
//文字颜色橘色
+(UIColor*)baseTextbase;
//电话会议列表，列表头把颜色
+(UIColor*)baseMeetingHeaderTextbase;


+(UIColor *)baseTextTheme;

/**
 *  表背景颜色
 *
 *  @return 颜色
 */
+(UIColor *)baseTableViewBgColor;

/**
 *  UISwitch 打开颜色
 *
 *  @return 颜色
 */
+(UIColor *)baseSwitchOnTintColor;

/**
 *  拨号搜索字体颜色
 *
 *  @return 颜色
 */
+ (UIColor *)baseDialSearchTintColor;





//app中统一分割线颜色
+ (UIColor *)appSeparatorColor;




@end
