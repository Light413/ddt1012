//
//  MyResumeViewController.m
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyResumeViewController.h"

@interface MyResumeViewController ()

@end

@implementation MyResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的简历";
    self.backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    self.backView.layer.borderWidth = 1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)businessTypeBtnClick:(id)sender {
}
- (IBAction)salaryBtnClick:(id)sender {
}
- (IBAction)certificateBtnClick:(id)sender {
}
- (IBAction)chooseBusinessTypeBtnClick:(id)sender {
}

- (IBAction)saveResumeBtnClick:(id)sender {
}

- (IBAction)areaBtnClick:(id)sender {
}
@end
