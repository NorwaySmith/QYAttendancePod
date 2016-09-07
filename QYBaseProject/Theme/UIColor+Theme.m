//
//  UIColor+Theme.m
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "UIColor+Theme.h"

@implementation UIColor (Theme)

+(UIColor*)themeNavTitleColor{
    return [UIColor baseTextWhite];
}
+(UIColor*)themeBackButtonHalfColor{
    return [UIColor baseTextWhiteHalf];
}
+(UIColor*)themeBackButtonColor{
    return [UIColor baseTextWhite];
}
+(UIColor*)themeRightButtonColor{
    return [UIColor baseTextWhite];
}
+(UIColor*)themeRightButtonHalfColor{
    return [UIColor baseTextWhiteHalf];
}
+(UIColor*)themeBgColorWhite{
    return [UIColor colorWithHexString:@"#ffffff"];
}
+(UIColor*)themeBgColorGrey{
    return [UIColor colorWithHexString:@"#ebebeb"];
}
+(UIColor*)themeTabbarSelectedColor{
    return [UIColor colorWithHexString:@"#00b4ff"];
}

+(UIColor*)themeMenuTitleColor{
    return [UIColor baseTextBlack];
}

+ (UIColor *)themeOperationMenuTitleColor {
    return [UIColor baseTextBlack];
}

+(UIColor *)themeForgetPwdSeparatorLineColor
{
    return [UIColor colorWithHexString:@"#25b6ed"];
}

+(UIColor *)themeSeparatorLineColor{
    return [UIColor colorWithHexString:@"#d9d9d9"];
}
+(UIColor *)themeDarkgrayColor{
    return [UIColor colorWithHexString:@"#000000"];
}
+(UIColor *)themeLightGrayColor{
    return [UIColor colorWithHexString:@"#aaaaaa"];
}
+(UIColor *)themeMediumGrayColor{
    return [UIColor colorWithHexString:@"#888888"];
}
+(UIColor *)themeSkyBlueColor{
    return [UIColor colorWithHexString:@"#0066cc"];
}

/**
 *  列表的背景色，包含section背景色
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeListBackgroundColor{
    return [UIColor colorWithHexString:@"#ebebeb"];
}

#pragma mark - 语音通知
+(UIColor *)themeTZDsendColor{
    return [UIColor colorWithHexString:@"#25b6ed"];
}
+(UIColor *)themeTZSendingBlueColor{
    return [UIColor colorWithHexString:@"#55cd55"];
}
+(UIColor *)themeTZTitleColor{
    return [UIColor colorWithHexString:@"#353535"];
}
+(UIColor *)themeTZTableViewBackgroundColor{
    return [UIColor colorWithHexString:@"#ebebeb"];
}
+(UIColor *)themeTZRedcolor{
    return [UIColor colorWithHexString:@"#ff5454"];
}
+(UIColor *)themeTZTableViewTextColor{
    return [UIColor colorWithHexString:@"#AAAAAA"];
}
+(UIColor*)themeTZWhiteColor{
    return [UIColor colorWithHexString:@"#ffffff"];
}
+(UIColor *)themeBlueColor{
    return [UIColor colorWithHexString:@"#00b4ff"];
}


////////////////////通讯录列表////////////////////

/**
 *  通讯录部门背景颜色
 *
 *  @return 颜色
 */
+(UIColor *)themeABGroupBg
{
    return  [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
}
+(UIColor *)themeABUserSelectBg
{
    return [UIColor colorWithHexString:@"#eaf7fc"];
    
}
/**
 *  通讯录部门名称字体
 *
 *  @return 颜色
 */
+(UIColor*)themeABGroupNameColor{
    
    return  [UIColor baseTextGreyMiddle];
}
/**
 *  通讯录部门人数字体
 *
 *  @return 颜色
 */
+(UIColor*)themeABGroupNumColor{
    return  [UIColor baseTextWhite];
    
}
/**
 * 通讯录人员名字字体
 *
 *  @return 颜色
 */
+(UIColor*)themeABUserNameColor{
    return  [UIColor baseTextBlackDark];
    
}
/**
 * 通讯录职位名字字体
 *
 *  @return 颜色
 */
+(UIColor*)themeABJobColor
{
    return  [UIColor baseTextGrey];
    
}

/**
 *  新选择人员的section的背景色
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeABSelectUserSectionColor
{
    return [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
}

+(UIColor *)themeTableViewBackgroundColor{
    return [UIColor colorWithHexString:@"#ebebeb"];
}

+(UIColor *)themeTableViewTextColor{
    return [UIColor colorWithHexString:@"#AAAAAA"];
}


//搜索  字体颜色
+(UIColor *)baseSearchTextColor
{
    return [self colorWithHexString:@"#26B5ED"];
}
/**
 *  textView、textField默认颜色
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeABSearchPlaceholderColor{
    return [UIColor colorWithHexString:@"#aaaaaa"];
}

/**
 *  textField、textView输入框的光标颜色
 */
+(UIColor *)themeTextInputeCursorColor{
    return [UIColor colorWithHexString:@"#1e58f0"];
}

/**
 *  附件标题字体颜色
 *
 *  @return 字体
 */
+ (UIColor *)themeAnnexTitleColor{
    return  [UIColor baseTextBlackDark];
}
/**
 *  附件字体大小颜色
 *
 *  @return 字体
 */
+ (UIColor *)themeAnnexSizeColor{
    return  [UIColor baseTextGrey];
}
/**
 *  附件标题背景颜色
 *
 *  @return 颜色
 */
+ (UIColor*)themeAnnexHeaderLabelBgColor{
    return  [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
}
/**
 *  附件标题字体颜色
 *
 *  @return 颜色
 */
+ (UIColor*)themeAnnexHeaderLabelTextColor{
    return  [UIColor baseTextGreyMiddle];
}
/////////////////////////////////////////滴滴回复的颜色
/**
 *  未确认背景颜色
 */
+ (UIColor *)themeUnConfirmColor
{
    return [self colorWithHexString:@"#fcf7d7"];
}

/////////////////////////IM///////////////
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
//IM聊天页面的背景
+(UIColor *)cIMChatBackgroundColor{
    return [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
}
// IM设置界面设置选项详情
+(UIColor*)cImSeetingDetailColor{
    return [UIColor colorWithHexString:@"#BBBBBB"];
}
// IM设置界面设置背景颜色
+(UIColor*)cImSeetingBackgroundColor{
    return [UIColor colorWithHexString:@"#EBEBEB"];
}

/**
 *  红色未读数背景
 *
 *  @return 颜色
 */
+(UIColor*)cRedPointBackgroundColor
{
    return  [UIColor colorWithRed:251.0/255.0 green:62.0/255.0 blue:43.0/255.0 alpha:1.0];
}


#pragma mark - 电话会议
/**
 *  电话会议列表的背景
 *
 *  @return 颜色
 */
+(UIColor*)meetingListBackgroundColor {
    return [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
}

/**
 *  电话会议列表的灰色标题
 *
 *  @return 颜色
 */
+(UIColor*)meetingListTitleGrayColor
{
    return [UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0];
}

/**
 *  电话会议列表的橙色标题
 *
 *  @return 颜色
 */
+(UIColor*)meetingListTitleOrangeColor {
    return [UIColor colorWithRed:242.0/255.0 green:77.0/255.0 blue:11.0/255.0 alpha:1.0];
}

/**
 *  电话会议列表的绿色标题
 *
 *  @return 颜色
 */
+(UIColor*)meetingListTitleGreenColor {
    return [UIColor colorWithRed:93.0/255.0 green:197.0/255.0 blue:0 alpha:1.0];
}

/**
 *  电话会议详情的取消会议标题颜色
 *
 *  @return 颜色
 */
+(UIColor*)meetingDetailCancelButtonTitleColor {
    return [UIColor colorWithRed:243.0/255.0 green:65.0/255.0 blue:72.0/255.0 alpha:1.0];
}

/**
 *  电话会议详情的立即发起标题颜色
 *
 *  @return 颜色
 */
+(UIColor*)meetingDetailStartNowButtonTitleColor {
    return [UIColor colorWithRed:74.0/255.0 green:199.0/255.0 blue:70.0/255.0 alpha:1.0];
}

/**
 *  电话会议详情的按钮背景色
 *
 *  @return 颜色
 */
+(UIColor*)meetingDetailButtonNormalBackgroundColor {
    return [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
}

/**
 *  电话会议详情的按钮高亮背景色
 *
 *  @return 颜色
 */
+(UIColor*)meetingDetailButtonHighlightBackgroundColor {
    return [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
}
@end
