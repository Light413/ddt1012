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


#import "NGJieDanDetailVC.h"
#import "NGJieDanListCell.h"

@interface MyListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl *mysegment;
    UITableView *myTableView;
    NSInteger pnum;//which page;
    NSMutableArray *_dataArr;
    
    CGSize cellMaxFitSize;
    UIFont *cellFitfont;
}
@end



static NSString * JieDanCellReuseId = @"JieDanCellReuseId";

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    self.title = @"我的单子";
    _dataArr = [[NSMutableArray alloc]init];
    NSArray *segmentArr = @[@"接过的单子",@"甩过的单子"];
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
    myTableView.tableFooterView = [[UIView alloc]init];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    [myTableView registerNib:[UINib nibWithNibName:@"NGJieDanListCell" bundle:nil] forCellReuseIdentifier:JieDanCellReuseId];
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

    pnum = 1;
    [self loadData:pnum];
}

-(void)initData
{
    cellMaxFitSize = CGSizeMake(CurrentScreenWidth -30, 999);
    cellFitfont = [UIFont systemFontOfSize:14];
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

-(void)loadData:(NSInteger)start{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSInteger index = mysegment.selectedSegmentIndex;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",start],@"pnum",@"10",@"psize",tel,@"username",[NSString stringWithFormat:@"%ld",(long)(index+1)],@"type",nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];;
        RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_getmyfill", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    [SVProgressHUD showSuccessWithStatus:@"加载完成"];
                if (start == 1) {
                    [_dataArr removeAllObjects];
                }
                NSArray *arr = [responseObject objectForKey:@"data"];
                if ([arr isKindOfClass:[NSArray class]]&&[arr count]>0) {
                    [_dataArr addObjectsFromArray:arr];
                    //...没有数据了，不能在刷新加载了
                    if (arr && arr.count < 10)
                    {
                        pnum = NSNotFound;
                        [myTableView.footer endRefreshingWithNoMoreData];
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
}


#pragma mark --tableview 代理

float _h;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _h + 40 > 80?_h + 40:80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   NGJieDanListCell * cell =  [tableView dequeueReusableCellWithIdentifier:JieDanCellReuseId forIndexPath:indexPath];
    NSDictionary * _dic0 = [_dataArr objectAtIndex:indexPath.row];
    NSString * str = [_dic0 objectForKey:@"bz"];
    CGSize _new =  [ToolsClass calculateSizeForText:str :cellMaxFitSize font:cellFitfont];
    NGJieDanListCell *cell1 = (NGJieDanListCell *)cell;
    CGRect rec = cell1.nameLab.frame;
    rec.size.height = _new.height+10;
    cell1.nameLab.frame = rec;
    _h = _new.height + 10;
    
    [(NGJieDanListCell *)cell setCellWith:_dic0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    menuDetailViewController *menu =[[MySharetools shared]getViewControllerWithIdentifier:@"menuDetail" andstoryboardName:@"me"];
//    MenuOfMyCenterModel *model = _dataArr[indexPath.row];
//    menu.menuModel = model;
//    menu.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:menu animated:YES];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"homeSB" bundle:nil];
    NGJieDanDetailVC* vc=  [sb instantiateViewControllerWithIdentifier:@"NGJieDanDetailVCID"];
    vc.danZiInfoDic = [_dataArr objectAtIndex:indexPath.row];
    vc.isLove = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (pnum != NSNotFound && indexPath.row == _dataArr.count - 1) {
        pnum++;
        [myTableView.footer beginRefreshing];
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
