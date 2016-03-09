//
//  HotPicVC.m
//  ddt
//
//  Created by gener on 16/3/9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "HotPicVC.h"

#import "NGWebView.h"

@interface HotPicVC ()

@end

@implementation HotPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    NGWebView *_view = [[NGWebView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight - 64) withUrl:self.desurl ? self.desurl:NSLocalizedString(@"url_http_aboutus", @"")];
    
    [self.view addSubview:_view];
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
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
