//
//  NGSearchCityVC.m
//  ddt
//
//  Created by wyg on 15/10/18.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGSearchCityVC.h"

@interface NGSearchCityVC ()

@end

@implementation NGSearchCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    // Do any additional setup after loading the view.
    [self createLeftBarItemWithBackTitle];
}

-(void)awakeFromNib
{

}
-(void)goback:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
