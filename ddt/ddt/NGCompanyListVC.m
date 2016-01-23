//
//  NGCompanyListVC.m
//  ddt
//
//  Created by wyg on 15/11/10.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGCompanyListVC.h"
#import "NGSearchBar.h"
#import "NGPopListView.h"

#import "NGJieDanDetailVC.h"
#import "NGJieDanListCell.h"

#define cellNoLockBgColor   [UIColor colorWithRed:1.000 green:0.961 blue:0.918 alpha:1]

@interface NGCompanyListVC ()<NGSearchBarDelegate,NGPopListDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //pop view相关
    NGPopListView *popView;
    NSArray * _common_pop_btnTitleArr; //同行-选择按钮的默认标题
    NSArray * _common_pop_btnListArr;//列表数据
    
    //tableview相关
    UITableView     * _tableView;
    NSMutableArray  * _common_list_dataSource;//数据源
    NSString        * _common_list_cellReuseId;//当前复用cellID
    
    CGSize cellMaxFitSize;
    UIFont *cellFitfont;
    NSInteger _pageNum;//请求的页数
    NSInteger _selectRowIndex;
    
    BOOL _isfirstAppear;
    
    //搜搜
    NGSearchBar *_searchBar;
}
//接单
@property(nonatomic,copy)NSString * selectedTime;//选择时间
@end

#import "LoginViewController.h"

@implementation NGCompanyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hasRecNoti) name:@"hasDanziCollectionNoti" object:nil];
}

-(void)hasRecNoti
{
    _isfirstAppear = YES;
}

-(void)awakeFromNib
{
    UIBarButtonItem *_backitem =[ [UIBarButtonItem alloc]init];
    _backitem.title = @"";
    self.navigationItem.backBarButtonItem = _backitem;
}


-(void)initData
{
    //pop
    //btn title
    NSArray *_areaArr = [NGXMLReader getCurrentLocationAreas];//区域
    NSArray *_typeArr = [NGXMLReader getBaseTypeData];//基本业务类型
    NSArray *_btnTitleArr2 = @[@"服务区域",@"业务类型",@"时间"];
    NSArray *time = [DTComDataManger getData_jiedanTime];
    
    if (self.vcType != 2) {
        _selectedArea = @"";
        _selectedType = @"";
    }
    _selectedTime = @"";
    
    _common_pop_btnTitleArr = _btnTitleArr2;
    _common_pop_btnListArr  = @[_areaArr,_typeArr,time];

    //tableview
    cellMaxFitSize = CGSizeMake(CurrentScreenWidth -30, 999);
    cellFitfont = [UIFont systemFontOfSize:15];
    _pageNum = 1;
    _selectRowIndex = 0;
    _isfirstAppear = YES;

    _common_list_dataSource = [[NSMutableArray alloc]init];
    _common_list_cellReuseId = @"JieDanCellReuseId";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([[MySharetools shared]isSessionid]) {
        if (_isfirstAppear) {
            _isfirstAppear = NO;
            [_tableView.header beginRefreshing];
        }
    }
    else
    {
        if ([MySharetools shared].isFirstSignupViewController == YES) {
            [MySharetools shared].isFirstSignupViewController = NO;
            [MySharetools shared].isFromMycenter = YES;
            LoginViewController *login = [[MySharetools shared]getViewControllerWithIdentifier:@"loginView" andstoryboardName:@"me"];
            NGBaseNavigationVC *nav = [[NGBaseNavigationVC alloc]initWithRootViewController:login];
            [self.tabBarController presentViewController:nav animated:YES completion:nil];
        }else{
            self.tabBarController.selectedIndex = 0;
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [popView disappear];
}

#pragma mark- init subviews
-(void)initSubviews
{
    
    popView = [[NGPopListView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, 40) withDelegate:self withSuperView:self.view];
    [self.view addSubview:popView];
    _searchBar = [[NGSearchBar alloc]initWithFrame:CGRectMake(2, popView.frame.origin.y + popView.frame.size.height + 1, CurrentScreenWidth -4 , 30)];
    _searchBar.delegate  =self;
    _searchBar.placeholder = @"请输搜索关键字";
    if (self.searchKey) {
        _searchBar.text = self.searchKey;
    }
    [self.view addSubview:_searchBar];
    
    NSInteger _heightValue = _vcType ==2 ? CurrentScreenHeight -64 -40-30 -2 : CurrentScreenHeight -64-44 -40-30 -2;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchBar.frame.origin.y + _searchBar.frame.size.height, CurrentScreenWidth,_heightValue ) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource  =self;
    [self.view  addSubview:_tableView];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 5, 0)];
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"NGJieDanListCell" bundle:nil] forCellReuseIdentifier:@"JieDanCellReuseId"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [weakSelf loadMoreData];
    }];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer resetNoMoreData];
        [weakSelf loadMoreData];
    }];
}


#pragma mark --加载数据
-(void)loadMoreData
{
    if (_pageNum == NSNotFound) {
        NSLog(@"...page error ");
         _pageNum ==1?({[_tableView.header endRefreshing];}):([_tableView.footer endRefreshing]);
        return;
    }
    
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",tel,@"mobile", _selectedArea?_selectedArea:@"",@"quyu",_selectedType?_selectedType:@"",@"yewu",_searchBar.text.length > 0?_searchBar.text:@"",@"word",_selectedTime,@"time",@"10",@"psize",@(_pageNum),@"pnum",nil];
    NSLog(@".............%ld",_pageNum);
    
    NSDictionary *_d = [MySharetools getParmsForPostWith:dic];
    RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_jiedan", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"]integerValue] ==0) {
                if (_pageNum == 1) {
                   [_tableView.header endRefreshing];
                    [_common_list_dataSource removeAllObjects];
                     [_tableView reloadData];
                }
                else
                {
                    [_tableView.footer endRefreshing];
                }
                
                NSArray *dataarr = [responseObject objectForKey:@"data"];
                if (dataarr && dataarr.count < 10) {
                    //...没有数据了，不能在刷新加载了
                    _pageNum = NSNotFound;
                     [_tableView.footer endRefreshingWithNoMoreData];
                    
                    [_common_list_dataSource addObjectsFromArray:dataarr];
                    [_tableView reloadData];
                }
                else
                {
                    _pageNum++;
                }
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                [_tableView.footer endRefreshingWithNoMoreData];
            }
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        _pageNum ==1?({[_tableView.header endRefreshing];}):([_tableView.footer endRefreshing]);
        [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
    }];
    
    [HttpRequestManager doPostOperationWithTask:task];
}


#pragma mark - NGPopListDelegate
-(NSInteger)numberOfSectionInPopView:(NGPopListView *)poplistview
{
    return _common_pop_btnTitleArr?_common_pop_btnTitleArr.count:0;
}

-(NSString *)titleOfSectionInPopView:(NGPopListView *)poplistview atIndex:(NSInteger)index
{
    return [_common_pop_btnTitleArr objectAtIndex:index];
}

//第一个列表显示的数据源,NSArray类型
-(NSArray*)dataSourceOfPoplistviewWithIndex:(NSInteger)index
{
    return [_common_pop_btnListArr objectAtIndex:index];
}

-(NSInteger)popListView:(NGPopListView *)popListView numberOfRowsWithIndex:(NSInteger)index
{
    return ((NSArray*)[_common_pop_btnListArr objectAtIndex:index]).count;
}


-(void)popListView:(NGPopListView *)popListView  didSelected:(NSString *)str withIndex:(NSInteger)index
{
    //...请求网络
    _pageNum = 1;
    if (index == 1) {
        _selectedArea = str;
    }
    else if(index ==2)
    {
        _selectedType = str;
    }
   else if (index ==3)
    {
        NSArray *_arr = @[@"全部",@"今天",@"最近3天",@"最近7天",@"最近30天"];
        [_arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([(NSString *)obj isEqualToString:str]) {
                if (idx==0) {
                    _selectedTime = @"";
                }
                else if (idx ==1)
                {
                    _selectedTime = @"1";
                }
                else if (idx ==2)
                {
                    _selectedTime = @"3";
                }
                else if (idx ==31)
                {
                    _selectedTime = @"7";
                }
                else if (idx ==4)
                {
                    _selectedTime = @"30";
                }
            }
        }];
    }
    
    [_tableView.header beginRefreshing];
}


#pragma mark -NGSearchBarDelegate
-(void)searchBarWillBeginSearch:(NGSearchBar *)searchBar
{
    _pageNum  =1;
    NSLog(@"begin");
}

-(void)searchBarDidBeginSearch:(NGSearchBar *)searchBar withStr:(NSString *)str
{
    if (searchBar.text.length > 0) {
          [self loadMoreData];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"输入搜索关键字"];
    }
}


float _h;

#pragma mark --UItableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _common_list_dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGJieDanListCell * cell;
    NSDictionary *_dic0 = [_common_list_dataSource objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:_common_list_cellReuseId forIndexPath:indexPath];
    BOOL _b = [[_dic0 objectForKey:@"zt"] boolValue];
    if (_b) {
        cell.backgroundColor = [UIColor clearColor];
    }
    else
    {
        cell.backgroundColor = cellNoLockBgColor;
    }
    
    NSString * str = [_dic0 objectForKey:@"bz"];
    CGSize _new =  [ToolsClass calculateSizeForText:str :cellMaxFitSize font:cellFitfont];
    NGJieDanListCell *cell1 = (NGJieDanListCell *)cell;
    CGRect rec = cell1.nameLab.frame;
    rec.size.height = _new.height+10;
    cell1.nameLab.frame = rec;
    _h = _new.height + 20;
    
    [(NGJieDanListCell *)cell setCellWith:_dic0];

    return cell;
}

//const float cellDefaultHeight = 60.0;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return _h + 40 > 80?_h + 40:80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"homeSB" bundle:nil];
    NGJieDanDetailVC* vc=  [sb instantiateViewControllerWithIdentifier:@"NGJieDanDetailVCID"];
    vc.danZiInfoDic = [_common_list_dataSource objectAtIndex:indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isLove = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_pageNum != NSNotFound && indexPath.row == _common_list_dataSource.count - 1) {
//        _pageNum++;
//        [_tableView.footer beginRefreshing];
//        [self loadMoreData];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
