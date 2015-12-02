//
//  NGWebView.m
//  ddt
//
//  Created by wyg on 15/11/7.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGWebView.h"

@implementation NGWebView
{
    UIWebView *_webview;
    BOOL _hasStart;
}


-(instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        _webview = [[UIWebView alloc]initWithFrame:frame];
        _webview.delegate = self;
        _webview.scalesPageToFit = YES;
        
        [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self addSubview:_webview];
        _hasStart = NO;
    }
    
    return self;
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!_hasStart) {
        _hasStart = YES;
//        [SVProgressHUD showWithStatus:@"正在加载页面"];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [SVProgressHUD showInfoWithStatus:@"加载页面失败"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
