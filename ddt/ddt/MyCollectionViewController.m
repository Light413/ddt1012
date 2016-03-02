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
#import "NGTongHDetailVC.h"
#import "NGCompanyDetailVC.h"
#import "MemuSCModel.h"
#import "CommanySCModel.h"
#import "NGJieDanListCell.h"
#import "NGJieDanDetailVC.h"
#import "NGSecondListCell.h"
#import "TonghangSCModel.h"

#define Font    [UIFont systemFontOfSize:14]
#define Size    CGSizeMake(CurrentScreenWidth - 50, 1000)
#define cellDefaultHeight  80.0

@interface MyCollectionViewController ()<NGSearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    UISegmentedControl *mysegment;
    
    NSMutableArray *_tableview1_dataArr;//公共数据源
    NSMutableArray *_tableview2_dataModel_Arr;//公共数据源
    
    NSInteger   _common_current_pageNum;//which page;
    NSInteger   _tableview1_current_pageNum;
    NSInteger   _tableview2_current_pageNum;
    
    NSString * _common_url;
    
    MJRefreshState _tableview1_footerStatus;
    MJRefreshState _tableview2_footerStatus;
    
    NGSearchBar *_searchBar;
    NSString *_search_key_word1;//搜索关键字
    NSString *_search_key_word2;//搜索关键字
    
    int psize;//每页大小
    BOOL _isLoved;//是否收藏
     BOOL _isfirst;//YES
    
    NSMutableArray *_tonghangArr;
}
@end

@implementation MyCollectionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isfirst && mysegment.selectedSegmentIndex == 0) {
        _isfirst = NO;
        [myTableView.header beginRefreshing];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarItemWithBackTitle];
    self.title =self.vcType==VcTypeValue_2?@"搜索结果" :@"我的收藏";
    NSArray *segmentArr =self.vcType==VcTypeValue_2?@[@"搜单子",@"搜同行"]: @[@"单子收藏",@"同行好友"];
    [self initData];
    
    mysegment = [[UISegmentedControl alloc]initWithItems:segmentArr];
    mysegment.frame = CGRectMake(30, 15, CurrentScreenWidth-60, 30);
    [mysegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    mysegment.tintColor= RGBA(76.0, 132.0, 120.0, 1.0);
    mysegment.enabled = YES;
    mysegment.selectedSegmentIndex = 0;
    [self.view addSubview:mysegment];
    
    _searchBar = [[NGSearchBar alloc]initWithFrame:CGRectMake(10, mysegment.bottom+10, CurrentScreenWidth -20 , 30)];
    _searchBar.delegate  =self;
    _searchBar.placeholder = @"请输入搜索关键字";
    if (self.searchKeyWord) {
        _searchBar.text = self.searchKeyWord;
    }
    [self.view addSubview:_searchBar];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchBar.bottom+2, CurrentScreenWidth, CurrentScreenHeight-_searchBar.bottom-2-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    myTableView.tableFooterView = [[UIView alloc]init];

    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _common_current_pageNum = 1;
        [weakSelf loadData:_common_current_pageNum];
    }];
    myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [myTableView.footer resetNoMoreData];
        _common_current_pageNum++;
        [weakSelf loadData:_common_current_pageNum];
    }];
}

-(void)initData
{
    _tableview1_dataArr = [[NSMutableArray alloc]init];
    _tableview2_dataModel_Arr = [[NSMutableArray alloc]init];
    _tonghangArr = [[NSMutableArray alloc]init];
    _isfirst = YES;
    
    _common_current_pageNum = 1;
    _tableview1_current_pageNum = 1;
    _tableview2_current_pageNum = 1;
    
    if (self.searchKeyWord) {
        _search_key_word1 = self.searchKeyWord;
        _search_key_word2 = self.searchKeyWord;
    }
    else
    {
        _search_key_word1 = @"";
        _search_key_word2 = @"";
    }
}

-(NSDictionary*)getParmsForRequest:(NSInteger)start
{
    NSDictionary *dic ;
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    if (self.vcType ==2) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",tel,@"mobile", @"",@"quyu",@"",@"yewu",_searchBar.text.length > 0?_searchBar.text:@"",@"word",@"",@"time",@"10",@"psize",@(start),@"pnum",nil];

    }
    else
    {
       dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",start],@"pnum",@"10",@"psize",tel,@"username",_searchBar.text.length > 0?_searchBar.text:@"",@"word",nil];
    }
    
    return [MySharetools getParmsForPostWith:dic];
}


-(void)loadData:(NSInteger)start{
    if (_common_current_pageNum > 100) { return;}
    
    NSDictionary *paramDict = [self getParmsForRequest:start];
    NSInteger index = mysegment.selectedSegmentIndex;
    if (index == 0) {
        RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:self.vcType ==2?NSLocalizedString(@"url_jiedan", @""): NSLocalizedString(@"url_getbookbill", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"result"] integerValue] ==0) {
                    if (start == 1) {
                        [_tableview1_dataArr removeAllObjects];
                    }
                    NSArray *arr = [responseObject objectForKey:@"data"];
                    if ([arr isKindOfClass:[NSArray class]]&&[arr count]>0) {
                        [_tableview1_dataArr addObjectsFromArray:arr];
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
                    _common_current_pageNum = NSNotFound;
                    [myTableView.footer endRefreshingWithNoMoreData];
                }
                
                [self getDataFromCommon:index];
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
    }else if (index == 1){
        RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:self.vcType ==2?NSLocalizedString(@"url_tongh_list", @""): NSLocalizedString(@"url_getbookth", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"result"]integerValue] ==0) {
                    if (start == 1) {
                        [_tableview2_dataModel_Arr removeAllObjects];
                        [_tonghangArr removeAllObjects];
                    }
                    NSArray *arr = [responseObject objectForKey:@"data"];
                    if ([arr isKindOfClass:[NSArray class]]&&[arr count]>0) {
                        for (NSDictionary *dict in arr) {
                            TonghangSCModel *model = [[TonghangSCModel alloc]initWithDictionary:dict];
                            [_tableview2_dataModel_Arr addObject:model];
                        }
                        [_tonghangArr addObjectsFromArray:arr];
                        
                        if (arr && arr.count < 10)
                        {
                            _common_current_pageNum = NSNotFound;
                            [myTableView.footer endRefreshingWithNoMoreData];
                        }
                    }
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:@"没有数据了"];
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
    
}


#pragma mark --tableview 代理
float _h;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    NSInteger index = mysegment.selectedSegmentIndex;
    switch (index) {
        case 0:
            height = _h + 40 > 90?_h + 40:90;
            break;
        case 1:
        {
            TonghangSCModel *model = _tableview2_dataModel_Arr[indexPath.row];
            height = [ToolsClass calculateSizeForText:model.yewu :CGSizeMake(CurrentScreenWidth-80, 1000) font:Font].height+90;
        }break;
            
        default: break;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger index = mysegment.selectedSegmentIndex;
    return index==0? _tableview1_dataArr.count:_tableview2_dataModel_Arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = mysegment.selectedSegmentIndex;
    if (index == 0) {
        static NSString *menuCellID = @"JieDanCellReuseId";
        NGJieDanListCell *cell = [myTableView dequeueReusableCellWithIdentifier:menuCellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NGJieDanListCell" owner:self options:nil]lastObject];
        }
        NSDictionary * _dic0 = [_tableview1_dataArr objectAtIndex:indexPath.row];
        NSString * str = [_dic0 objectForKey:@"bz"];
        CGSize _new =  [ToolsClass calculateSizeForText:str :CGSizeMake(CurrentScreenWidth -30, 999) font:[UIFont systemFontOfSize:14]];
        NGJieDanListCell *cell1 = (NGJieDanListCell *)cell;
        CGRect rec = cell1.nameLab.frame;
        rec.size.height = _new.height+10;
        cell1.nameLab.frame = rec;
        _h = _new.height + 10;
        
        [(NGJieDanListCell *)cell setCellWith:_dic0];
        return cell;
    }else if (index == 1) {
        static NSString *cellID = @"tonghangSCcellID";
        TonghangTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TonghangTableViewCell" owner:self options:nil]lastObject];
        }
        TonghangSCModel *model = [_tableview2_dataModel_Arr objectAtIndex:indexPath.row];
        [cell showDataFromModel:model];
        cell.btnClickBlock = ^{
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.mobile]]];
        };
        cell.btnmessageClickBlock = ^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",model.mobile]]];
        };
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
            NGJieDanDetailVC* vc= [[MySharetools shared]getViewControllerWithIdentifier:@"NGJieDanDetailVCID" andstoryboardName:@"homeSB"];
            vc.danZiInfoDic = [_tableview1_dataArr objectAtIndex:indexPath.row];
            vc.isLove = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            NGTongHDetailVC *vc = [[MySharetools shared]getViewControllerWithIdentifier:@"TongHDetailVC" andstoryboardName:@"secondSB"];
            NSDictionary *_dic0 = [_tonghangArr objectAtIndex:indexPath.row];
            vc.personInfoDic = _dic0;
            NSString *islove = [_dic0 objectForKey:@"isbook"];
            vc.isLoved = [islove boolValue];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            
        default:break;
    }
}

//cell delete
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.vcType ==2) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = mysegment.selectedSegmentIndex;
    NSString *_uid = nil;
    NSInteger _type = 0;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (index ==0) {
            NSDictionary *_dic = [_tableview1_dataArr objectAtIndex:indexPath.row];
            _uid = [_dic objectForKey:@"id"];
            _type = 3;
        }
        else
        {
            NSDictionary *_dic = [_tonghangArr objectAtIndex:indexPath.row];
            _uid = [_dic objectForKey:@"uid"];
            _type = 1;
        }
        
        //请求网络
        NSString *tel = [[MySharetools shared]getPhoneNumber];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",tel,@"mobile",@(_type),@"type",_uid,@"id", nil];
        NSDictionary *_d1 = [MySharetools getParmsForPostWith:dic];
        
        [SVProgressHUD showWithStatus:@"取消收藏"];
        NSString *_url =NSLocalizedString(@"url_my_nolove", @"");
        RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:_url parms:_d1 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if (index ==0) {
                [_tableview1_dataArr removeObjectAtIndex:indexPath.row];
            }
            else
            {
                [_tableview2_dataModel_Arr removeObjectAtIndex:indexPath.row];
                [_tonghangArr removeObjectAtIndex:indexPath.row];
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        }];
        [HttpRequestManager doPostOperationWithTask:_task];
    }
}



//...no use
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

#pragma mark -- UISegmentedControl 操作相关
-(void)setDataToCommon : (NSInteger)index
{
    _common_current_pageNum = 1;
    if (index ==0) {
        _common_current_pageNum = _tableview1_current_pageNum;
        _searchBar.text = _search_key_word1;
        if (_tableview1_footerStatus == MJRefreshStateIdle) {
            [myTableView.footer resetNoMoreData];
        }
        else if (_tableview1_footerStatus == MJRefreshStateNoMoreData)
        {
            [myTableView.footer endRefreshingWithNoMoreData];
        }
    }
    else
    {
        _common_current_pageNum = _tableview2_current_pageNum;
        _searchBar.text = _search_key_word2;
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
    }
    else if (index ==1)
    {
        _tableview2_footerStatus = myTableView.footer.state;
        _tableview2_current_pageNum = _common_current_pageNum ;
    }
}


-(void)segmentClick:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    [self setDataToCommon:index];
    
    if (_common_current_pageNum ==1) {
        if (index ==0) {
         [_tableview1_dataArr removeAllObjects];
        }
        else
        {
            [_tableview2_dataModel_Arr removeAllObjects];
            [_tonghangArr removeAllObjects];
        }
        [myTableView reloadData];
        [myTableView.header beginRefreshing];
    }
    else
    {
        [myTableView reloadData];
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
    NSInteger index = mysegment.selectedSegmentIndex;
    if (index ==0) {
        _search_key_word1 = searchBar.text;
    }
    else
    {
        _search_key_word2 = searchBar.text;
    }
    [myTableView.header beginRefreshing];
}


//...other
-(void)goback:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
