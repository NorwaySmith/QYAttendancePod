//
//  QYPersonalitySignatureViewController.h
//  QYBaseProject
//
//  Created by dzq on 15/7/2.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYViewController.h"


@interface QYPersonalitySignatureViewController : QYViewController

@property(nonatomic,copy)void(^completBlock)(NSString *string);

@property(nonatomic,copy)NSString *text;


@end
