//
//  menuDetailViewController.m
//  ddt
//
//  Created by huishuyi on 15/11/1.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "menuDetailViewController.h"

@interface menuDetailViewController ()

@end

@implementation menuDetailViewController
@synthesize customerInfoLabel1;
@synthesize customerInfoLabel2;
@synthesize loanLabel;
@synthesize detailInfoLabel;
@synthesize menuInfoLabel1;
@synthesize menuInfoLabel2;
@synthesize suodingLabel;
@synthesize nameLabel;
@synthesize phoneLabel;
@synthesize phoneImage;
@synthesize menuModel;
@synthesize timeLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单子详情";
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self initViews];
    // @"称呼：%@ 类型%@Do any additional setup after loading the view.
}
-(void)initViews{
    customerInfoLabel1.text = [NSString stringWithFormat:@"称呼:%@ 类型:%@",menuModel.cs_ch,menuModel.cs_type];
    customerInfoLabel2.text = [NSString stringWithFormat:@"征信:%@ 年龄:%@",menuModel.zxqk,menuModel.cs_age];
    loanLabel.text = [NSString stringWithFormat:@"贷款金额:%@ 贷款期限:%@",menuModel.cs_dkje,menuModel.cs_dkqx];
    detailInfoLabel.text = menuModel.bz;
    menuInfoLabel1.text = [NSString stringWithFormat:@"信誉评分:%@ 浏览:%@",menuModel.frompf,menuModel.see];
    timeLabel.text = [NSString stringWithFormat:@"时间:%@",menuModel.tjsj];
    suodingLabel.text = [NSString stringWithFormat:@"锁定此单、需要花费%@积分",menuModel.jifen];
    nameLabel.text = menuModel.cs_ch;
    phoneLabel.text = menuModel.fmobile;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    switch (indexPath.row) {
        case 0:
            height = 75.0;
            break;
        case 1:
            height = 50.0;
            break;
        case 2:
            height = [ToolsClass calculateSizeForText:menuModel.bz :CGSizeMake(CurrentScreenWidth-20, 1000) font:[UIFont systemFontOfSize:12]].height+40;
            break;
        case 3:
            height = 80.0;
            break;
        case 4:
            height = 60.0;
            break;
        default:
            break;
    }
    return height;
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

- (IBAction)phoneBtnClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",menuModel.fmobile]]];
}
@end
