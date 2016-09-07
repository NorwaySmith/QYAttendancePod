//
//  YUToolbar.m
//  QYBaseProject
//
//  Created by 董卓琼 on 16/2/17.
//  Copyright © 2016年 田. All rights reserved.
//

#import "YUToolBar.h"


@interface YUToolBar ()

@property (nonatomic,strong) UIButton *cancel;      //取消
@property (nonatomic,strong) UIButton *done;        //完成



@end



@implementation YUToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel.frame = CGRectMake(10, 2, 40, 40);
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [_cancel setTitleColor:[UIColor colorWithRed:9.0/255.0 green:117.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancel];
    
    self.done = [UIButton buttonWithType:UIButtonTypeCustom];
    _done.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 40, 2, 40, 40);
    [_done setTitle:@"完成" forState:UIControlStateNormal];
    [_done setTitleColor:[UIColor colorWithRed:9.0/255.0 green:117.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_done addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_done];

}

/**
 *  @author Mak-er, 16-02-17
 *
 *  @brief  取消事件
 *
 *  @param sender 触发对象
 */
- (void)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelActionDelegate)]) {
        [self.delegate cancelActionDelegate];
    }
}

/**
 *  @author Mak-er, 16-02-17
 *
 *  @brief  完成时间
 *
 *  @param sender 触发对象
 */
- (void)doneAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(doneActionDelegate)]) {
        [self.delegate doneActionDelegate];
    }
}




@end
