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
#import "AddCommanyInfoViewController.h"
#import "NGCompanyDetailVC.h"

#import "NGSecondListCell.h"
#import "DTCompanyListCell.h"

static NSString * showTongHangVcID  = @"showTongHangVcID";
static NSString * showCompanyVcID   = @"showCompanyVcID";
static NSString * NGCompanyListCellReuseId = @"NGCompanyListCellReuseId";


@interface NGCompanyListVC ()<NGSearchBarDelegate,NGPopListDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //pop view相关
    NGPopListView *popView;
    NSArray * _common_pop_btnTitleArr; //同行-选择按钮的默认标题
    NSArray * _common_pop_btnListArr;//列表数据
    
    //tableview相关
    UITableView     * _tableView;
    NSMutableArray  * _common_list_dataSource;//数据源
    NSArray         * _common_cellId_arr;//复用cell ID
    NSString        * _common_list_cellReuseId;//当前复用cellID
    NSString        * _common_list_cellClassStr;//当前cell class
    
    CGSize cellMaxFitSize;
    UIFont *cellFitfont;
    NSInteger _pageNum;//请求的页数
    NSInteger _selectRowIndex;
    
    BOOL _isfirstAppear;
}
@end

@implementation NGCompanyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
}

-(void)awakeFromNib
{
    UIBarButtonItem *_backitem =[ [UIBarButtonItem alloc]init];
    _backitem.title = @"";
    self.navigationItem.backBarButtonItem = _backitem;
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"添加公司" style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClick)];

    self.navigationItem.rightBarButtonItem = rightitem;
}
#pragma mark --添加公司
-(void)rightItemClick
{
    AddCommanyInfoViewController *commany = [[MySharetools shared]getViewControllerWithIdentifier:@"AddCommany" andstoryboardName:@"me"];
    commany.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commany animated:YES];
}


-(void)initData
{
    //pop
    NSInteger _index = self.tabBarController.selectedIndex;
    if (_index == 2)
    {
        self.vcType = NGVCTypeId_2;
    }
    
    //btn title
    NSArray *_areaArr = [NGXMLReader getCurrentLocationAreas];//区域
    NSArray *_typeArr = [NGXMLReader getBaseTypeData];//基本业务类型
    switch (self.vcType) {
        case NGVCTypeId_2:
        {//公司
            NSArray *_btnTitleArr2 = @[@"服务区域",@"业务类型"];
            _common_pop_btnTitleArr = _btnTitleArr2;
            _common_pop_btnListArr  = @[_areaArr,_typeArr];
            
        } break;
            
        default: break;
    }
    cellMaxFitSize = CGSizeMake(CurrentScreenWidth -100, 999);
    cellFitfont = [UIFont systemFontOfSize:15];
    _pageNum = 1;
    _selectRowIndex = 0;
    _isfirstAppear = YES;
    
    //....此处获取tableview的数据源
    //...test   tableview
    _common_list_dataSource = [[NSMutableArray alloc]init];
    _common_cellId_arr = @[NGCompanyListCellReuseId,NGCompanyListCellReuseId];
    _common_list_cellReuseId = [_common_cellId_arr objectAtIndex:self.vcType - 1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isfirstAppear) {
        _isfirstAppear = NO;
        [_tableView.header beginRefreshing];
    }
}

#pragma mark- init subviews
-(void)initSubviews
{
    self.title = @"贷款公司名片";
    
    popView = [[NGPopListView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, 40) withDelegate:self withSuperView:self.view];
    [self.view addSubview:popView];
    NGSearchBar *searchBar = [[NGSearchBar alloc]initWithFrame:CGRectMake(2, popView.frame.origin.y + popView.frame.size.height + 1, CurrentScreenWidth -4 , 30)];
    searchBar.delegate  =self;
    searchBar.placeholder = @"请输入搜索关键字";
    [self.view addSubview:searchBar];
    
    NSInteger _heightValue = _vcType > 2 ? CurrentScreenHeight -64 -40-30 -2 : CurrentScreenHeight -64-44 -40-30 -2;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height, CurrentScreenWidth,_heightValue ) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource  =self;
    [self.view  addSubview:_tableView];
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 5, 0)];
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"DTCompanyListCell" bundle:nil] forCellReuseIdentifier:NGCompanyListCellReuseId];
    
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    
}


#pragma mark --加载数据
-(void)loadMoreData
{
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username", @"",@"quye",@"",@"yewu",@"10",@"psize",@"1",@"pnum",@"",@"word",nil];
    NSDictionary *_d = [MySharetools getParmsForPostWith:dic];
    RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_company_list", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        _pageNum ==1?({[_tableView.header endRefreshing];[_common_list_dataSource removeAllObjects];}):([_tableView.footer endRefreshing]);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"]integerValue] ==0) {
                //...请求数据成功
                NSArray *dataarr = [responseObject objectForKey:@"data"];
                if (dataarr && dataarr.count < 10) {
                    //...没有数据了，不能在刷新加载了
                    [_common_list_dataSource addObjectsFromArray:dataarr];
                    
                    [_tableView reloadData];
                }
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"请求数据出现错误"];
            }
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
        _pageNum ==1?({[_tableView.header endRefreshing];}):([_tableView.footer endRefreshing]);
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


-(void)popListView:(NGPopListView *)popListView  didSelectRowAtIndex:(NSInteger )index
{
    //...请求网络
    
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


float _h;

#pragma mark --UItableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _common_list_dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTCompanyListCell * cell;
    NSDictionary *_dic0 = [_common_list_dataSource objectAtIndex:indexPath.row];
    
    switch (self.vcType) {
        case NGVCTypeId_2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:_common_list_cellReuseId forIndexPath:indexPath];
            NSString * str = [_dic0 objectForKey:@"4"];
            CGSize _new =  [ToolsClass calculateSizeForText:str :cellMaxFitSize font:cellFitfont];
            
            CGRect rec = cell.distructionLab.frame;
            rec.size.height = _new.height;
            cell.distructionLab.frame = rec;
            _h = _new.height;
            
            [(DTCompanyListCell *)cell setCellWith:_dic0];
            
            ((DTCompanyListCell *)cell).btnClickBlock = ^(NSInteger tag){
                NSLog(@"...cell btn click : %ld",tag);
            };
        }break;
            
        default:break;
    }
 
    return cell;
}

const float cellDefaultHeight = 60.0;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.vcType) {
        case NGVCTypeId_2:
        {
//            NSDictionary *_dic0 = [_common_list_dataSource objectAtIndex:indexPath.row];
//            NSString * str = [_dic0 objectForKey:@"4"];
//            CGSize _size = CGSizeMake(CurrentScreenWidth -100, 999);
//            UIFont *font = [UIFont systemFontOfSize:15];
//            CGSize _new =  [ToolsClass calculateSizeForText:str :_size font:font];
//            
            return 30 + _h > cellDefaultHeight?30 + _h:cellDefaultHeight;
        }break;
            
        default:
            break;
    }
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectRowIndex = indexPath.row;
    switch (self.vcType) {
        case NGVCTypeId_2:
        {
            [self performSegueWithIdentifier:showCompanyVcID sender:nil];
        }break;
        default: break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _common_list_dataSource.count - 1) {
//        [self loadMoreData];
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
    if([segue.identifier isEqualToString:showCompanyVcID])
    {
        NGCompanyDetailVC *vc =[segue destinationViewController];
        vc.companyInfoDic = [_common_list_dataSource objectAtIndex:_selectRowIndex];
    }
}


@end
