//
//  NGBaseVC.m
//  ddt
//
//  Created by gener on 15/7/26.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGBaseVC.h"

@interface NGBaseVC ()

@end

@implementation NGBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(235, 235, 235, 1.0)];
    if (IOS7LATER)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    // Do any additional setup after loading the view.
    NSInteger index = self.tabBarController.selectedIndex;
    NSLog(@"%d",index);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createLeftBarItemWithBackTitle{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setFrame:CGRectMake(0, 0, 16, 22)] ;
    [button setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal] ;
    [button setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateSelected] ;
    [button addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:item];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)] ;
}
-(void)goback:(UIButton *)btn{

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
