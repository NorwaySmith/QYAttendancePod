//
//  UIWebView+JavaScriptAlert.m
//  webview
//
//  Created by zhaotengfei on 15-2-9.
//  Copyright (c) 2015年 zhaotengfei. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"
/*
typedef enum _WEBVIEW_JS_CMD_STATE {
    WEBVIEW_JS_CMD_STATE_NONE = 0x00,
    WEBVIEW_JS_CMD_STATE_CANCEL   = 0x01,
    WEBVIEW_JS_CMD_STATE_OK  = 0x02
} WEBVIEW_JS_CMD_STATE;
*/
@implementation UIWebView (JavaScriptAlert)
/*
static volatile WEBVIEW_JS_CMD_STATE _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;

- (NSString *)webView:(UIWebView *)sender runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(id)frame
{
    NSString *reuslt = @"";
    
    NSArray   *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSInteger  majorSystemVer       = [[versionCompatibility objectAtIndex:0] integerValue];
    
    if(majorSystemVer >= 0x05) // isOverIOS5
    {
        UIAlertView* webViewPrompt = [[UIAlertView alloc] init];
        webViewPrompt.delegate     = self;
        webViewPrompt.title        = prompt;
        
        [webViewPrompt addButtonWithTitle:@"OK"];
        
        NSInteger cancelButtonIndex     = [webViewPrompt addButtonWithTitle:@"CANCEL"];
        webViewPrompt.cancelButtonIndex = cancelButtonIndex;
        
        // iOS 5
        //////////////////
        webViewPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField       = [webViewPrompt textFieldAtIndex:0];
        textField.text               = defaultText;
        //////////////////
        [webViewPrompt show];
        
        _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;
        while (_pageWaitUserSelection == WEBVIEW_JS_CMD_STATE_NONE)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        WEBVIEW_JS_CMD_STATE prompt_value = _pageWaitUserSelection;
        _pageWaitUserSelection            = WEBVIEW_JS_CMD_STATE_NONE;
        
        if(prompt_value == WEBVIEW_JS_CMD_STATE_OK)
        {
            reuslt =  textField.text ;
            if(!reuslt)
                reuslt = @"";
        }
        
        webViewPrompt.delegate = nil;
        return reuslt;
    }
    else
    {
        // TODO
        UIAlertView *webViewPrompt = [[UIAlertView alloc] initWithTitle:prompt message:@"\n\n" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"OK", nil];
        
        UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        myTextField.text = defaultText;
        [myTextField setBackgroundColor:[UIColor whiteColor]];
        [myTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [myTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [webViewPrompt addSubview:myTextField];
        [myTextField becomeFirstResponder];
        
        [webViewPrompt show];
        
        _pageWaitUserSelection = WEBVIEW_JS_CMD_STATE_NONE;
        while (_pageWaitUserSelection == WEBVIEW_JS_CMD_STATE_NONE)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        WEBVIEW_JS_CMD_STATE prompt_value = _pageWaitUserSelection;
        _pageWaitUserSelection            = WEBVIEW_JS_CMD_STATE_NONE;
        
        if(prompt_value == WEBVIEW_JS_CMD_STATE_OK)
        {
            reuslt =  myTextField.text ;
            if(!reuslt)
                reuslt = @"";
        }
        
        return reuslt;
    }
}
 */
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [customAlert show];
}
static BOOL diagStat = NO;
static NSInteger bIdx = -1;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
    
    [confirmDiag show];
    bIdx = -1;
    
    while (bIdx==-1) {
        //[NSThread sleepForTimeInterval:0.2];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    if (bIdx == 0){//取消;
        diagStat = NO;
    }
    else if (bIdx == 1) {//确定;
        diagStat = YES;
    }
    return diagStat;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    bIdx = buttonIndex;
}

@end