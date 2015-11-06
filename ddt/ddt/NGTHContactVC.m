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

@interface NGTHContactVC ()
{
    NSMutableArray *_dataArray;
    
}
@end

static NSString * thcontactCellReuseId = @"thcontactCellReuseId";

@implementation NGTHContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
}

-(void)initSubviews
{
    self.tableView.tableFooterView = [[UIView alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"我要发布" style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClick)];
    
    self.navigationItem.rightBarButtonItem = rightitem;
}

-(void)rightItemClick
{
    [self performSegueWithIdentifier:@"showReleaseContactID" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 NGTHContactCell *cell = [tableView dequeueReusableCellWithIdentifier:thcontactCellReuseId forIndexPath:indexPath];
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"会议标题",@"1",@"这是会议地址",@"2",@"2016-11-06 09:67(星期日)",@"3", nil];
     [cell setCellWith:dic];
 
 return cell;
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showContactDetailID" sender:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

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
