//
//  QYRecommendView.h
//  QYBaseProject
//
//  Created by dzq on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QYRecommendViewDelegate <NSObject>


@optional
/**
 *  短信推荐 代理
 */
- (void)messageRecommendAction;


@required



@end





@interface QYRecommendView : UIView

@property (nonatomic,assign)id<QYRecommendViewDelegate>delegate;





@end
