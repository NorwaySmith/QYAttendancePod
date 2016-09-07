//
//  QYFeedBackView.m
//  QYBaseProject
//
//  Created by dzq on 15/7/2.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYFeedBackView.h"
#import "QYTextView.h"
#import "MBProgressHUD.h"

#import "QYTheme.h"

@interface QYFeedBackView()

@end

@implementation QYFeedBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    UIControl *backgroundControl = [[UIControl alloc] initWithFrame:self.bounds];
    backgroundControl.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0];
    [backgroundControl addTarget:self action:@selector(theBackgroundControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundControl];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 190)];
    backgroundView.layer.cornerRadius = 1;
    backgroundView.layer.borderColor = [UIColor colorWithRed:189.0/255.0 green:194.0/255.0 blue:199.0/255.0 alpha:1].CGColor;
    backgroundView.layer.borderWidth = 0.5;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgroundView];

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 30, 150)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.textColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
    _textView.text = @"请输入您要反馈的内容(300字以内)";
    _textView.keyboardType = UIKeyboardAppearanceDefault;
    _textView.returnKeyType = UIReturnKeyDone;
    [backgroundView addSubview:_textView];
    
    self.numberLabel = [[UILabel alloc] init];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.textAlignment = 2;
    _numberLabel.font = [UIFont systemFontOfSize:12];
    _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _numberLabel.textColor = [UIColor colorWithRed:187.0/255 green:187.0/255 blue:187.0/255 alpha:1.0];
    _numberLabel.text = @"0/300";
    _numberLabel.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:_numberLabel];
    UIEdgeInsets numberLabelPadding = UIEdgeInsetsMake(5, 5, 0, 10);
    NSLayoutConstraint *numberLabelTop =
    [NSLayoutConstraint constraintWithItem:_numberLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_textView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:numberLabelPadding.top];
    NSLayoutConstraint *numberLabelLeft =
    [NSLayoutConstraint constraintWithItem:_numberLabel
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:backgroundView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:numberLabelPadding.left];
    NSLayoutConstraint *numberLabelRight =
    [NSLayoutConstraint constraintWithItem:_numberLabel
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:backgroundView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-numberLabelPadding.right];
    NSLayoutConstraint *numberLabelBottom =
    [NSLayoutConstraint constraintWithItem:_numberLabel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:backgroundView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:-numberLabelPadding.bottom];
    [self addConstraints:@[numberLabelTop,numberLabelLeft,numberLabelRight,numberLabelBottom]];
    

    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:@"发 送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateDisabled];
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"login_loginButtonBg"] forState:UIControlStateNormal];
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"login_loginButtonBgD"] forState:UIControlStateDisabled];
    _sendButton.layer.cornerRadius = 4;
    _sendButton.clipsToBounds = YES;
    _sendButton.enabled = NO;
    _sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_sendButton addTarget:self action:@selector(theSendButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    _sendButton. = YES;
    [self addSubview:_sendButton];
    
    UIEdgeInsets sendButtonPadding = UIEdgeInsetsMake(buttonTopPadding, buttonLeftOrRightPadding, 0, buttonLeftOrRightPadding);
    NSLayoutConstraint *sendButtonTop =
    [NSLayoutConstraint constraintWithItem:_sendButton
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:backgroundView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:sendButtonPadding.top];
    NSLayoutConstraint *sendButtonLeft =
    [NSLayoutConstraint constraintWithItem:_sendButton
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:sendButtonPadding.left];
    NSLayoutConstraint *sendButtonRight =
    [NSLayoutConstraint constraintWithItem:_sendButton
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-sendButtonPadding.right];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_sendButton(==45)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendButton)]];
    [self addConstraints:@[sendButtonTop,sendButtonLeft,sendButtonRight]];
    
}


-(void)alertView:(NSString*)alertString
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if (!alertString||![alertString isKindOfClass:[NSString class]])
        {
           return;
        }
        MBProgressHUD *alertHud = [MBProgressHUD showHUDAddedTo:[UIApplication  sharedApplication].delegate.window animated:YES];
        alertHud.labelFont = [UIFont systemFontOfSize:12];
        alertHud.mode = MBProgressHUDModeText;
        alertHud.labelText = alertString;
        alertHud.margin = 5.f;
        alertHud.yOffset = 100.f;
        alertHud.cornerRadius = 0.5;
        alertHud.removeFromSuperViewOnHide = YES;
        alertHud.userInteractionEnabled = NO;
        [alertHud hide:YES afterDelay:3];
    });
}


- (void)theBackgroundControlAction
{
    [self.delegate loseFristResponse];
}

- (void)theSendButtonAction
{
    [self.delegate sendFeedBack];
}



@end
