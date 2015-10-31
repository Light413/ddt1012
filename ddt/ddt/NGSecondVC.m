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
#import "DTCompanyListCell.h"

static NSString * showTongHangVcID  = @"showTongHangVcID";
static NSString * showCompanyVcID   = @"showCompanyVcID";
static NSString * showJieDanVcID    = @"showJieDanVcID";
static NSString * showQinZhiVcID    = @"showQinZhiVcID";
static NSString * showZhaoPinVcID   = @"showZhaoPinVcID";

static NSString * NGSecondListCellReuseId = @"NGSecondListCellReuseId";
static NSString * NGCompanyListCellReuseId = @"NGCompanyListCellReuseId";

@interface NGSecondVC ()<NGSearchBarDelegate,NGPopListDelegate,UITableViewDataSource,UITableViewDelegate>
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
}
@end

@implementation NGSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
    [self createLeftBarItemWithBackTitle];

}
-(void)awakeFromNib
{
    UIBarButtonItem *_backitem =[ [UIBarButtonItem alloc]init];
    _backitem.title = @"";
    self.navigationItem.backBarButtonItem = _backitem;
}
-(void)goback:(UIButton *)btn
{
    [popView disappear];
    [self.navigationController popViewControllerAnimated:YES];
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
    NSArray *_sexArr = @[@"全部",@"男",@"女"];//性别
    NSArray *_areaArr = [NGXMLReader getCurrentLocationAreas];//区域
    NSArray *_typeArr = [NGXMLReader getBaseTypeData];//基本业务类型
    switch (self.vcType) {
        case NGVCTypeId_1:
        {//同行
            NSArray *_btnTitleArr1 = @[@"服务区域",@"业务类型",@"性别"];
            _common_pop_btnTitleArr = _btnTitleArr1;
            _common_pop_btnListArr  = @[_areaArr,_typeArr,_sexArr];
        } break;
        case NGVCTypeId_2:
        {//公司
            NSArray *_btnTitleArr2 = @[@"服务区域",@"业务类型"];
            _common_pop_btnTitleArr = _btnTitleArr2;
            _common_pop_btnListArr  = @[_areaArr,_typeArr];
            

        } break;
        case NGVCTypeId_3:
        {//附近同行
            NSArray *tmp = @[@"服务区域",@"业务类型",@"性别"];
            _common_pop_btnTitleArr = tmp;
            _common_pop_btnListArr  = @[_areaArr,_typeArr,_sexArr];
        } break;
        case NGVCTypeId_4:
        {//接单
            NSArray *tmp = @[@"服务区域",@"业务类型",@"时间"];
            _common_pop_btnTitleArr = tmp;
            _common_pop_btnListArr  = @[_areaArr,_typeArr,_sexArr];
        } break;
            
        case NGVCTypeId_5:
        {//求职
            NSArray *tmp = @[@"区域",@"类型",@"工资",@"职位",@"经验"];
            NSArray *_a1 = [DTComDataManger getData_qwxz];
            NSArray *_a2 = [DTComDataManger getData_gwlx];
            NSArray *_a3 = [DTComDataManger getData_gzjy];
            _common_pop_btnTitleArr = tmp;
            _common_pop_btnListArr  = @[_areaArr,_typeArr,_a1,_a2,_a3];
        } break;
            
        case NGVCTypeId_6:
        {//招聘
            NSArray *tmp = @[@"区域",@"类型",@"性别",@"职位",@"经验"];
            NSArray *_a2 = [DTComDataManger getData_gwlx];
            NSArray *_a3 = [DTComDataManger getData_gzjy];
            _common_pop_btnTitleArr = tmp;
            _common_pop_btnListArr  = @[_areaArr,_typeArr,_sexArr,_a2,_a3];
        } break;
            
        default: break;
    }
    
    
    //...test   tableview
    _common_list_dataSource = [[NSMutableArray alloc]init];
    _common_cellId_arr = @[NGSecondListCellReuseId,NGCompanyListCellReuseId,NGSecondListCellReuseId,NGSecondListCellReuseId,NGSecondListCellReuseId,NGSecondListCellReuseId];
    _common_list_cellReuseId = [_common_cellId_arr objectAtIndex:self.vcType - 1];
    
    NSArray *_arr = @[
  @[@{@"1":@"cell_avatar_default",@"2":@"张三18016381234",@"3":@"18016381234",@"4":@"车贷融资-金融",@"5":@"民间抵押个人-车辆-信用卡"}],
  @[@{@"1":@"车贷金融发过节费公司公司",@"2":@"民间信贷－房产地眼粉色经典福克斯附近的时刻复活节恢复建设的附近发生地方防护服热风 i 好烦好烦搜索健康发生的进口附加税开发分热放复活节妇女地方加拿大籍分妇女健康的妇女舒服",@"3":@"车辆抵押，信用贷款／信用卡付款"}],
    @[@{@"1":@"cell_avatar_default",@"2":@"张三18016381234",@"3":@"18016381234",@"4":@"车贷融资-金融",@"5":@"民间抵押个人-车辆-信用卡"}],
    @[@{@"1":@"cell_avatar_default",@"2":@"张三18016381234",@"3":@"18016381234",@"4":@"车贷融资-金融",@"5":@"民间抵押个人-车辆-信用卡"}],
    @[@{@"1":@"cell_avatar_default",@"2":@"张三18016381234",@"3":@"18016381234",@"4":@"车贷融资-金融",@"5":@"民间抵押个人-车辆-信用卡"}],
    @[@{@"1":@"cell_avatar_default",@"2":@"张三18016381234",@"3":@"18016381234",@"4":@"车贷融资-金融",@"5":@"民间抵押个人-车辆-信用卡"}]
  ];
    
    [_common_list_dataSource addObjectsFromArray:[_arr objectAtIndex:self.vcType - 1]];
}

#pragma mark- init subviews
-(void)initSubviews
{
    NSArray *_titleArr = @[@"贷款同行名片",@"贷款公司名片",@"附近同行",@"我要接单",@"我要求职",@"我要招聘"];
    self.title = [_titleArr objectAtIndex:self.vcType - 1];
    
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
    [_tableView registerNib:[UINib nibWithNibName:@"NGSecondListCell" bundle:nil] forCellReuseIdentifier:NGSecondListCellReuseId];
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
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_common_list_dataSource addObjectsFromArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@""]];
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



#pragma mark --UItableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _common_list_dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTCompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:_common_list_cellReuseId forIndexPath:indexPath];
    NSDictionary *_dic0 = [_common_list_dataSource objectAtIndex:0];
    [cell setCellWith:_dic0];
    
    cell.btnClickBlock = ^(NSInteger tag){
        NSLog(@"...cell btn click : %ld",tag);
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.vcType) {
        case NGVCTypeId_2:
        {
            NSDictionary *_dic0 = [_common_list_dataSource objectAtIndex:0];
            NSString * str = [_dic0 objectForKey:@"2"];
            CGSize _size = CGSizeMake(CurrentScreenWidth -100, 999);
            UIFont *font = [UIFont systemFontOfSize:14];
            CGSize _new =  [ToolsClass calculateSizeForText:str :_size font:font];
           
            return _new.height + 20;
        }break;
            
        default:
            break;
    }
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"....tableview cell select");
    switch (self.vcType) {
        case NGVCTypeId_1:
        {
            [self performSegueWithIdentifier:showTongHangVcID sender:nil];
        }break;
        case NGVCTypeId_2:
        {
            [self performSegueWithIdentifier:showCompanyVcID sender:nil];
        }break;
        case NGVCTypeId_3:
        {
            [self performSegueWithIdentifier:showTongHangVcID sender:nil];
        }break;
        case NGVCTypeId_4://接单
        {
            [self performSegueWithIdentifier:showJieDanVcID sender:nil];
        }break;
        case NGVCTypeId_5://求职
        {
            [self performSegueWithIdentifier:showQinZhiVcID sender:nil];
        }break;
        case NGVCTypeId_6://招聘
        {
            [self performSegueWithIdentifier:showZhaoPinVcID sender:nil];
        }break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _common_list_dataSource.count - 1) {
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
