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
@interface MyCollectionViewController ()<NGSearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    UISegmentedControl *mysegment;
}
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarItemWithBackTitle];
    self.title = @"我的收藏";
    NSArray *segmentArr = @[@"单子收藏",@"同行好友",@"公司收藏"];
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(30, 10, CurrentScreenWidth-60, 30)];
//    backView.layer.cornerRadius = 3;
//    backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
//    backView.layer.borderWidth = 1;
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(0, 0, backView.width/3, backView.height);
//    [backView addSubview:btn1];
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
   
    mysegment = [[UISegmentedControl alloc]initWithItems:segmentArr];
        mysegment.frame = CGRectMake(30, 10, CurrentScreenWidth-60, 30);
        [mysegment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    mysegment.tintColor= RGBA(76.0, 132.0, 120.0, 1.0);
    mysegment.enabled = YES;
    mysegment.selectedSegmentIndex = 0;
    //[segment insertSegmentWithImage:[UIImage imageNamed:@"bg_credit"] atIndex:0 animated:YES];
    //    segment.layer.borderWidth = 1;
    //    segment.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    //    //segment.layer.cornerRadius = 5;
    //    //[RGBA(207, 207, 207, 1)CGColor];
    //    segment.selectedSegmentIndex = 0;
    //    segment.momentary = NO;
    //
    ////    segment insertSegmentWithImage:<#(UIImage *)#> atIndex:<#(NSUInteger)#> animated:<#(BOOL)#>
    //    segment.tintColor = [UIColor grayColor];
    //    //segment.tintColor = [UIColor redColor];
    [self.view addSubview:mysegment];
    NGSearchBar *searchBar = [[NGSearchBar alloc]initWithFrame:CGRectMake(10, mysegment.bottom+10, CurrentScreenWidth -20 , 30)];
    searchBar.delegate  =self;
    searchBar.placeholder = @"搜索";
    [self.view addSubview:searchBar];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBar.bottom+10, CurrentScreenWidth, CurrentScreenHeight-searchBar.bottom-10) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [self addheader:myTableView];
    [self addfooter:myTableView];
    // Do any additional setup after loading the view.
}
#pragma mark --tableview 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = mysegment.selectedSegmentIndex;
    if (index == 1) {
        static NSString *CellId = @"tonghangcell";
        TonghangTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TonghangTableViewCell" owner:self options:nil]lastObject];
        }
        return cell;
    }else if(index == 2){
        static NSString *cellId = @"commanyCell";
        MyScTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyScTableViewCell" owner:self options:nil]lastObject];
        }
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        return cell;
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
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
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
