//
//  MycenterViewController.m
//  ddt
//
//  Created by allen on 15/10/15.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "MycenterViewController.h"
#import "LoginViewController.h"
#import "NGBaseNavigationVC.h"
@interface MycenterViewController ()

@end

@implementation MycenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    LoginViewController *login = [[MySharetools shared]getViewControllerWithIdentifier:@"loginView" andstoryboardName:@"me"];
    NGBaseNavigationVC *nav = [[NGBaseNavigationVC alloc]initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
    // Do any additional setup after loading the view from its nib.
    
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
//    [self presentViewController:nav animated:YES completion:nil];
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
