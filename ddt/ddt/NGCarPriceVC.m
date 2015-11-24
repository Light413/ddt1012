//
//  NGCarPriceVC.m
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGCarPriceVC.h"
#import "NGWebView.h"

@interface NGCarPriceVC ()

@end

@implementation NGCarPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc]init];
    NGWebView *_view = [[NGWebView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight - 64) withUrl:NSLocalizedString(@"url_http_cheprice", @"")];
    
    [self.tableView addSubview:_view];
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
