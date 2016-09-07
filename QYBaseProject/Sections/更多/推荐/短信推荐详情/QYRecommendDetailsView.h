//
//  QYRecommendDetailsView.h
//  QYBaseProject
//
//  Created by dzq on 15/7/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYTableViewController.h"
#import "TITokenField.h"


@protocol QYRecommendDetailsViewDelegate <NSObject>


@optional
/**
 *  从通讯录选择联系人
 */
- (void)fromAddressBookSelectContacts;

- (void)loseFristResponse;


@required



@end




@interface QYRecommendDetailsView : UIView


@property (nonatomic,assign)id<QYRecommendDetailsViewDelegate>delegate;

@property (nonatomic,strong) TITokenFieldView *tITokenFieldView;

@property (nonatomic,strong) UITextView *textView;

/**
 *  警告框
 *
 *  @param alertString 警告内容
 */
-(void)alertView:(NSString*)alertString;



@end
