//
//  QYFeedBackView.h
//  QYBaseProject
//
//  Created by dzq on 15/7/2.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QYFeedBackViewDelegate <NSObject>


@optional
- (void)loseFristResponse;      //失去第一响应

- (void)sendFeedBack;           //发送 问题反馈


@required


@end



@interface QYFeedBackView : UIView


@property (nonatomic,assign) id<QYFeedBackViewDelegate>delegate;

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UIButton *sendButton;


-(void)alertView:(NSString *)alertString;

@end
