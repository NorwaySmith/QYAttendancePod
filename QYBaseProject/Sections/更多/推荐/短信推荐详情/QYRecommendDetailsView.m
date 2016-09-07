//
//  QYRecommendDetailsView.m
//  QYBaseProject
//
//  Created by dzq on 15/7/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYRecommendDetailsView.h"
#import "TITokenField.h"
#import "Masonry.h"
#import "MBProgressHUD.h"

@interface QYRecommendDetailsView()<TITokenFieldDelegate,UIScrollViewDelegate>


@end



@implementation QYRecommendDetailsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.tITokenFieldView = [[TITokenFieldView alloc] initWithFrame:self.bounds];
    self.tITokenFieldView.tokenField.textColor = [UIColor colorWithRed:53.0/255 green:53.0/255 blue:53.0/255 alpha:1.0];
    [self.tITokenFieldView.tokenField setPlaceholder:@"请选择人员"];
    [self.tITokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@","]];
    [self.tITokenFieldView.tokenField setPromptText:@""];
    
    UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView setImage:[UIImage imageNamed:@"newAssignAdd"] forState:UIControlStateNormal];
    rightView.frame = CGRectMake(0, 0, 25, 25);
    [rightView addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.tITokenFieldView .tokenField.rightView = rightView;
    [self.tITokenFieldView.tokenField setRightViewMode:UITextFieldViewModeAlways];  //总是显示
    _tITokenFieldView.tokenField.keyboardType = UIKeyboardTypeASCIICapable;

    self.tITokenFieldView.contentView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
    
    [self addSubview:self.tITokenFieldView];
    
    
    UIControl *backgroundControl = [[UIControl alloc] initWithFrame:self.bounds];
    backgroundControl.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0];
    [backgroundControl addTarget:self action:@selector(theBackgroundControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tITokenFieldView.contentView addSubview:backgroundControl];
    
    
    NSString *recommendStr = [NSString stringWithFormat:@"【乐工作】推荐您下载乐工作，下载地址：http://www.le-work.com/clientdown.jsp。首次登录请点忘记密码。"];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, 120)];
    self.textView.userInteractionEnabled = NO;
    self.textView.text = recommendStr;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
    [backgroundControl addSubview:self.textView];
    
}

/**
 *  右侧添加Action
 */
- (void)rightButtonAction
{
    //NSLog(@"添加联系人");
    
    [self.delegate fromAddressBookSelectContacts];
}

-(void)alertView:(NSString *)alertString
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


@end
