//
//  NGSearchCitiesVC.m
//  ddt
//
//  Created by wyg on 15/10/31.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGSearchCitiesVC.h"
#import "ChineseToPinyin.h"

@interface NGSearchCitiesVC ()
{
    NSMutableArray *_allKey;
    NSMutableDictionary *_dataSourceDic;
}

@property(nonatomic,assign)BOOL isSearchStatus;

@end

@implementation NGSearchCitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市列表";
    _allKey = [[NSMutableArray alloc]init];
    _dataSourceDic = [[NSMutableDictionary alloc]init];
    //    [0]	(null)	@"ID" : @"3"
    //    [1]	(null)	@"NAME" : @"石家庄市"
    NSArray *_arr = [NGXMLReader getAllCities];
    [self addDataWithArr:_arr];
    
    [self.tableView reloadData];
}

-(void)awakeFromNib
{
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
-(void)goback:(id)btn
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//按名字首字母分类
-(void)addDataWithArr :(NSArray*)arr
{
    for (int i=0; i < arr.count; i++) {
        NSDictionary *_dic = [arr objectAtIndex:i];
        NSString *_name = [_dic objectForKey:@"NAME"];
        NSString *_usrStr = [ChineseToPinyin pinyinFromChiniseString:_name];
        NSString *firstC =[_usrStr substringToIndex:1];
        NSArray *_keyArr = [_dataSourceDic allKeys];
        NSMutableArray *_tmpArr = nil;
        for (int m =0; m < _keyArr.count; m++) {
            NSString *_key = [_keyArr objectAtIndex:m];
            if ([firstC isEqualToString:_key]) {
                _tmpArr = [_dataSourceDic objectForKey:_key];
                [_tmpArr addObject:_dic];break;
            }
        }
        if (_tmpArr == nil) {
            _tmpArr  = [[NSMutableArray alloc]init];
            [_tmpArr addObject:_dic];
            [_dataSourceDic setObject:_tmpArr forKey:firstC];
        }
    }
    NSArray *allkey = [_dataSourceDic allKeys];
    _allKey = (NSMutableArray *)[allkey sortedArrayUsingSelector:@selector(compare:)];
}


#pragma mark -- UITableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.isSearchStatus)
    {
        return 1;
    }
    return _allKey.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isSearchStatus)
    {
        return 0;
    }
    else
    {
        NSString *_str = [_allKey objectAtIndex:section];
        NSArray*_arr = [_dataSourceDic objectForKey:_str];
        return _arr.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.isSearchStatus)return nil;
    return [_allKey objectAtIndex:section];
}
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.isSearchStatus)return nil;
    return _allKey;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(self.isSearchStatus)return 0;
    return index;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NGCityCellID"];
    NSString *_str = [_allKey objectAtIndex:indexPath.section];
    NSArray*_arr = [_dataSourceDic objectForKey:_str];
    NSDictionary*userDic = [_arr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"NAME"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
