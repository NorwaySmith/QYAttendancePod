//
//  QYNoNetworkView.h
//  QYBaseProject
//
//  Created by lin on 16/1/29.
//  Copyright (c) 2016年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QYNoNetworkViewDelegate<NSObject>

@optional
/**
 *  无网络view点击回调
 */
-(void)didClickNoNetworkView;

@end

@interface QYNoNetworkView : UIView

@property(nonatomic,weak)id <QYNoNetworkViewDelegate>delegate;

@end
