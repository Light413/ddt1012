//
//  NGItemsDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/18.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGItemsDetailVC.h"
#import "NGCompanyListVC.h"
#import "NGSecondVC.h"

#define nextStepBtnTag 110

@interface NGItemsDetailVC ()<pickViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *btn_normal;
@property (weak, nonatomic) IBOutlet UIButton *btn_no_normal;
@property (weak, nonatomic) IBOutlet UIButton *btn_select_area;//选择区域
@property (weak, nonatomic) IBOutlet UIButton *btn_dk_body;//贷款主体
@property (weak, nonatomic) IBOutlet UIButton *btn_select_type;//选择类型
@property (weak, nonatomic) IBOutlet UITextField *tf_search_key;//搜索
@property (weak, nonatomic) IBOutlet UIButton *btn_search_dz;//btn搜单子
@property (weak, nonatomic) IBOutlet UIButton *btn_search_th;//btn搜同行

@property(nonatomic,copy)NSString*itemKey;
@end

typedef NS_ENUM(NSUInteger, NGSelectDataType) {
    NGSelectDataTypeNone,     //0
    NGSelectDataTypeArea,     //选择区域数据
    NGSelectDataTypeTaskType, //选择业务类型
    NGSelectDataTypePortType, //选择入口类型
};

@implementation NGItemsDetailVC
{
    NSArray *_pickViewDataArr;
    
    NGSelectDataType _pickerViewType;
    UIButton *_selectedBtn;//当前被选中的btn
    
    NSArray * _in_data_arr;//个人或者企业主体数据
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
}

#pragma mark --init
-(void)initData
{
    switch (self.vcType) {
        case 1:
        {
            self.title = [NSString stringWithFormat:@"%@%@",[self.superdic objectForKey:@"title"],_optional_info?_optional_info:@""];
            self.itemKey = [self.superdic objectForKey:@"key"];
        } break;
        case 2://个人贷款渠道
        case 3://企业贷款渠道
        {
            if (self.vcType ==2) {
                self.title = @"个人贷款渠道";
                _in_data_arr = @[@{@"ID":@"11",@"NAME":@"银行信贷个人"},@{@"ID":@"12",@"NAME":@"银行抵押个人"},@{@"ID":@"13",@"NAME":@"民间信贷个人"},@{@"ID":@"14",@"NAME":@"民间抵押个人"}];
            }
            else if (self.vcType ==3)
            {
                self.title = @"企业贷款渠道";
                _in_data_arr = @[@{@"ID":@"21",@"NAME":@"银行信贷企业"},@{@"ID":@"22",@"NAME":@"银行抵押企业"},@{@"ID":@"23",@"NAME":@"民间信贷企业"},@{@"ID":@"24",@"NAME":@"民间抵押企业"}];
            }
    
            NSDictionary *_dd = [_in_data_arr objectAtIndex:0];
            [self.btn_dk_body setNormalTitle:[_dd objectForKey:@"NAME"] andID:[_dd objectForKey:@"ID"]];
            self.itemKey = [self.btn_dk_body ID];
        } break;
        default:break;
    }

    
    NSLog(@"------------key : %@",_itemKey);
    
    _pickerViewType = NGSelectDataTypeNone;
}

-(void)initSubviews
{
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    self.backView.layer.borderWidth = 1;
    
    UIImage *img1 = [UIImage imageNamed:@"btn_bg"];
    UIImage *img2 = [img1 stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.btn_search_dz setBackgroundImage:img2 forState:UIControlStateNormal];
    [self.btn_search_th setBackgroundImage:img2 forState:UIControlStateNormal];
    
    _btn_normal.selected = YES;
    
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;    
}


-(void)giveDataToPickerWithTypee:(NGSelectDataType)type
{
    if (type == NGSelectDataTypeArea) {
        NSArray *_a =[NGXMLReader getCurrentLocationAreas];;
        _pickViewDataArr =_a ;
    }
    else if (type == NGSelectDataTypeTaskType)
    {
        if(self.btn_dk_body.ID)
        {
            self.itemKey = self.btn_dk_body.ID;
        }
        if (self.itemKey) {
            NSArray *_a =[NGXMLReader getBaseTypeDataWithKey:self.itemKey];
            _pickViewDataArr =_a ;
        }
    }
    else if (type == NGSelectDataTypePortType)//个人，企业入口数据
    {
        _pickViewDataArr = _in_data_arr;
    }
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
    else if (sender == _btn_dk_body)
    {
        _pickerViewType = NGSelectDataTypePortType;
    }
    
    [self giveDataToPickerWithTypee:_pickerViewType];
    _selectedBtn = sender;
    
    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
    [_pickview showIn:self.view];
}


//搜单子、搜同行、搜公司
- (IBAction)nextStopbtnAction:(UIButton *)sender {
    UIViewController* vc;
    
    switch (sender.tag - 110) {
        case 0:
        {//搜单子
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"secondSB" bundle:nil];
            vc=  [sb instantiateViewControllerWithIdentifier:@"secondSBID"];
            ((NGSecondVC *)vc).vcType = 4;
            ((NGSecondVC *)vc).selectedArea = self.btn_select_area.title?self.btn_select_area.title:@"全部";
            ((NGSecondVC *)vc).selectedType = self.btn_select_type.title?self.btn_select_type.title:@"全部";
            ((NGSecondVC *)vc).searchKey = self.tf_search_key.text;
        }
            break;
        case 1:
        {//搜同行
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"secondSB" bundle:nil];
            vc=  [sb instantiateViewControllerWithIdentifier:@"secondSBID"];
           ((NGSecondVC *)vc).vcType = 2;
            ((NGSecondVC *)vc).selectedArea = self.btn_select_area.title?self.btn_select_area.title:@"全部";
            ((NGSecondVC *)vc).selectedType = self.btn_select_type.title?self.btn_select_type.title:@"全部";
            ((NGSecondVC *)vc).searchKey = self.tf_search_key.text;
        }
            break;
        case 2:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"companySB" bundle:nil];
            vc=  [sb instantiateViewControllerWithIdentifier:@"companySBID"];
            ((NGCompanyListVC *)vc).vcType = 2;
            ((NGCompanyListVC *)vc).selectedArea = self.btn_select_area.title?self.btn_select_area.title:@"全部";
            ((NGCompanyListVC *)vc).selectedType = self.btn_select_type.title?self.btn_select_type.title:@"全部";
            ((NGCompanyListVC *)vc).searchKey = self.tf_search_key.text;
        }
            break;
        default:
            break;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark --UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark-pickViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickViewDataArr.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *_dic = [_pickViewDataArr objectAtIndex:row];
    return [_dic objectForKey:@"NAME"];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerViewType = NGSelectDataTypeNone;
    NSDictionary *_d = [_pickViewDataArr objectAtIndex:row];
    [_selectedBtn setNormalTitle:[_d objectForKey:@"NAME"] andID:[_d objectForKey:@"ID"]];
    _pickViewDataArr = nil;
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
