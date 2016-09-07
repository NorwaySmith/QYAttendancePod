//
//  QYRecommendAndFeedback.h
//  QYBaseProject
//
//  Created by dzq on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QYRecommendAndFeedbackModel : NSObject


/**
 *  logo Image
 */
@property (nonatomic,strong) UIImage *logoImage;

/**
 *  title
 */
@property (nonatomic,strong) NSString *titleStr;



+ (QYRecommendAndFeedbackModel *)recommendAndFeedbackValuationLogo:(UIImage *)logoImage title:(NSString *)titleStr;

@end
