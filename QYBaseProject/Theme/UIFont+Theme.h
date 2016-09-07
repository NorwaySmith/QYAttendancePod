//
//  UIFont+Theme.h
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+Base.h"
@interface UIFont (Theme)
/**
 *  返回按钮字体
 *
 *  @return 字体
 */
+(UIFont*)themeBackButtonFont;
/**
 *  标题字体
 *
 *  @return 字体
 */
+(UIFont*)themeNavTitleFont;

/**
 *  @author Mak-er, 16-02-29
 *
 *  @brief  标题字体
 *
 *  @return 字体
 */
+ (UIFont *)themeBoldNavTitleFont;

/**
 *  操作按钮字体
 *
 *  @return 字体
 */
+(UIFont*)themeRightButtonFont;


/**
 *  两行cell，第一行的字体
 *
 *  @return 字体
 */
+(UIFont*)themeCellTextLabelFont;
/**
 *  两行cell，第二行的字体
 *
 *  @return 字体
 */
+(UIFont*)themeCellDetailLabelFont;
/**
 *  文本输入框字体，例如个性签名
 *
 *  @return 字体
 */
+(UIFont*)themeTextInputFont;

/**
 *  应用中心中图标的标题
 *
 *  @return 字体
 */
+(UIFont*)themeMenuTitleFont;

/**
 *  操作，下载菜单字体
 *  
 *  @return 字体
 */
+ (UIFont *)themeOperationMenuTitleFont;

////////////////////通讯录列表////////////////////

/**
 *  头部搜索输入框字体，如通讯录搜索
 *
 *  @return 字体
 */
+(UIFont *)themeSearchTextFieldFont;
/**
 *  通讯录部门名称字体
 *
 *  @return 颜色
 */
+(UIFont *)themeABGroupNameFont;
/**
 *  通讯录部门人数字体
 *
 *  @return 颜色
 */
+(UIFont *)themeABGroupNumFont;
/**
 * 通讯录人员名字字体
 *
 *  @return 颜色
 */
+(UIFont *)themeABUserNameFont;
/**
 * 通讯录职位名字字体
 *
 *  @return 颜色
 */
+(UIFont *)themeABJobFont;
/**
 *  选择人员下方确定取消字体
 *
 *  @return 字体
 */
+(UIFont *)themeABSelectBottomFont;
/**
 *  通讯录 title size 大小
 *
 *  @return 字体
 */
+ (UIFont *)themeABTitleTextSize;



/////////////////附件/////////////////

/**
 *  附件标题字体
 *
 *  @return 字体
 */
+ (UIFont *)themeAnnexTitleFont;
/**
 *  附件字体大小
 *
 *  @return 字体
 */
+ (UIFont *)themeAnnexSizeFont;
/**
 *  附件标题字体
 *
 *  @return 字体
 */
+ (UIFont *)themeAnnexHeaderLabelFont;
@end
