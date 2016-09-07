//
//  UIFont+Base.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "UIFont+Base.h"

@implementation UIFont (Base)

+(UIFont*)baseTextTitleLarge
{
    return [UIFont systemFontOfSize:19];
}

+(UIFont *)baseBoldTextTitleLarge {
    return [UIFont boldSystemFontOfSize:19];
}

+(UIFont*)baseTextTitle {
    return [UIFont systemFontOfSize:18];
}
+(UIFont*)baseBoldTextTitle
{
    return [UIFont boldSystemFontOfSize:18];
}

+(UIFont*)baseTextLarge
{
    return [UIFont systemFontOfSize:16];
}

+(UIFont*)baseTextMiddle
{
    return [UIFont systemFontOfSize:14];
}
+(UIFont*)baseTextSmall
{
    return [UIFont systemFontOfSize:12];
}
+(UIFont*)baseTextMini
{
    return [UIFont systemFontOfSize:10];
}

@end
