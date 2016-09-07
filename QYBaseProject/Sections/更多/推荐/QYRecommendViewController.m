//
//  QYRecommendViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYRecommendViewController.h"
#import "QYRecommendView.h"

#import "QYRecommendDetailsViewController.h"
#import "Masonry.h"

@interface QYRecommendViewController ()<QYRecommendViewDelegate>


@property (nonatomic,strong) QYRecommendView *recommendView;

@end

@implementation QYRecommendViewController


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
    self.title = @"推荐给朋友";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self addView];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)addView
{
    self.recommendView = [[QYRecommendView alloc] init];
    self.recommendView.delegate = self;
    self.recommendView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.recommendView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    NSLayoutConstraint *selfViewTop =
    [NSLayoutConstraint constraintWithItem:_recommendView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:padding.top];
    NSLayoutConstraint *selfViewBottom =
    [NSLayoutConstraint constraintWithItem:_recommendView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:padding.bottom];
    NSLayoutConstraint *selfViewLeft =
    [NSLayoutConstraint constraintWithItem:_recommendView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:padding.left];
    NSLayoutConstraint *selfViewRight =
    [NSLayoutConstraint constraintWithItem:_recommendView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:padding.right];
    NSMutableArray *mainConstraint = [[NSMutableArray alloc] initWithObjects:selfViewTop,selfViewBottom,selfViewLeft,selfViewRight, nil];
    
    [self.view addConstraints:mainConstraint];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark --- QYRecommendViewDelegate
//短信分享代理
- (void)messageRecommendAction
{
    //NSLog(@"可以在这里 处理");
    QYRecommendDetailsViewController *recommendDetailsVC = [[QYRecommendDetailsViewController alloc] init];
    
    [self.navigationController pushViewController:recommendDetailsVC animated:YES];
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
