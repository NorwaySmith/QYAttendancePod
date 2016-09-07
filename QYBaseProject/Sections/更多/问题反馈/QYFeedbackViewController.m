//
//  QYFeedbackViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYFeedbackViewController.h"

#import "QYFeedBackView.h"

#import "QYAccount.h"
#import "QYAccountService.h"

#import "QYMoreNetworkApi.h"

@interface QYFeedbackViewController ()<UITextViewDelegate,QYFeedBackViewDelegate>

@property (nonatomic,strong) QYFeedBackView *feedBackView;


@end

@implementation QYFeedbackViewController


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问题反馈";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self addView];
    
}
- (void)addView
{
    self.feedBackView = [[QYFeedBackView alloc] initWithFrame:self.view.bounds];
    _feedBackView.delegate = self;
    _feedBackView.textView.delegate = self;
    [self.view addSubview:_feedBackView];
}



#pragma mark ---UITextView 代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    
    if ([textView.text isEqualToString:@"请输入您要反馈的内容(300字以内)"])
    {
        textView.text = @"";
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([toBeString length] > 300)
    {
        textView.text = [toBeString substringToIndex:300];
        self.feedBackView.numberLabel.text = [NSString stringWithFormat:@"%ld/300",[textView.text length]];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger num = [textView.text length];
    if (num > 300)
    {
        return;
    }
    self.feedBackView.numberLabel.text = [NSString stringWithFormat:@"%ld/300",num];
    
    NSArray *array = [self.feedBackView.numberLabel.text componentsSeparatedByString:@"/"];
    NSString *textNumber = array[0];
    
    if ([textNumber integerValue] > 0)
    {
        self.feedBackView.sendButton.enabled = YES;
    }
    else if ([textNumber integerValue] == 0)
    {
        self.feedBackView.sendButton.enabled = NO;
    }
    if ([self.feedBackView.textView.text isEqualToString:@"请输入您要反馈的内容(300字以内)"])
    {
        self.feedBackView.sendButton.enabled = NO;
    }
}


#pragma mark --- QYFeedBackView 代理方法
- (void)loseFristResponse
{
    if ([self.feedBackView.textView.text isEqualToString:@""] || self.feedBackView.textView.text == nil)
    {
        self.feedBackView.textView.textColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
        self.feedBackView.textView.text = @"请输入您要反馈的内容(300字以内)";
    }
    [self.view endEditing:YES];
}
//发送代理方法
- (void)sendFeedBack
{
    NSString *content = [self.feedBackView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([content isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"内容不能为空！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        QYAccount *account = [[QYAccountService shared] defaultAccount];
        NSString *userId = account.userId;
        NSString *companyId = account.companyId;
        
        [QYMoreNetworkApi sendProblemFeedBackWithContent:content userId:userId companyId:companyId success:^(NSString *successStr)
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self.feedBackView alertView:successStr];
        }
        failure:^(NSString *error)
        {
            [self.feedBackView alertView:error];
        }];
        [self.view endEditing:YES];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
