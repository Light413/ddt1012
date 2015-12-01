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
    
    NSMutableArray *_common_dataArr;//公共数据源
    NSMutableArray *_tableview1_dataArr;
    NSMutableArray *_tableview2_dataArr;

    NSInteger   _common_current_pageNum;//which page;
    NSInteger   _tableview1_current_pageNum;
    NSInteger   _tableview2_current_pageNum;
    
    MJRefreshState _tableview1_footerStatus;
    MJRefreshState _tableview2_footerStatus;
    
    CGSize cellMaxFitSize;
    UIFont *cellFitfont;
    
    BOOL _isfirst;//YES
}
@end



static NSString * JieDanCellReuseId = @"JieDanCellReuseId";

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.title = @"我的单子";
    [self createLeftBarItemWithBackTitle];
    NSArray *segmentArr = @[@"接过的单子",@"甩过的单子"];
    mysegment = [[UISegmentedControl alloc]initWithItems:segmentArr];
    mysegment.frame = CGRectMake(30, 10, CurrentScreenWidth-60, 30);
    [mysegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    mysegment.tintColor= RGBA(76.0, 132.0, 120.0, 1.0);
    mysegment.enabled = YES;
    mysegment.selectedSegmentIndex = 0;
    [self.view addSubview:mysegment];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mysegment.bottom+5, CurrentScreenWidth, CurrentScreenHeight-mysegment.bottom-10-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc]init];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    [myTableView registerNib:[UINib nibWithNibName:@"NGJieDanListCell" bundle:nil] forCellReuseIdentifier:JieDanCellReuseId];
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _common_current_pageNum = 1;
        [weakSelf loadData:_common_current_pageNum];
    }];
    myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [myTableView.footer resetNoMoreData];
        [weakSelf loadData:_common_current_pageNum];
    }];
}

-(void)goback:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isfirst && mysegment.selectedSegmentIndex == 0) {
        _isfirst = NO;
        [myTableView.header beginRefreshing];
    }
}

-(void)initData
{
    cellMaxFitSize = CGSizeMake(CurrentScreenWidth -30, 999);
    cellFitfont = [UIFont systemFontOfSize:14];
    
    _common_dataArr = [[NSMutableArray alloc]init];
    _tableview1_dataArr = [[NSMutableArray alloc]init];
    _tableview2_dataArr = [[NSMutableArray alloc]init];
    
    _common_current_pageNum = 1;
    _tableview1_current_pageNum = 1;
    _tableview2_current_pageNum = 1;
    
    _tableview1_footerStatus =MJRefreshStateIdle;
    _tableview2_footerStatus = MJRefreshStateIdle;
    
    _isfirst = YES;
}

//数据交换操作
-(void)setDataToCommon:(NSInteger)index
{
    _common_current_pageNum = 1;
    [_common_dataArr removeAllObjects];
    if (index ==0) {
        _common_current_pageNum = _tableview1_current_pageNum;
        if (_tableview1_dataArr && _tableview1_dataArr.count > 0) {
            [_common_dataArr addObjectsFromArray:_tableview1_dataArr];
        }
        
        if (_tableview1_footerStatus == MJRefreshStateIdle) {
            [myTableView.footer resetNoMoreData];
        }
        else if (_tableview1_footerStatus == MJRefreshStateNoMoreData)
        {
            [myTableView.footer endRefreshingWithNoMoreData];
        }
    }
    else if (index ==1)
    {
      _common_current_pageNum = _tableview2_current_pageNum;
        if (_tableview2_dataArr && _tableview2_dataArr.count > 0) {
            [_common_dataArr addObjectsFromArray:_tableview2_dataArr];
        }
        if (_tableview2_footerStatus == MJRefreshStateIdle) {
            [myTableView.footer resetNoMoreData];
        }
        else if (_tableview2_footerStatus == MJRefreshStateNoMoreData)
        {
            [myTableView.footer endRefreshingWithNoMoreData];
        }
    }
}

-(void)getDataFromCommon:(NSInteger)index
{
    if (index ==0) {
        _tableview1_footerStatus = myTableView.footer.state;
       _tableview1_current_pageNum = _common_current_pageNum ;
        if (_common_dataArr && _common_dataArr.count > 0) {
            [_tableview1_dataArr removeAllObjects];
            [_tableview1_dataArr addObjectsFromArray:_common_dataArr];
        }
    }
    else if (index ==1)
    {
        _tableview2_footerStatus = myTableView.footer.state;
        _tableview2_current_pageNum = _common_current_pageNum ;
        if (_common_dataArr && _common_dataArr.count > 0) {
            [_tableview2_dataArr removeAllObjects];
            [_tableview2_dataArr addObjectsFromArray:_common_dataArr];
        }
    }
}


-(void)segmentClick:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    [self setDataToCommon:index];
    
    if (_common_current_pageNum ==1) {
        [_common_dataArr removeAllObjects];
        [myTableView reloadData];
        [myTableView.header beginRefreshing];
    }
    else
    {
        [myTableView reloadData];
    }
}

-(void)loadData:(NSInteger)start
{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSInteger index = mysegment.selectedSegmentIndex;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",start],@"pnum",@"10",@"psize",tel,@"username",[NSString stringWithFormat:@"%ld",(long)(index+1)],@"type",nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];;
        RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_getmyfill", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                [SVProgressHUD showSuccessWithStatus:@"加载完成"];
                if ([[responseObject objectForKey:@"result"] integerValue] ==0) {
                    if (start == 1) {[_common_dataArr removeAllObjects];}
                    NSArray *arr = [responseObject objectForKey:@"data"];
                    if ([arr isKindOfClass:[NSArray class]]&&[arr count]>0) {
                        [_common_dataArr addObjectsFromArray:arr];
                        //...没有数据了，不能在刷新加载了
                        if (arr && arr.count < 10)
                        {
                            _common_current_pageNum = NSNotFound;
                            [myTableView.footer endRefreshingWithNoMoreData];
                        }
                    }
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                    [myTableView.footer endRefreshingWithNoMoreData];
                }
                [myTableView reloadData];
                [self getDataFromCommon:index];
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
    return _common_dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NGJieDanListCell * cell =  [tableView dequeueReusableCellWithIdentifier:JieDanCellReuseId forIndexPath:indexPath];
    NSDictionary * _dic0 = [_common_dataArr objectAtIndex:indexPath.row];
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
    vc.danZiInfoDic = [_common_dataArr objectAtIndex:indexPath.row];
    vc.isLove = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_common_current_pageNum != NSNotFound && indexPath.row == _common_dataArr.count - 1) {
        _common_current_pageNum++;
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
