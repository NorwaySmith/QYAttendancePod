//
//  QYH5WebView.h
//  QYBaseProject
//
//  Created by 田 on 15/8/6.
//  Copyright (c) 2015年 田. All rights reserved.
//  webView产生进度

#import <UIKit/UIKit.h>
/**
 *  block进度回调
 *
 *  @param progress 进度
 */
typedef void (^QYWebViewProgressBlock)(float progress);

@class QYH5WebView;
/**
 *  代理进度回调
 */
@protocol QYH5WebViewProgressDelegate <NSObject>
@optional
/**
 *  进度回调
 *
 *  @param webView  产生进度的webView
 *  @param progress 进度
 */
- (void)webView:(QYH5WebView *)webView progress:(float)progress;
@end

@interface QYH5WebView :UIWebView
<UIWebViewDelegate>
/**
 *  设置h5Delegate，不要设置Delegate
 */
@property (nonatomic, weak) id <UIWebViewDelegate,QYH5WebViewProgressDelegate>h5Delegate;
/**
 *  加载进度
 */
@property (nonatomic, readonly) float progress;
/**
 *  block监测进度
 */
@property (nonatomic, copy) QYWebViewProgressBlock progressBlock;
@end
