//
//  MyCollectionViewController.m
//  ddt
//
//  Created by allen on 15/10/21.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "NGSearchBar.h"
#import "TonghangTableViewCell.h"
#import "MyScTableViewCell.h"
#import "MenuTableViewCell.h"
#import "menuDetailViewController.h"
#import "NGTongHDetailVC.h"
#import "NGCompanyDetailVC.h"
@interface MyCollectionViewController ()<NGSearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    UISegmentedControl *mysegment;
    NSMutableArray *_dataArr;
}
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarItemWithBackTitle];
    self.title =self.vcType==VcTypeValue_2?@"搜索结果" :@"我的收藏";
    NSArray *segmentArr =self.vcType==VcTypeValue_2?@[@"搜单子",@"搜同行",@"搜公司"]: @[@"单子收藏",@"同行好友",@"公司收藏"];
    
    
    mysegment = [[UISegmentedControl alloc]initWithItems:segmentArr];
        mysegment.frame = CGRectMake(30, 10, CurrentScreenWidth-60, 30);
        [mysegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    mysegment.tintColor= RGBA(76.0, 132.0, 120.0, 1.0);
    mysegment.enabled = YES;
    mysegment.selectedSegmentIndex = 0;
    [self.view addSubview:mysegment];
    
    
    NGSearchBar *searchBar = [[NGSearchBar alloc]initWithFrame:CGRectMake(10, mysegment.bottom+10, CurrentScreenWidth -20 , 30)];
    searchBar.delegate  =self;
    searchBar.placeholder = @"搜索";
    [self.view addSubview:searchBar];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBar.bottom+10, CurrentScreenWidth, CurrentScreenHeight-searchBar.bottom-10-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self loadData];
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];

//    [self addheader:myTableView];
//    [self addfooter:myTableView];
    // Do any additional setup after loading the view.
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
    CGFloat height = 0.0f;
    NSInteger index = mysegment.selectedSegmentIndex;
    switch (index) {
        case 0:
            height = 90;
            break;
        case 1:
            height = 102;
            break;
        case 2:
            height = 60;
            break;
            
        default:
            break;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = mysegment.selectedSegmentIndex;
    if (index == 0) {
        static NSString *menuCellID = @"menuCell";
        MenuTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:menuCellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuTableViewCell" owner:self options:nil]lastObject];
        }
        return cell;
    }else if (index == 1) {
        static NSString *CellId = @"tonghangcell";
        TonghangTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TonghangTableViewCell" owner:self options:nil]lastObject];
        }
        return cell;
    }else if(index == 2){
        static NSString *cellId = @"commanyCell";
        MyScTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyScTableViewCell" owner:self options:nil]lastObject];
        }
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = mysegment.selectedSegmentIndex;
    switch (index) {
        case 0:{
            menuDetailViewController *menu =[[MySharetools shared]getViewControllerWithIdentifier:@"menuDetail" andstoryboardName:@"me"];
            menu.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:menu animated:YES];
        }            
            break;
        case 1:{
            NGTongHDetailVC *vc = [[MySharetools shared]getViewControllerWithIdentifier:@"TongHDetailVC" andstoryboardName:@"secondSB"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        
        }
            break;
        case 2:{
            NGCompanyDetailVC *vc = [[MySharetools shared]getViewControllerWithIdentifier:@"CompanyDetailVC" andstoryboardName:@"companySB"];;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)addheader:(UITableView *)freshTableView{
    freshTableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHeaderData)];
    [freshTableView.header beginRefreshing];
}
- (void)addfooter:(UITableView *)freshTableView{
    freshTableView.footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFooterData)];
}
-(void)loadHeaderData{
    
}
-(void)loadFooterData{
    
}
-(void)segmentClick:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            __weak __typeof(self) weakSelf = self;
            //myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf loadData];
           // }];
        }
            break;
        case 1:
        {
            __weak __typeof(self) weakSelf = self;
           // myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf loadData];
           // }];
        }
            break;
        case 2:
        {
            __weak __typeof(self) weakSelf = self;
           // myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf loadData];
            //}];
        }
            break;
        default:
            break;
    }
}
#pragma mark -NGSearchBarDelegate
-(void)searchBarWillBeginSearch:(NGSearchBar *)searchBar
{
    NSLog(@"begin");
}

-(void)searchBarDidBeginSearch:(NGSearchBar *)searchBar withStr:(NSString *)str
{
    NSLog(@"did : %@",searchBar.text);
}
-(void)goback:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
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
