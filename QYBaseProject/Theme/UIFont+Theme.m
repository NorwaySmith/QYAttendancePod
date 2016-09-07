//
//  UIFont+Theme.m
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "UIFont+Theme.h"

@implementation UIFont (Theme)


+(UIFont*)themeBackButtonFont{
   return [UIFont baseTextLarge];
}

+(UIFont*)themeNavTitleFont{
    return [UIFont baseTextTitleLarge];
}

+(UIFont*)themeBoldNavTitleFont{
    return [UIFont baseBoldTextTitle];
}


+(UIFont*)themeRightButtonFont{
  return [UIFont systemFontOfSize:15];
}

+(UIFont*)themeCellTextLabelFont{
    return [UIFont baseTextLarge];
}

+(UIFont*)themeCellDetailLabelFont{
    return [UIFont baseTextMiddle];

}

+(UIFont*)themeTextInputFont{
   return [UIFont baseTextMiddle];
}

+(UIFont*)themeMenuTitleFont{
    return [UIFont baseTextMiddle];

}

+ (UIFont *)themeOperationMenuTitleFont {
    return [UIFont baseTextMiddle];
}

////////////////////通讯录列表////////////////////
+(UIFont*)themeSearchTextFieldFont{
    return [UIFont baseTextMiddle];
    
}
/**
 *  通讯录部门名称字体
 *
 *  @return 颜色
 */
+(UIFont*)themeABGroupNameFont{
    return [UIFont baseTextLarge];
}
/**
 *  通讯录部门人数字体
 *
 *  @return 颜色
 */
+(UIFont*)themeABGroupNumFont{
    return [UIFont baseTextSmall];
    
}
/**
 * 通讯录人员名字字体
 *
 *  @return 颜色
 */
+(UIFont*)themeABUserNameFont{
    return [UIFont baseTextLarge];
    
}
/**
 * 通讯录职位名字字体
 *
 *  @return 颜色
 */
+(UIFont*)themeABJobFont{
    return [UIFont baseTextMiddle];
    
}
/**
 *  选择人员下方确定取消字体
 *
 *  @return 字体
 */
+(UIFont*)themeABSelectBottomFont{
    return [UIFont baseTextTitleLarge];
}
/**
 *  通讯录 title size
 *
 *  @return <#return value description#>
 */
+ (UIFont *)themeABTitleTextSize
{
    return [UIFont baseTextTitle];
}

/////////////////附件/////////////////

/**
 *  附件标题字体
 *
 *  @return 字体
 */
+ (UIFont *)themeAnnexTitleFont{
    return [UIFont baseTextLarge];

}
/**
 *  附件字体大小
 *
 *  @return 字体
 */
+ (UIFont *)themeAnnexSizeFont{
    return [UIFont baseTextMiddle];

}
/**
 *  附件标题字体
 *
 *  @return 字体
 */
+ (UIFont*)themeAnnexHeaderLabelFont{
    return [UIFont baseTextMiddle];

}
@end
