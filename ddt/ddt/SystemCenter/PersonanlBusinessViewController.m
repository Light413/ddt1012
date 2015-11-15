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
    
    NSMutableArray * _hasSelectedObj;//记录已经选择的数据
}
@end

@implementation PersonanlBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择业务类型";
    _hasSelectedObj = [[NSMutableArray alloc]init];
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame = CGRectMake(0, 0, 60, 30);
    [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    rightbtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightbtn addTarget:self action:@selector(btnok) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    
    if (_listView == nil) {
        _listView =  [[NGBaseListView alloc]initWithFrame:CGRectZero withDelegate:self];
    }
    _listView.frame  = CGRectMake(0, 0,CurrentScreenWidth, CurrentScreenHeight-64);

    [self.view addSubview:_listView];
}

//确定 提交操作
-(void)btnok
{
    if (_hasSelectedObj.count >4 ) {
        [SVProgressHUD showInfoWithStatus:@"选项最多四项"];
        return;
    }
    else if (_hasSelectedObj.count ==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请至少选择一项"];
        return;
    }
    
    NSMutableString * totalStr = [[NSMutableString alloc]init];
    for (int i =0; i<_hasSelectedObj.count; i++) {
        NSString *s = [_hasSelectedObj objectAtIndex:i];
        [totalStr appendString:s];
        if (i != _hasSelectedObj.count -1) {
          [totalStr appendString:@"、"];
        }
    }
    
    self.btnClickBlock(totalStr);
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)baseView:(NGBaseListView *)baseListView didSelectObj:(id)obj1 atIndex:(NSIndexPath *)index1 secondObj:(id)obj2 atIndex:(NSIndexPath *)index2
{
    NSLog(@"obj1 : %@ ---- obj2 :%@",obj1,obj2);
    NSString * selectstr = [NSString stringWithFormat:@"%@-%@",[obj1 objectForKey:@"NAME"]?[obj1 objectForKey:@"NAME"]:@"",[obj2 objectForKey:@"NAME"]];
    

    if ([_hasSelectedObj containsObject:selectstr]) {
        [_hasSelectedObj removeObject:selectstr];
    }
    else
    {
        [_hasSelectedObj addObject:selectstr];
    }
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
