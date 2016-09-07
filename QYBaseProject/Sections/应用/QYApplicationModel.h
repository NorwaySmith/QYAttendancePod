//
//  QYApplicationModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/13.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYApplicationModel : NSObject

@property (nonatomic,  copy) NSString *title;
@property (nonatomic,strong) UIImage  *icon;
@property (nonatomic,  copy) NSString *badgeValue;      // default is nil
@property (nonatomic,assign) BOOL isBadge;              // default is NO

-(QYApplicationModel *)initWithTitle:(NSString *)title icon:(UIImage *)icon badgeValue:(NSString *)badgeValue badge:(BOOL)isBadge;

@end
