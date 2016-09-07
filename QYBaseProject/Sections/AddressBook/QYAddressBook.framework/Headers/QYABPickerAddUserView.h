//
//  QYABPickerAddUserView.h
//  QYBaseProject
//
//  Created by lin on 15/12/21.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  选人中，显示选人结果的view
 */
#import <UIKit/UIKit.h>
#import "QYABPickerUserResultView.h"

@protocol QYABPickerAddUserDelegate <NSObject>

- (void)addUserAction:(id)object;

@end

@interface QYABPickerAddUserView : UIView

@property (nonatomic,assign) id<QYABPickerAddUserDelegate> delegate;
/**
 *  选人中，显示选人结果头像的view
 */
@property (nonatomic, strong) QYABPickerUserResultView *resultView;
/**
 *  选择人数label
 */
@property (nonatomic,strong) UILabel *appointNum;
/**
 *  本次所选人员
 */
@property (nonatomic, strong) NSArray *userArray;

@end
