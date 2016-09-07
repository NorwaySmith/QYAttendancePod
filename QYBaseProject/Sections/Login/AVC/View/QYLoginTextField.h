//
//  QYLoginTextField.h
//  QYBaseProject
//
//  Created by 田 on 15/6/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

/**
 *  登录输入框，第三方暂不注释
 */
#import <UIKit/UIKit.h>

@interface QYLoginTextField : UITextField

@property (nonatomic) UIEdgeInsets textInsets;
@property (nonatomic) UIOffset rightViewPadding;
@property (nonatomic) BOOL showTopLineSeparator;
@property (nonatomic) BOOL showSecureTextEntryToggle;

- (instancetype)initWithLeftViewImage:(NSString *)leftString;

@end
