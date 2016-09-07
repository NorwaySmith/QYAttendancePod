//
//  QYGuidePageViewController.m
//  QYBaseProject
//
//  Created by 董卓琼 on 15/9/16.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYGuidePageViewController.h"
#import "QYLoginViewController.h"
#import "QYNavigationViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "QYInitUI.h"


#define SCREENWITH [UIScreen mainScreen].bounds.size.width

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface QYGuidePageViewController ()<UIScrollViewDelegate>


@property (nonatomic,strong) NSArray *guidePageArray;
@property (nonatomic,strong) UIScrollView *guidePageScrollView;
@property (nonatomic,strong) UIButton *gotoLogin;

//@property (nonatomic,assign) float startContentOffsetX;     //开始     偏移量 x
//@property (nonatomic,assign) float willEndContentOffsetX;   //将要完成  偏移量 x
//@property (nonatomic,assign) float endContentOffsetX;       //完成     偏移量 x

@end

@implementation QYGuidePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    
}

- (void)initView
{
    _guidePageArray = @[@"gp_phoneMeeting",@"gp_didi"];
    
    _guidePageScrollView = [[UIScrollView alloc] init];
    _guidePageScrollView.frame = CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT);
    _guidePageScrollView.contentSize = CGSizeMake(SCREENWITH * _guidePageArray.count, SCREENHEIGHT);
    _guidePageScrollView.pagingEnabled = YES;
    _guidePageScrollView.bounces = NO;
    _guidePageScrollView.showsHorizontalScrollIndicator = NO;
    _guidePageScrollView.delegate = self;
    [self.view addSubview:_guidePageScrollView];
    
    for (int i = 0; i < _guidePageArray.count; i++)
    {
        UIImageView *guideImageView = [[UIImageView alloc] init];
        guideImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_guidePageArray[i]]];
        guideImageView.frame = CGRectMake(SCREENWITH * i, 0, SCREENWITH, SCREENHEIGHT);
        [_guidePageScrollView addSubview:guideImageView];
    }
    
    //点击事件
    _gotoLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _gotoLogin.backgroundColor = [UIColor clearColor];
    [_gotoLogin setBackgroundImage:[UIImage imageNamed:@"experience"] forState:UIControlStateNormal];
    [_gotoLogin setBackgroundImage:[UIImage imageNamed:@"experience_H"] forState:UIControlStateHighlighted];
    [_gotoLogin addTarget:self action:@selector(delayOperation) forControlEvents:UIControlEventTouchUpInside];
    _gotoLogin.adjustsImageWhenHighlighted = NO;
    _gotoLogin.hidden = YES;
    [_guidePageScrollView addSubview:_gotoLogin];
    
    [_gotoLogin mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.view.mas_left).offset(70);
         make.right.equalTo(self.view.mas_right).offset(-70);
         make.bottom.equalTo(self.view.mas_bottom).offset(-50);
         make.height.equalTo(@(45 * (SCREENWITH - 140) / 180));
     }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect visibleBounds = scrollView.bounds;
    NSInteger index = (NSInteger)(
                                  floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index>=[_guidePageArray count]-1) {
        _gotoLogin.hidden = NO;
    }else{
        _gotoLogin.hidden = YES;
    }
}

////拖动前的起始坐标
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.x == SCREENWITH * (_guidePageArray.count - 1))
//    {
//        _gotoLogin.hidden = NO;
//    }else{
//        _gotoLogin.hidden = YES;
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.x == SCREENWITH * (_guidePageArray.count - 1))
//    {
//        _gotoLogin.hidden = NO;
//    }else{
//        _gotoLogin.hidden = YES;
//    }
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    _gotoLogin.hidden = YES;
//}


- (void)delayOperation
{
    [[QYInitUI shared] initUI:nil];
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
