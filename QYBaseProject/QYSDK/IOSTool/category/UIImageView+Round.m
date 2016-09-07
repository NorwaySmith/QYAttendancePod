//
//  UIImageView+Round.m
//  QYBaseProject
//
//  Created by 董卓琼 on 15/10/28.
//  Copyright © 2015年 田. All rights reserved.
//

#import "UIImageView+Round.h"

@implementation UIImageView (Round)

/**
 *  创建列表圆形图形
 *  方形--->圆形 clipsToBounds = YES
 *  圆形--->方形 clipsToBounds = NO
 *
 *  @return
 */
- (void)createListRoundIconViewDiameter:(float)diameter obj:(UIImageView *)imageView{
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 4;
}

/**
 *  创建圆形图形
 *  方形--->圆形 clipsToBounds = YES
 *  圆形--->方形 clipsToBounds = NO
 *
 *  @return
 */
- (void)createRoundIconViewDiameter:(float)diameter obj:(UIImageView *)imageView
{
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = diameter/2;
}

/**
 *  创建圆角图形(自定义圆角)
 *
 *
 *
 *  @return
 */
- (void)createCustomFilletIconViewDiameter:(float)diameter obj:(UIImageView *)imageView
{
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = diameter;
}

/**
 *  创建圆角图形(固定圆角)
 *
 *
 *
 *  @return
 */
- (void)createUnCustomFilletIconView:(UIImageView *)imageView
{
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 5;
}


@end
