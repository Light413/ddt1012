//
//  MyListViewController.m
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyListViewController.h"
#import "MenuTableViewCell.h"
#import "menuDetailViewController.h"
@interface MyListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl *mysegment;
    UITableView *myTableView;
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
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mysegment.bottom+10, CurrentScreenWidth, CurrentScreenHeight-mysegment.bottom-10-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];

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
-(void)loadData{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        // [_common_list_dataSource addObjectsFromArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@""]];
        [myTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        [myTableView.header endRefreshing];
    });
}
#pragma mark --tableview 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = mysegment.selectedSegmentIndex;
    static NSString *menuCellID = @"menuCell";
    MenuTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:menuCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuTableViewCell" owner:self options:nil]lastObject];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    menuDetailViewController *menu =[[MySharetools shared]getViewControllerWithIdentifier:@"menuDetail" andstoryboardName:@"me"];
    menu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:menu animated:YES];
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
