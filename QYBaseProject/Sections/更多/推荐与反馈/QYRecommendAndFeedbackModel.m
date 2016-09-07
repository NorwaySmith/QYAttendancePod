//
//  QYRecommendAndFeedback.m
//  QYBaseProject
//
//  Created by dzq on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYRecommendAndFeedbackModel.h"

@implementation QYRecommendAndFeedbackModel


+ (QYRecommendAndFeedbackModel *)recommendAndFeedbackValuationLogo:(UIImage *)logoImage title:(NSString *)titleStr
{
    QYRecommendAndFeedbackModel *recommendAndFeedback = [[QYRecommendAndFeedbackModel alloc] init];
    recommendAndFeedback.logoImage = logoImage;
    recommendAndFeedback.titleStr = titleStr;
    
    return recommendAndFeedback;
}




@end
