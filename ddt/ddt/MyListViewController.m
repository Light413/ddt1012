//
//  MyListViewController.m
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyListViewController.h"

@interface MyListViewController ()
{
    UISegmentedControl *mysegment;
}
@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的单子";
    NSArray *segmentArr = @[@"接过的单子",@"用过的单子"];
    mysegment = [[UISegmentedControl alloc]initWithItems:segmentArr];
    mysegment.frame = CGRectMake(30, 10, CurrentScreenWidth-60, 30);
    [mysegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    mysegment.tintColor= RGBA(76.0, 132.0, 120.0, 1.0);
    mysegment.enabled = YES;
    mysegment.selectedSegmentIndex = 0;
    [self.view addSubview:mysegment];
    // Do any additional setup after loading the view.
}
-(void)segmentClick:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            
            break;
        case 1:
            
            break;
        default:
            break;
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
