//
//  QYCollectionViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/6/13.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 * UICollectionViewController基础类
 */
#import <UIKit/UIKit.h>
#import "QYTheme.h"

@interface QYCollectionViewController : UICollectionViewController
/**
 * 开启网络监控后，无网络默认显示无网络view
 */
-(void)openNetworkMonitor;
/**
 *  显示无网络view
 */
-(void)showNoNetworkView;
/**
 *  隐藏无网络view
 */
-(void)hideNoNetworkView;
@end
