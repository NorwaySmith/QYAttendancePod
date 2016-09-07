//
//  QYNewPopViewController.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/7/20.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^block)(NSString *contentText);
@interface QYNewPopViewController: UIViewController
/**
 *  内容视图
 */
@property (nonatomic,strong) UIView *contentView;
/**
 *  contentViewSize 必须设置
 *  内容视图的大小
 */
@property (nonatomic,assign) CGSize contentViewSize;

/**
 *  点击确定回调的block
 */

@property (nonatomic,copy) block confirmBlock;

//打卡的状态值 1正常2迟到3早退
@property (nonatomic, copy)NSString *attState;

//数据
@property (nonatomic, strong)NSDictionary *dataDictionary;
/**
 *  创建主视图后调用此方法初始化contentView
 */
- (void)addContentView;


- (void)hidden;






@end
