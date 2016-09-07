//
//  UIImageView+Round.h
//  QYBaseProject
//
//  Created by 董卓琼 on 15/10/28.
//  Copyright © 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Round)
/**
 *  创建列表圆形图形
 *  方形--->圆形 clipsToBounds = YES
 *  圆形--->方形 clipsToBounds = NO
 *
 *  @return
 */
- (void)createListRoundIconViewDiameter:(float)diameter obj:(UIImageView *)imageView;

/**
 *  创建圆形图形
 *  方形--->圆形 clipsToBounds = YES
 *  圆形--->方形 clipsToBounds = NO
 *
 *  @return
 */
- (void)createRoundIconViewDiameter:(float)diameter obj:(UIImageView *)imageView;


/**
 *  创建圆角图形(自定义圆角)
 *
 *
 *
 *  @return
 */
- (void)createCustomFilletIconViewDiameter:(float)diameter obj:(UIImageView *)imageView;


/**
 *  创建圆角图形(固定圆角)
 *
 *
 *
 *  @return
 */
- (void)createUnCustomFilletIconView:(UIImageView *)imageView;


@end
