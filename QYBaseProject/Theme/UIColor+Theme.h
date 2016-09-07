//
//  UIColor+Theme.h
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Base.h"
@interface UIColor (Theme)
/**
 *  返回按钮颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeBackButtonColor;
/**
 *  返回按钮点击颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeBackButtonHalfColor;
/**
 *  标题颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeNavTitleColor;
/**
 *  操作按钮颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeRightButtonColor;
/**
 *  操作按钮选中颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeRightButtonHalfColor;
/**
 *  控制器背景色，灰色背景
 *
 *  @return 颜色
 */
+(UIColor*)themeBgColorGrey;
/**
 *  控制器背景色，白色背景
 *
 *  @return 颜色
 */
+(UIColor*)themeBgColorWhite;
/**
 *  tabbar选中颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeTabbarSelectedColor;
/**
 *  应用中心中图标的标题
 *
 *  @return 字体
 */
+(UIColor*)themeMenuTitleColor;

/**
 *  操作，下拉菜单字体
 *  
 *  @return 颜色
 */
+ (UIColor *)themeOperationMenuTitleColor;

/*!
 *  @brief  忘记密码分割线
 *
 *  @return 颜色
 */
+(UIColor *)themeForgetPwdSeparatorLineColor;

/**
 *  分割线颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeSeparatorLineColor;
/**
 *  深灰色字体颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeDarkgrayColor;
/**
 *  浅灰色字体颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeLightGrayColor;
/**
 *   中灰色字体颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeMediumGrayColor;
/**
 *  天蓝色
 *
 *  @return 颜色
 */
+(UIColor *)themeSkyBlueColor;

/**
 *  列表的背景色，包含section背景色
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeListBackgroundColor;

#pragma mark - 语音通知
/**
 *  待发送颜色
 *
 *  @return <#return value description#>
 */
+ (UIColor*)themeTZDsendColor;
/**
 *  发送中颜色
 *
 *  @return <#return value description#>
 */
+ (UIColor*)themeTZSendingBlueColor;
/**
 *  标题的颜色，深灰色
 *
 *  @return <#return value description#>
 */
+ (UIColor *)themeTZTitleColor;
/**
 *  taleView的背景色
 *
 *  @return <#return value description#>
 */
+ (UIColor *)themeTZTableViewBackgroundColor;
/**
 *  没有接通的红色
 *
 *  @return <#return value description#>
 */
+ (UIColor *)themeTZRedcolor;
/**
 *   tableView中cell字体的灰色
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeTZTableViewTextColor;
/**
 *  常用白色色值
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeTZWhiteColor;

/**
 *  常用蓝色色值
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeBlueColor;

////////////////////通讯录列表////////////////////

/**
 *  通讯录部门背景颜色
 *
 *  @return 颜色
 *  cell 分割线颜色
 */
+(UIColor*)themeABGroupBg;
/**
 *  人员选中的背景颜色
 *
 *  @return 颜色
 */
+(UIColor*)themeABUserSelectBg;
/**
 *  通讯录部门名称字体
 *
 *  @return 颜色
 */
+(UIColor*)themeABGroupNameColor;
/**
 *  通讯录部门人数字体
 *
 *  @return 颜色
 */
+(UIColor*)themeABGroupNumColor;
/**
 * 通讯录人员名字字体
 *
 *  @return 颜色
 */
+(UIColor*)themeABUserNameColor;
/**
 * 通讯录职位名字字体
 *
 *  @return 颜色
 */
+(UIColor*)themeABJobColor;

/**
 *  新选择人员的section的背景色
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeABSelectUserSectionColor;

/**
 *  搜索字符串颜色
 *
 *  @return 颜色
 */
+(UIColor *)baseSearchTextColor;

/**
 *  taleView的背景色
 *
 *  @return <#return value description#>
 */
+ (UIColor *)themeTableViewBackgroundColor;
/**
 *   tableView中cell字体的灰色
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeTableViewTextColor;
/**
 *  textView、textField默认颜色
 *
 *  @return <#return value description#>
 */
+(UIColor *)themeABSearchPlaceholderColor;

/**
 *  textField、textView输入框的光标颜色
 */
+(UIColor *)themeTextInputeCursorColor;


/////////////////附件///////////////
/**
 *  附件标题字体颜色
 *
 *  @return 字体
 */
+ (UIColor *)themeAnnexTitleColor;
/**
 *  附件字体大小颜色
 *
 *  @return 字体
 */
+ (UIColor *)themeAnnexSizeColor;
/**
 *  附件标题背景颜色
 *
 *  @return 颜色
 */
+ (UIColor*)themeAnnexHeaderLabelBgColor;
/**
 *  附件标题字体颜色
 *
 *  @return 颜色
 */
+ (UIColor*)themeAnnexHeaderLabelTextColor;

/////////////////////////////////////////滴滴回复的颜色
/**
 *  未确认背景颜色
 */
+ (UIColor *)themeUnConfirmColor;

///////////////////IM///////////////
/**
 *  IM列表灰色字体部分
 *
 *  @return 颜色
 */
+(UIColor*)cImUserdDetailColor;
/**
 *  IM列表黑色字体部分
 *
 *  @return 颜色
 */
+(UIColor*)cImUserdTitleColor;
/**
 *  IM聊天页面的背景
 *
 *  @return 颜色
 */
+(UIColor *)cIMChatBackgroundColor;
/**
 *  IM设置界面成员姓名颜色
 *
 *  @return 颜色
 */
+(UIColor*)cImSeetingUserdNameColor;
/**
 *  IM设置界面设置选项详情
 *
 *  @return 颜色
 */
+(UIColor*)cImSeetingDetailColor;
/**
 *  IM设置界面设置背景颜色
 *
 *  @return 颜色
 */
+(UIColor*)cImSeetingBackgroundColor;

/**
 *  红色未读数背景
 *
 *  @return 颜色
 */
+(UIColor*)cRedPointBackgroundColor;

/**
 *  电话会议列表的背景
 *
 *  @return 颜色
 */
+(UIColor*)meetingListBackgroundColor;

/**
 *  电话会议列表的灰色标题
 *
 *  @return 颜色
 */
+(UIColor*)meetingListTitleGrayColor;

/**
 *  电话会议列表的橙色标题
 *
 *  @return 颜色
 */
+(UIColor*)meetingListTitleOrangeColor;

/**
 *  电话会议列表的绿色标题
 *
 *  @return 颜色
 */
+(UIColor*)meetingListTitleGreenColor;

/**
 *  电话会议详情的取消会议标题颜色
 *
 *  @return 颜色
 */
+(UIColor*)meetingDetailCancelButtonTitleColor;

/**
 *  电话会议详情的立即发起标题颜色
 *
 *  @return 颜色
 */
+(UIColor*)meetingDetailStartNowButtonTitleColor;

/**
 *  电话会议详情的按钮背景色
 *
 *  @return 颜色
 */
+(UIColor*)meetingDetailButtonNormalBackgroundColor;

/**
 *  电话会议详情的按钮高亮背景色
 *
 *  @return 颜色
 */
+(UIColor*)meetingDetailButtonHighlightBackgroundColor;
@end
 