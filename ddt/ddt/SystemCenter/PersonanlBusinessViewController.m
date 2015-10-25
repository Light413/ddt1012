//
//  PersonanlBusinessViewController.m
//  ddt
//
//  Created by huishuyi on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "PersonanlBusinessViewController.h"
#import "NGBaseListView.h"
@interface PersonanlBusinessViewController ()<NGBaseListDelegate>
{
     NGBaseListView *_listView;
}
@end

@implementation PersonanlBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择业务类型";
    if (_listView == nil) {
        _listView =  [[NGBaseListView alloc]initWithFrame:CGRectZero withDelegate:self];
    }
    _listView.frame  = CGRectMake(0, 0,CurrentScreenWidth, CurrentScreenHeight-64);

    [self.view addSubview:_listView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NGBaseListDelegate

-(NSInteger)numOfTableViewInBaseView:(NGBaseListView *)baseListView
{
    return  2 ;
}

-(NSArray*)dataSourceOfBaseView
{
    return [NGXMLReader getBaseTypeData];//基本业务类型
}

-(NSArray *)dataSourceOfBaseViewWithKey:(NSString *)keyValue
{
    return [NGXMLReader getBaseTypeDataWithKey:keyValue];
}

-(void)baseView:(NGBaseListView *)baseListView didSelectObj:(id)obj1 secondObj:(id)obj2
{
    NSLog(@"obj1 : %@ ---- obj2 :%@",obj1,obj2);
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
