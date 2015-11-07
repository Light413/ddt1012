//
//  NGSearchWithKeyVC.m
//  ddt
//
//  Created by wyg on 15/11/1.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGSearchWithKeyVC.h"
#import "NGSearchBar.h"
#import "MyCollectionViewController.h"

#define btnTagBase  130

@interface NGSearchWithKeyVC ()<UISearchBarDelegate>
{
    NSArray *_btnTitleArr;
    UISearchBar *searchbar;
}
@end

@implementation NGSearchWithKeyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundView =  nil;
    self.tableView.backgroundColor =[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
    
    _btnTitleArr = @[@"房贷",@"车贷",@"企业贷",@"信贷",@"抵押",@"零首付",@"短拆过桥",@"股票配资"];
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
    [self initTopSubview];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [searchbar resignFirstResponder];
}


-(void)initTopSubview
{
    searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 0)];
    searchbar.delegate = self;
    searchbar.showsCancelButton = YES;
    searchbar.placeholder = @"请输入搜索关键字";
    searchbar.tintColor = [UIColor blackColor];

//    UIView *_v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
//    _v.backgroundColor = [UIColor redColor];
    
    self.navigationItem.titleView = searchbar;
}


#pragma mark --btn action
- (IBAction)btnClickAction:(UIButton *)sender {
    
//    [self performSegueWithIdentifier:@"showUserSearchDetailId" sender:nil];
    MyCollectionViewController *collection = [[MyCollectionViewController alloc]init];
    collection.vcType = 2;
    collection.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collection animated:YES];
    
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
//    [self performSegueWithIdentifier:@"showUserSearchDetailId" sender:nil];
    MyCollectionViewController *collection = [[MyCollectionViewController alloc]init];
    collection.vcType = 2;
    collection.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collection animated:YES];
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
