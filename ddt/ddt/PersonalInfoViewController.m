//
//  PersonalInfoViewController.m
//  ddt
//
//  Created by allen on 15/10/19.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonanlBusinessViewController.h"
@interface PersonalInfoViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end
typedef NS_ENUM(NSUInteger, NGSelectDataType) {
    NGSelectDataTypeNone,  //0
    NGSelectDataTypeArea,     //选择区域数据
    NGSelectDataTypeTaskType, //选择业务类型
};
@implementation PersonalInfoViewController
{
    NSArray *_pickViewDataArr;
    
    NGSelectDataType _pickerViewType;
    UIButton *_selectedBtn;//当前被选中的btn
}
@synthesize nameField;
@synthesize maleBtn;
@synthesize femaleBtn;
@synthesize birthBtn;
@synthesize weixinField;
@synthesize companyField;
@synthesize recommandPersonBtn;
@synthesize serviceAreaBtn;
@synthesize bussinessSortBtn;
@synthesize keyWordField;
@synthesize typeInLabel;
@synthesize InfoTextView;
@synthesize backView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息完善";
    backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    backView.layer.borderWidth = 1;
    InfoTextView.delegate = self;
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    maleBtn.selected = YES;
    femaleBtn.selected = NO;
    maleBtn.backgroundColor = [UIColor clearColor];
    femaleBtn.backgroundColor = [UIColor clearColor];
    [maleBtn setBackgroundImage:[UIImage imageNamed:@"checkbox1_unchecked@2x"] forState:UIControlStateNormal];
    [maleBtn setBackgroundImage:[UIImage imageNamed:@"checkbox1_checked@2x"] forState:UIControlStateSelected];
    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"checkbox1_unchecked@2x"] forState:UIControlStateNormal];
    [femaleBtn setBackgroundImage:[UIImage imageNamed:@"checkbox1_checked@2x"] forState:UIControlStateSelected];
    _pickerViewType = NGSelectDataTypeNone;
    self.itemKey = @"11";

    // Do any additional setup after loading the view.
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
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        typeInLabel.hidden = YES;
    }else{
        typeInLabel.hidden = NO;
    }
}
- (IBAction)birthBtnClick:(id)sender {
}
- (IBAction)recommandPersonBtnClick:(id)sender {
}
- (IBAction)serviceBtnClick:(id)sender {
    _pickerViewType = NGSelectDataTypeArea;
    
    [self giveDataToPickerWithTypee:_pickerViewType];
    _selectedBtn = sender;
    
    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
    [_pickview showIn:self.view];
}
-(void)giveDataToPickerWithTypee:(NGSelectDataType)type
{
    if (type == NGSelectDataTypeArea) {
        //        [0]	(null)	@"ID" : @"719"
        //        [1]	(null)	@"NAME" : @"黄浦区"
        NSArray *_a =[NGXMLReader getCurrentLocationAreas];;
        _pickViewDataArr =_a ;
    }
    else if (type == NGSelectDataTypeTaskType)
    {
        if (self.itemKey) {
            NSArray *_a =[NGXMLReader getBaseTypeDataWithKey:self.itemKey];
            _pickViewDataArr =_a ;
        }
    }
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
    [_selectedBtn setNormalTitle:[_d objectForKey:@"NAME"] andID:nil];
    _pickViewDataArr = nil;
}

- (IBAction)bussinessSortBtnClick:(id)sender {
    PersonanlBusinessViewController *person = [[PersonanlBusinessViewController alloc]init];
    person.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:person animated:YES];
//    _pickerViewType = NGSelectDataTypeTaskType;
//    [self giveDataToPickerWithTypee:_pickerViewType];
//    _selectedBtn = sender;
//    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
//    [_pickview showIn:self.view];
}
- (IBAction)saveInfoBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)maleBtnClick:(id)sender {
    maleBtn.selected = !maleBtn.selected;
    if (maleBtn.selected) {
        femaleBtn.selected = NO;
    }else{
        femaleBtn.selected = YES;
    }
}

- (IBAction)femaleBtnClick:(id)sender {
    femaleBtn.selected = !femaleBtn.selected;
    if (femaleBtn.selected) {
        maleBtn.selected = NO;
    }else{
        maleBtn.selected = YES;
    }
}
@end
