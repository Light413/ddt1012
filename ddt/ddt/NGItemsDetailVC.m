//
//  NGItemsDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/18.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGItemsDetailVC.h"

@interface NGItemsDetailVC ()<pickViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *btn_normal;
@property (weak, nonatomic) IBOutlet UIButton *btn_no_normal;
@property (weak, nonatomic) IBOutlet UIButton *btn_select_area;
@property (weak, nonatomic) IBOutlet UIButton *btn_select_type;
@property (weak, nonatomic) IBOutlet UITextField *tf_search_key;

@property(nonatomic,copy)NSString*itemKey;
@end

typedef NS_ENUM(NSUInteger, NGSelectDataType) {
    NGSelectDataTypeNone,  //0
    NGSelectDataTypeArea,     //选择区域数据
    NGSelectDataTypeTaskType, //选择业务类型
};

@implementation NGItemsDetailVC
{
    NSArray *_arr;
    
    NGSelectDataType _pickerViewType;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
}

#pragma mark --init
-(void)initData
{
    if (!self.superdic) {
        [SVProgressHUD showInfoWithStatus:@"数据获取失败,请重试"];
        [self.navigationController popViewControllerAnimated:YES];return;
    }
    self.title = [self.superdic objectForKey:@"title"];
    self.itemKey = [self.superdic objectForKey:@"key"];
    
    _pickerViewType = NGSelectDataTypeNone;
    
     //....test
    _arr = [UIFont familyNames];
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
- (IBAction)btn_select_area:(UIButton *)sender {
    if (sender == _btn_select_area) {
        _pickerViewType = NGSelectDataTypeArea;
    }
    else if (sender == _btn_select_type)
    {
        _pickerViewType = NGSelectDataTypeTaskType;
    }
    
    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
    [_pickview showIn:self.view];
}


#pragma mark-pickViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _arr.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_arr objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerViewType = NGSelectDataTypeNone;
    
    
    NSLog(@"did select at index  :%d",row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
