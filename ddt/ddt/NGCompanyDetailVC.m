//
//  NGCompanyDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGCompanyDetailVC.h"

@interface NGCompanyDetailVC ()

@end

@implementation NGCompanyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_credit"]];
    self.tableView.tableFooterView = [[UIView alloc]init];
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
