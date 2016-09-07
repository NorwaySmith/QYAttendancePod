//
//  QYH5BlockButton.h
//  QYBaseProject
//
//  Created by 田 on 15/8/14.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonClickBlock)(UIButton *button);

@interface QYH5BlockButton : UIButton
@property(nonatomic,copy)ButtonClickBlock buttonClickBlock;
@end
