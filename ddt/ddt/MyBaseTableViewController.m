//
//  MyBaseTableViewController.m
//  ddt
//
//  Created by allen on 15/10/19.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "MyBaseTableViewController.h"

@interface MyBaseTableViewController ()

@end

@implementation MyBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.window = [[UIApplication sharedApplication].delegate window] ;
    //[self.view setBackgroundColor:RGBA(235, 235, 235, 1.0)];
    if (IOS7LATER)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self createLeftBarItemWithBackTitle];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)createLeftBarItemWithBackTitle{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setFrame:CGRectMake(0, 0, 16, 22)] ;
    [button setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal] ;
    [button setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateSelected] ;
    [button addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:item];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)] ;
}
//创建导航栏右侧按钮
-(void)createRightBarItemWithBackTitle:(NSString *)moreTitle
                          andImageName:(NSString *)imageName
{
    
    //
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    if (moreTitle.length>2)
    {
        [button setFrame:CGRectMake(0, 0, 80, 40)];
    }
    else
    {
        [button setFrame:CGRectMake(0, 0, 60, 40)];
    }
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:moreTitle forState:UIControlStateNormal];
    
    
    UIImage* image1111=[UIImage imageNamed:imageName];
    UIImageView* backImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,image1111.size.width/2-5 ,image1111.size.height/2-5)];
    if (IOS7LATER)
    {
        [backImage setFrame:CGRectMake(30, 0,image1111.size.width/2 ,image1111.size.height/2)];
    }
    [backImage setBackgroundColor:[UIColor clearColor]];
    [backImage setImage:image1111];
    [button addSubview:backImage];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    if (IOS7LATER && moreTitle.length)
    {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0,  30, 0, 0)];
    }
    [button addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:item];
}
-(void)goback:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
//右侧按钮事件
-(void)moreAction:(UIBarButtonItem *)barButtonItem
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
