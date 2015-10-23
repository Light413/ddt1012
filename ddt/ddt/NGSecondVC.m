//
//  NGSecondVC.m
//  ddt
//
//  Created by gener on 15/10/13.
//  Copyright (c) 2015年 Light. All rights reserved.
//
//NGVCTypeId_1  同行Id
//NGVCTypeId_2  公司Id
//NGVCTypeId_3  附近同行
//NGVCTypeId_4  接单
//NGVCTypeId_5  求职
//NGVCTypeId_6  招聘

#import "NGSecondVC.h"
#import "NGSearchBar.h"
#import "NGPopListView.h"

#import "NGSecondListCell.h"

static NSString * NGSecondListCellReuseId = @"NGSecondListCellReuseId";

@interface NGSecondVC ()<NGSearchBarDelegate,NGPopListDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    //pop view相关
    NSArray *   _common_pop_btnTitleArr; //同行-选择按钮的默认标题
    NSArray *   _common_pop_btnListArr;//列表数据
    
    NSArray *tonghang_dataSourceArr; //同行-pop data
    NSDictionary *_dic;
    NSArray *company_btnTitleArr; //同行-选择按钮的默认标题
    NSArray *company_dataSourceArr; //同行-list data
    
    //tableview相关
    NSMutableArray *_tableview_DataArr;

    
    BOOL _isTHvc;//YES :同行页面，NO：公司页面
}
@end

@implementation NGSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
//    if (_vcType > 2) {
//        self.hidesBottomBarWhenPushed = YES;
//    }
    [self initSubviews];

}

-(void)initData
{
    //pop
    NSInteger _index = self.tabBarController.selectedIndex;
    if (_index == 1) {
        self.vcType = NGVCTypeId_1;
    }
    else if (_index == 2)
    {
        self.vcType = NGVCTypeId_2;
    }
    
    //btn title
    NSArray *_btnTitleArr1 = @[@"服务区域",@"业务类型",@"类别"];//同行
    NSArray *_btnTitleArr2 = @[@"服务区域",@"业务类型"];//公司
    NSArray *_btnTitleArr3 = @[@"服务区域",@"业务类型",@"时间"];//接单
    
    NSArray *_sexArr = @[@"全部",@"男",@"女"];//性别
    NSArray *_areaArr = [NGXMLReader getCurrentLocationAreas];//区域
    NSArray *_typeArr = [NGXMLReader getBaseTypeData];//基本业务类型
    
    switch (self.vcType) {
        case NGVCTypeId_1:
        {
            _common_pop_btnTitleArr = _btnTitleArr1;
            _common_pop_btnListArr  = @[_areaArr,_typeArr,_sexArr];
        } break;
        case NGVCTypeId_2:
        {
            _common_pop_btnTitleArr = _btnTitleArr2;
            _common_pop_btnListArr  = @[_areaArr,_typeArr];
        } break;
            
        default: break;
    }
    
    tonghang_dataSourceArr = @[@"全部",@"男",@"女",@"其他"];
    _dic = [NSDictionary dictionaryWithObjectsAndKeys:@[@"100",@"101"],@"1",@[@"200",@"201",@"202"],@"2", nil];
    
    //tableview
    _tableview_DataArr = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
}

#pragma mark- init subviews
-(void)initSubviews
{
    NGPopListView *popView = [[NGPopListView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, 40) withDelegate:self withSuperView:self.view];
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
    [_tableView registerNib:[UINib nibWithNibName:@"NGSecondListCell" bundle:nil] forCellReuseIdentifier:NGSecondListCellReuseId];
    
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark --加载数据
-(void)loadMoreData
{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_tableview_DataArr addObjectsFromArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@""]];
        [_tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        [_tableView.header endRefreshing];
    });
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

//第一个列表显示的数据源,NSArray类型,第二个列表数据源：
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



#pragma mark --UItableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableview_DataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NGSecondListCell *cell = [tableView dequeueReusableCellWithIdentifier:NGSecondListCellReuseId forIndexPath:indexPath];
    NSDictionary *_dic0 = @{@"1":@"cell_avatar_default",@"2":@"张三丰",@"3":@"18016381234",@"4":@"车贷融资-金融",@"5":@"民间抵押个人-车辆-信用卡"};
    [cell setCellWith:_dic0];
    
    cell.btnClickBlock = ^(NSInteger tag){
        NSLog(@"...cell btn click : %d",tag);
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"....tableview cell select");
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _tableview_DataArr.count - 1) {
        [self loadMoreData];
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
}


@end
