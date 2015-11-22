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
#import "MenuOfMyCenterModel.h"
@interface MyListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl *mysegment;
    UITableView *myTableView;
    int pnum;//which page;
    NSMutableArray *_dataArr;
}
@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的单子";
    _dataArr = [[NSMutableArray alloc]init];
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
    pnum = 1;
    [self loadData:pnum];
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pnum = 1;
        [weakSelf loadData:pnum];
    }];
    myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [myTableView.footer resetNoMoreData];
        pnum++;
        [weakSelf loadData:pnum];
    }];

    // Do any additional setup after loading the view.
}
-(void)segmentClick:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            pnum = 1;
            [self loadData:pnum];
            break;
        case 1:
            pnum = 1;
            [_dataArr removeLastObject];
            [self loadData:pnum];
            break;
        default:
            break;
    }
}
-(void)loadData:(int)start{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSInteger index = mysegment.selectedSegmentIndex;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",start],@"pnum",@"10",@"psize",tel,@"username",[NSString stringWithFormat:@"%ld",(long)(index+1)],@"type",nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];;
        RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_getmyfill", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (start == 1) {
                    [_dataArr removeAllObjects];
                }
                NSArray *arr = [responseObject objectForKey:@"data"];
                if ([arr isKindOfClass:[NSArray class]]&&[arr count]>0) {
                    for (NSDictionary *dict in arr) {
                        MenuOfMyCenterModel *model = [[MenuOfMyCenterModel alloc]initWithDictionary:dict];
                        [_dataArr addObject:model];
                    }
                    
                }
                [myTableView reloadData];
            }
            if ([myTableView.header isRefreshing]) {
                [myTableView.header endRefreshing];
            }
            if ([myTableView.footer isRefreshing]) {
                [myTableView.footer endRefreshing];
            }
        } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
            if ([myTableView.header isRefreshing]) {
                [myTableView.header endRefreshing];
            }
            if ([myTableView.footer isRefreshing]) {
                [myTableView.footer endRefreshing];
            }
            
        }];
        
        [HttpRequestManager doPostOperationWithTask:task];
    [myTableView reloadData];
    [SVProgressHUD showSuccessWithStatus:@"加载完成"];
}
#pragma mark --tableview 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    MenuOfMyCenterModel *model = _dataArr[indexPath.row];
   // CGFloat width = [ToolsClass calculateSizeForText:model.cs_ch :CGSizeMake(1000, 21) font:[UIFont systemFontOfSize:16]].width;
    height = [ToolsClass calculateSizeForText:model.bz :CGSizeMake(CurrentScreenWidth-50, 100) font:[UIFont systemFontOfSize:12]].height+72;
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = mysegment.selectedSegmentIndex;
    static NSString *menuCellID = @"menuCell";
    MenuTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:menuCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuTableViewCell" owner:self options:nil]lastObject];
    }
    MenuOfMyCenterModel *model = _dataArr[indexPath.row];
    [cell showDataFromModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    menuDetailViewController *menu =[[MySharetools shared]getViewControllerWithIdentifier:@"menuDetail" andstoryboardName:@"me"];
    MenuOfMyCenterModel *model = _dataArr[indexPath.row];
    menu.menuModel = model;
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
