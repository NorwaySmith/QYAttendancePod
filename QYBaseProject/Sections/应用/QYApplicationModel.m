//
//  QYApplicationModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/13.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYApplicationModel.h"

@implementation QYApplicationModel

-(QYApplicationModel *)initWithTitle:(NSString *)title icon:(UIImage *)icon badgeValue:(NSString *)badgeValue badge:(BOOL)isBadge
{
    QYApplicationModel *model = [[QYApplicationModel alloc] init];
    model.title = title;
    model.icon = icon;
    model.badgeValue = badgeValue;
    model.isBadge = isBadge;
    
    return model;
}

@end
