//
//  UIColor+QYColorToHtmlColor.h
//  NewAssistant
//
//  Created by 田 on 13-12-17.
//  Copyright (c) 2013年 ZhangPengHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QYColorToHtmlColor)

// 白色
+(UIColor*)cWhiteColor;
//黑色
+(UIColor*)cBlackColor;
// 深灰
+(UIColor*)cDarkgrayColor;
//中灰
+(UIColor*)cMediumGreyColor;
// 浅灰
+(UIColor*)cLightGrayColor;
// 天蓝
+(UIColor*)cSkyBlueColor;
// 绿色
+(UIColor*)cGreenColor;
// 红色
+(UIColor*)cRedColor;
// 橘黄
+(UIColor*)cOrangeColor;
//cell选中效果
+(UIColor*)cCellSelectedColor;
//cell分割线
+(UIColor*)cSeparatorLineColor;
// IM列表灰色字体部分
+(UIColor*)cImUserdDetailColor;
// IM列表黑色字体部分
+(UIColor*)cImUserdTitleColor;
// IM设置界面成员姓名颜色
+(UIColor*)cImSeetingUserdNameColor;
// IM设置界面设置选项详情
+(UIColor*)cImSeetingDetailColor;
// IM设置界面设置背景颜色
+(UIColor*)cImSeetingBackgroundColor;
+ (UIColor *)colorWithHexString:(NSString *)stringToConver;


@end
