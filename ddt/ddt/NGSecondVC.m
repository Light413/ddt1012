//
//  NGSecondVC.m
//  ddt
//
//  Created by gener on 15/10/13.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGSecondVC.h"
#import "NGSearchBar.h"
#import "NGPopListView.h"

@interface NGSecondVC ()<NGSearchBarDelegate,NGPopListDelegate>
{
    UITableView *_tableView;
    
    NSArray *tonghang_btnTitleArr; //同行-选择按钮的默认标题
    NSArray *tonghang_dataSourceArr; //同行-list data
    NSDictionary *_dic;
    
    
    NSArray *company_btnTitleArr; //同行-选择按钮的默认标题
    NSArray *company_dataSourceArr; //同行-list data
    
    BOOL _isTHvc;//YES :同行页面，NO：公司页面
}
@end

@implementation NGSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];

}

-(void)initData
{
    _isTHvc = self.tabBarController.selectedIndex == 1;
    
    tonghang_btnTitleArr = @[@"服务区域",@"业务类型",@"类别"];
    tonghang_dataSourceArr = @[@"全部",@"男",@"女",@"其他"];
    
    _dic = [NSDictionary dictionaryWithObjectsAndKeys:@[@"100",@"101"],@"1",@[@"200",@"201",@"202"],@"2", nil];
    company_btnTitleArr = @[];
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height, CurrentScreenWidth, CurrentScreenHeight -64-44 -40-30) style:UITableViewStylePlain];
    
    [self.view  addSubview:_tableView];
}


#pragma mark - NGPopListDelegate
-(NSInteger)numberOfSectionInPopView:(NGPopListView *)poplistview
{
    return _isTHvc? tonghang_btnTitleArr.count:tonghang_btnTitleArr.count - 1;
}

-(NSString *)titleOfSectionInPopView:(NGPopListView *)poplistview atIndex:(NSInteger)index
{
    return [tonghang_btnTitleArr objectAtIndex:index];
}

-(id)dataSourceOfPoplistviewIsArray:(BOOL)isyes
{
    if (isyes) {
       return tonghang_dataSourceArr;
    }
    else
    {
        return _dic;
    }
}

-(NSInteger)popListView:(NGPopListView *)popListView numberOfRowsInSection:(NSInteger)section
{
    return tonghang_dataSourceArr.count;
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
