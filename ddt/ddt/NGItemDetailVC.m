//
//  NGItemDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/18.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGItemDetailVC.h"

@interface NGItemDetailVC ()
{

}
@property(nonatomic,copy)NSString*itemKey;

@end

@implementation NGItemDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

-(void)initData
{
    if (!self.superdic) {
        [SVProgressHUD showInfoWithStatus:@"数据获取失败,请重试"];
        [self.navigationController popViewControllerAnimated:YES];return;
    }
    self.title = [self.superdic objectForKey:@"title"];
    self.itemKey = [self.superdic objectForKey:@"key"];
    
}


-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
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
