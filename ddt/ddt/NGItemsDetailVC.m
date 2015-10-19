//
//  NGItemsDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/18.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGItemsDetailVC.h"

@interface NGItemsDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *btn_normal;
@property (weak, nonatomic) IBOutlet UIButton *btn_no_normal;
@property (weak, nonatomic) IBOutlet UIButton *btn_select_area;
@property (weak, nonatomic) IBOutlet UIButton *btn_select_type;
@property (weak, nonatomic) IBOutlet UITextField *tf_search_key;

@property(nonatomic,copy)NSString*itemKey;
@end

@implementation NGItemsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
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

-(void)initSubviews
{
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    self.backView.layer.borderWidth = 1;
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;    
}

/**
 *  btn action 正常，异常
 *
 *  @param sender <#sender description#>
 */
- (IBAction)btn_normal_action:(UIButton*)btn {
    btn.selected = !btn.selected;
    if (btn == _btn_normal) {
        _btn_no_normal.selected = NO;
    }
    else if (btn == _btn_no_normal)
    {
        _btn_normal.selected = NO;
    }
}
//选择区域，类型
- (IBAction)btn_select_area:(id)sender {
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
