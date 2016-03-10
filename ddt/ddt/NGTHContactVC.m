//
//  NGTHContactVC.m
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGTHContactVC.h"
#import "NGTHContactCell.h"
#import "NGContactDetaillVC.h"
#import "ReleaseMeetingViewController.h"

@interface NGTHContactVC ()
{
    NSMutableArray *_dataArray;
    NSInteger _pageNum;//请求的页数
    NSInteger _selectedRow;
    BOOL _isfirst;
}
@end

static NSString * thcontactCellReuseId = @"thcontactCellReuseId";

@implementation NGTHContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isfirst = YES;
    _selectedRow = -1;
    
    // Do any additional setup after loading the view.
    [self initSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isfirst) {
        _isfirst = NO;
        [self.tableView.header beginRefreshing];
    }
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
}

-(void)initSubviews
{
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setContentInset:UIEdgeInsetsMake(5, 0, 0, 0)];
    
    _dataArray = [[NSMutableArray alloc]init];
    _pageNum = 1;
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"我要发布" style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClick)];
    [rightitem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightitem;
    
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [weakSelf loadMoreData];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.tableView.footer resetNoMoreData];
        [weakSelf loadMoreData];
    }];
}

//
#pragma mark --加载数据
-(void)loadMoreData
{
    NetIsReachable;
    if (_pageNum == NSNotFound) {
        NSLog(@"...page error ");
        return;
    }

//    NSString *tel = [[MySharetools shared]getPhoneNumber];
//    NSDate *localDate = [NSDate date]; //获取当前时间
//    NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
//    NSString *token = [NSString stringWithFormat:@"%@(!)*^*%@",tel,timeString];

  NSDictionary*  _common_list_request_parm = [NSDictionary dictionaryWithObjectsAndKeys: @"",@"quyu",@"",@"yewu",@"10",@"psize",@(1),@"pnum",@"",@"word",nil];
    NSDictionary *_d = [MySharetools getParmsForPostWith:_common_list_request_parm withToken:YES];
    
    RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_jiaoliuhui", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        _pageNum ==1?({[self.tableView.header endRefreshing];[_dataArray removeAllObjects];
            [self.tableView reloadData];}):([self.tableView.footer endRefreshing]);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"]integerValue] ==0) {
                NSArray *dataarr = [responseObject objectForKey:@"data"];
                if (dataarr) {
                    //...没有数据了，不能在刷新加载了
                    if (dataarr.count < 10)
                    {
                        _pageNum = NSNotFound;
                        [self.tableView.footer endRefreshingWithNoMoreData];
                    }
                    [_dataArray addObjectsFromArray:dataarr];
                    [self.tableView reloadData];
                }
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                [self.tableView.footer endRefreshingWithNoMoreData];
            }
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
        _pageNum ==1?({[self.tableView.header endRefreshing];}):([self.tableView.footer endRefreshing]);
    }];
    
    [HttpRequestManager doPostOperationWithTask:task];
}


#pragma mark --发布交流会
-(void)rightItemClick
{
    //检测是否登录
    if (![[MySharetools shared]hasSuccessLogin]) {
        return;
    }
    
    ReleaseMeetingViewController *meeting = [[MySharetools shared]getViewControllerWithIdentifier:@"ReleaseMeeting" andstoryboardName:@"me"];
    meeting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:meeting animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NGTHContactCell *cell = [tableView dequeueReusableCellWithIdentifier:thcontactCellReuseId forIndexPath:indexPath];
     NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
     [cell setCellWith:dic];
 
     return cell;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"showContactDetailID" sender:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_pageNum != NSNotFound && indexPath.row == _dataArray.count - 1) {
        _pageNum++;
        [self.tableView.footer beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showContactDetailID"]) {
        NGContactDetaillVC *vc = [segue destinationViewController];
        if (_selectedRow > -1) {
           vc.dic = [_dataArray objectAtIndex:_selectedRow]; 
        }
    }
}


@end
