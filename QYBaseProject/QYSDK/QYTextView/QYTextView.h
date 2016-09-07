//
//  QYTextView.h
//  ConferenceCall
//
//  Created by 田 on 13-6-7.
//  Copyright (c) 2013年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYTextView : UITextView
{
UILabel *_placeHolderLabel;
}
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@property (nonatomic, retain) UILabel *_placeHolderLabel;

@end
