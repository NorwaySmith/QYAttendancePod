//
//  UIWebView+JavaScriptAlert.h
//  webview
//
//  Created by zhaotengfei on 15-2-9.
//  Copyright (c) 2015年 zhaotengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)
-(void) webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
//- (NSString *)webView:(UIWebView *)sender runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(id)frame;
/*
 – webView:runJavaScriptAlertPanelWithMessage: Deprecated in OS X v10.4.11
 – webView:runJavaScriptConfirmPanelWithMessage: Deprecated in OS X v10.4.11
 – webView:runJavaScriptTextInputPanelWithPrompt:defaultText: Deprecated in OS X v10.4.11
 */
@end

