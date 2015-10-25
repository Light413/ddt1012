//
//  PersonanlBusinessViewController.m
//  ddt
//
//  Created by huishuyi on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "PersonanlBusinessViewController.h"
#import "NGBaseListView.h"
@interface PersonanlBusinessViewController ()
{
     NGBaseListView *_listView;
}
@end

@implementation PersonanlBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_listView == nil) {
        _listView =  [[NGBaseListView alloc]initWithFrame:CGRectZero withDelegate:self];
    }
    _listView.frame  = CGRectMake(0, 0,CurrentScreenWidth, 0);
    
    CGRect rec = _listView.frame;
    // Do any additional setup after loading the view.
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
