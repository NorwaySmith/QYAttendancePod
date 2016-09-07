//
//  QYPersonalitySignatureViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/7/2.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYPersonalitySignatureViewController.h"

#import "Masonry.h"
#import "NSString+ToolExtend.h"
#import "QYIndivCenterTextView.h"
#import "QYDialogTool.h"

#import "QYPersonalitySignatureView.h"

@interface QYPersonalitySignatureViewController ()<UITextViewDelegate>

//@property (strong,nonatomic)QYIndivCenterTextView *textView;

@property (nonatomic,strong) QYPersonalitySignatureView *personalitySignatureView;


@end



@implementation QYPersonalitySignatureViewController

#pragma mark - life cycle
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupRightBarButton];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self setupUI];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
-(void)done
{
//    NSString *text = [self.personalitySignatureView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    if ([text isNil])
//    {
//        [QYDialogTool showDlg:@"请输入文字"];
//        return;
//    }
    if (_completBlock)
    {
        _completBlock(self.personalitySignatureView.textView.text);
    }
}

#pragma mark - private methods
-(void)setupRightBarButton
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont themeRightButtonFont];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 50, 44);
    rightButton.titleLabel.font = [UIFont themeRightButtonFont];
    UIBarButtonItem *operationBar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                  target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, operationBar];
}


-(void)setupUI
{
    self.personalitySignatureView = [[QYPersonalitySignatureView alloc] initWithFrame:self.view.bounds];
    self.personalitySignatureView.textView.text = self.text;
    [self.view addSubview:self.personalitySignatureView];
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
