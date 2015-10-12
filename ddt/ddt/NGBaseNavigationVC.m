//
//  NGBaseNavigationVC.m
//  ddt
//
//  Created by gener on 15/7/5.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGBaseNavigationVC.h"
#define NGNavigationBgColor [UIColor colorWithRed:0.106 green:0.580 blue:0.984 alpha:1];

@interface NGBaseNavigationVC ()

@end

@implementation NGBaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /** 设置navigationBar的外观 */
    
    if (IOS7LATER) {
        self.navigationBar.translucent = YES;//设置半透明效果
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.barTintColor = NGNavigationBgColor;//设置bar的背景颜色
        [self.navigationBar setTintColor:[UIColor whiteColor]];//设置按钮字体颜色
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];//设置标题颜色
    }
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
