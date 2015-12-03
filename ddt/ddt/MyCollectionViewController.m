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
    NSMutableArray *_dataArr;
    NGSearchBar *searchBar;
    int psize;//每页大小
    int pnum;//第几页
     BOOL _isLoved;//是否收藏
    NSMutableArray *_tonghangArr;
}
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarItemWithBackTitle];
    self.title =self.vcType==VcTypeValue_2?@"搜索结果" :@"我的收藏";
    NSArray *segmentArr =self.vcType==VcTypeValue_2?@[@"搜单子",@"搜同行"]: @[@"单子收藏",@"同行好友"];
    
    
    mysegment = [[UISegmentedControl alloc]initWithItems:segmentArr];
        mysegment.frame = CGRectMake(30, 10, CurrentScreenWidth-60, 30);
        [mysegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    mysegment.tintColor= RGBA(76.0, 132.0, 120.0, 1.0);
    mysegment.enabled = YES;
    mysegment.selectedSegmentIndex = 0;
    [self.view addSubview:mysegment];
    _dataArr = [[NSMutableArray alloc]init];
    _tonghangArr = [[NSMutableArray alloc]init];
    searchBar = [[NGSearchBar alloc]initWithFrame:CGRectMake(10, mysegment.bottom+10, CurrentScreenWidth -20 , 30)];
    searchBar.delegate  =self;
    searchBar.placeholder = @"搜索";
    [self.view addSubview:searchBar];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBar.bottom+10, CurrentScreenWidth, CurrentScreenHeight-searchBar.bottom-10-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    myTableView.tableFooterView = [[UIView alloc]init];
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
//    [self addheader:myTableView];
//    [self addfooter:myTableView];
    // Do any additional setup after loading the view.
}
-(void)loadData:(int)start{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",start],@"pnum",@"10",@"psize",tel,@"username",searchBar.text.length > 0?searchBar.text:@"",@"word",nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];;
    NSInteger index = mysegment.selectedSegmentIndex;
    if (index == 0) {
        RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_getbookbill", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"result"] integerValue] ==0) {
                    if (start == 1) {
                        [_dataArr removeAllObjects];
                    }
                    NSArray *arr = [responseObject objectForKey:@"data"];
                    if ([arr isKindOfClass:[NSArray class]]&&[arr count]>0) {
                        [_dataArr addObjectsFromArray:arr];
                        //...没有数据了，不能在刷新加载了
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
        //[myTableView reloadData];
        [HttpRequestManager doPostOperationWithTask:task];
    }else if (index == 1){
        RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_getbookth", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"result"]integerValue] ==0) {
                    if (start == 1) {
                        [_dataArr removeAllObjects];
                    }
                    NSArray *arr = [responseObject objectForKey:@"data"];
                    if ([arr isKindOfClass:[NSArray class]]&&[arr count]>0) {
                        for (NSDictionary *dict in arr) {
                            TonghangSCModel *model = [[TonghangSCModel alloc]initWithDictionary:dict];
                            [_dataArr addObject:model];
                        }
                        [_tonghangArr addObjectsFromArray:arr];
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
       // [myTableView reloadData];
        [HttpRequestManager doPostOperationWithTask:task];
    }
//    else if (index == 2){
//        RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_getbookcom", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                if (start == 1) {
//                    [_dataArr removeAllObjects];
//                }
//                NSArray *arr = [responseObject objectForKey:@"data"];
//                if ([arr isKindOfClass:[NSArray class]]&&[arr count]>0) {
//                    for (NSDictionary *dict in arr) {
//                        CommanySCModel *model = [[CommanySCModel alloc]initWithDictionary:dict];
//                        [_dataArr addObject:model];
//                    }
//                    
//                }
//               [myTableView reloadData];
//            }
//            if ([myTableView.header isRefreshing]) {
//                [myTableView.header endRefreshing];
//            }
//            if ([myTableView.footer isRefreshing]) {
//                [myTableView.footer endRefreshing];
//            }
//        } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
//            if ([myTableView.header isRefreshing]) {
//                [myTableView.header endRefreshing];
//            }
//            if ([myTableView.footer isRefreshing]) {
//                [myTableView.footer endRefreshing];
//            }
//            
//        }];
//        
//        [HttpRequestManager doPostOperationWithTask:task];
//    }
    [myTableView reloadData];
    [SVProgressHUD showSuccessWithStatus:@"加载完成"];
}
#pragma mark --tableview 代理
float _h;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    NSInteger index = mysegment.selectedSegmentIndex;
    switch (index) {
        case 0:
            height = _h + 40 > 80?_h + 40:80;
            break;
        case 1:
        {
            TonghangSCModel *model = _dataArr[indexPath.row];
            height = [ToolsClass calculateSizeForText:model.yewu :CGSizeMake(CurrentScreenWidth-80, 1000) font:Font].height+90;
           // height = 50 + _h > cellDefaultHeight?50 + _h:cellDefaultHeight;
        }
            
            break;
//        case 2:{
//                CommanySCModel *model = _dataArr[indexPath.row];
//                CGFloat width = [ToolsClass calculateSizeForText:model.commany :CGSizeMake(1000, 21) font:[UIFont systemFontOfSize:16]].width;
//                height = [ToolsClass calculateSizeForText:model.yewu :CGSizeMake(CurrentScreenWidth-30-width, 1000) font:Font].height+40;
//        }
//            
//            break;
            
        default:
            break;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSInteger index = mysegment.selectedSegmentIndex;
//    if (index == 0) {
//        return 5;
//    }else if (index == 1){
//        return 5;
//    }else{
        return _dataArr.count;
   // }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = mysegment.selectedSegmentIndex;
    if (index == 0) {
        static NSString *menuCellID = @"JieDanCellReuseId";
        NGJieDanListCell *cell = [myTableView dequeueReusableCellWithIdentifier:menuCellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NGJieDanListCell" owner:self options:nil]lastObject];
        }
        NSDictionary * _dic0 = [_dataArr objectAtIndex:indexPath.row];
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
        TonghangSCModel *model = [_dataArr objectAtIndex:indexPath.row];
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
            vc.danZiInfoDic = [_dataArr objectAtIndex:indexPath.row];
            vc.isLove = YES;
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
        }
            break;
//        case 2:{
//            NGCompanyDetailVC *vc = [[MySharetools shared]getViewControllerWithIdentifier:@"CompanyDetailVC" andstoryboardName:@"companySB"];;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
            
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
    pnum = 1;
    [_dataArr removeAllObjects];
    [self loadData:pnum];
}
#pragma mark -NGSearchBarDelegate
-(void)searchBarWillBeginSearch:(NGSearchBar *)searchBar
{
    NSLog(@"begin");
}

-(void)searchBarDidBeginSearch:(NGSearchBar *)searchBar withStr:(NSString *)str
{
    NSLog(@"did : %@",searchBar.text);
    pnum = 1;
    [_dataArr removeAllObjects];
    [self loadData:pnum];
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
