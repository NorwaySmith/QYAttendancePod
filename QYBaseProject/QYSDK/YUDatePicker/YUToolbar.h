//
//  YUToolbar.h
//  QYBaseProject
//
//  Created by 董卓琼 on 16/2/17.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YUToolBarDelegate <NSObject>

/**
 *  @author Mak-er, 16-02-18
 *
 *  @brief  取消事件代理
 */
- (void)cancelActionDelegate;

/**
 *  @author Mak-er, 16-02-18
 *
 *  @brief  完成时间代理
 */
- (void)doneActionDelegate;



@end


@interface YUToolBar : UIView


@property (nonatomic,weak) id<YUToolBarDelegate>delegate;



@end
