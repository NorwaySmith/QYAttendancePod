//
//  QYFunctionExplainViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/7/15.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYFunctionExplainViewController.h"

#import "QYDialogTool.h"

@interface QYFunctionExplainViewController ()<UIWebViewDelegate>

@property(strong,nonatomic)UIWebView *webView;

@property(nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;


@end

@implementation QYFunctionExplainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUrl:(NSURL *)Url
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 44 - 20)];
    [_webView setScalesPageToFit:YES];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    _Url = Url;
    [_webView loadRequest:[NSURLRequest requestWithURL:_Url]];
    //NSLog(@"_webView:%@",_Url);
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(!_activityIndicatorView)
    {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.center = self.view.center;
        [self.view addSubview:_activityIndicatorView];
    }
    [_activityIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=300;"            //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.x = 10;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView removeFromSuperview];
    self.activityIndicatorView = nil;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView removeFromSuperview];
    self.activityIndicatorView = nil;
    
    [QYDialogTool showDlg:@"网络加载失败"];
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
