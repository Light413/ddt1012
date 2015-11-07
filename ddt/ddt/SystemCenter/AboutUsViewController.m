//
//  AboutUsViewController.m
//  ddt
//
//  Created by allenhzhang on 10/23/15.
//  Copyright (c) 2015 Light. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<UIWebViewDelegate>

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight-64)];
    NSURL * url = [NSURL URLWithString:@"http:www.baidu.com"];
                   //@"http://news.cnr.cn/native/gd/20151106/t20151106_520419363.shtml?bdnews"];
    web.delegate = self;
    web.scalesPageToFit = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    // Do any additional setup after loading the view.
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"正在加载页面"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [SVProgressHUD showInfoWithStatus:@"加载页面失败"];
}

- (void)didReceiveMemoryWarning {
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
