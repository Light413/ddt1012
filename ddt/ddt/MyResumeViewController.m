//
//  MyResumeViewController.m
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyResumeViewController.h"
#import "PersonanlBusinessViewController.h"
@interface MyResumeViewController ()<UITextViewDelegate>
typedef NS_ENUM(NSUInteger, NGSelectDataType) {
    NGSelectDataTypeNone,  //0
    NGSelectDataTypeBusiness,     //选择业务
    NGSelectDataTypeworkingYears, //选择业务类型
    NGSelectDataTypeSalary,//工资
    NGSelectDataTypeArea,//工作区域
    NGSelectDataTypeZGXL//最高学历
};
@end

@implementation MyResumeViewController
{
    NSArray *_pickViewDataArr;
    
    NGSelectDataType _pickerViewType;
    UIButton *_selectedBtn;//当前被选中的btn
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的简历";
    self.backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    self.backView.layer.borderWidth = 1;
    self.judgeTextView.delegate = self;
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
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.judgeholderLabel.hidden = YES;
    }else{
        self.judgeholderLabel.hidden = NO;
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

- (IBAction)businessTypeBtnClick:(id)sender {
    [self hideKeyBoard];
    _pickerViewType = NGSelectDataTypeBusiness;
    
    [self giveDataToPickerWithTypee:_pickerViewType];
    _selectedBtn = sender;
    
    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
    [_pickview showIn:self.view];
}
-(void)giveDataToPickerWithTypee:(NGSelectDataType)type
{
    if (type == NGSelectDataTypeBusiness) {
        //        [0]	(null)	@"ID" : @"719"
        //        [1]	(null)	@"NAME" : @"黄浦区"
        NSArray *_a = [DTComDataManger getData_gwlx];
        _pickViewDataArr =_a ;
    }
    else if (type == NGSelectDataTypeworkingYears)
    {
        NSArray *_a = [DTComDataManger getData_gzjy];
        _pickViewDataArr =_a ;
    }else if(type == NGSelectDataTypeSalary){
        NSArray *_a = [DTComDataManger getData_qwxz];
        _pickViewDataArr =_a ;
    }else if (type == NGSelectDataTypeArea){
        NSArray *_a =[NGXMLReader getCurrentLocationAreas];;
        _pickViewDataArr =_a ;
    }else if (type == NGSelectDataTypeZGXL){
        NSArray *_a = [DTComDataManger getData_zgxl];
        _pickViewDataArr =_a ;
    }
}
- (IBAction)salaryBtnClick:(id)sender {
    _pickerViewType = NGSelectDataTypeSalary;
    
    [self giveDataToPickerWithTypee:_pickerViewType];
    _selectedBtn = sender;
    
    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
    [_pickview showIn:self.view];
    [self hideKeyBoard];
}
- (IBAction)certificateBtnClick:(id)sender {
    _pickerViewType = NGSelectDataTypeZGXL;
    
    [self giveDataToPickerWithTypee:_pickerViewType];
    _selectedBtn = sender;
    
    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
     [_pickview showIn:self.view];
    [self hideKeyBoard];
}
- (IBAction)chooseBusinessTypeBtnClick:(id)sender {
    PersonanlBusinessViewController *person = [[PersonanlBusinessViewController alloc]init];
    person.hidesBottomBarWhenPushed = YES;
    person.btnClickBlock = ^(NSString *name){
        [self.chooseBusinessTypeBtn setTitle:name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:person animated:YES];
    [self hideKeyBoard];
}

- (IBAction)saveResumeBtnClick:(id)sender {
    if (self.hopeWorkingField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"期望岗位不能为空"];
        return;
    }
    if (self.chooseBusinessTypeBtn.titleLabel.text.length==0||[self.chooseBusinessTypeBtn.titleLabel.text isEqual:@"选择业务类型"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择业务类型"];
        return;
    }
    if (self.judgeTextView.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"自我评价不能为空"];
        return;
    }
    [self hideKeyBoard];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:tel,@"username",self.workingYearsBtn.titleLabel.text,@"work",self.businessTypeBtn.titleLabel.text,@"wtype",self.chooseBusinessTypeBtn.titleLabel.text,@"yw_type",self.areaBtn.titleLabel.text,@"yw_quye",self.judgeTextView.text,@"content",self.certificateBtn.titleLabel.text,@"xl",nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];
    [SVProgressHUD showWithStatus:@"正在加载"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_adduserinfo", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"保存完成"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"message"]];
            }
        }
        
        NSLog(@"...responseObject  :%@",responseObject);
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
    }];
    
    [HttpRequestManager doPostOperationWithTask:_task];
}

- (IBAction)areaBtnClick:(id)sender {
    [self hideKeyBoard];
    _pickerViewType = NGSelectDataTypeArea;
    
    [self giveDataToPickerWithTypee:_pickerViewType];
    _selectedBtn = sender;
    
    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
    [_pickview showIn:self.view];
}
- (IBAction)workingYearsBtnClick:(id)sender {
    [self hideKeyBoard];
    _pickerViewType = NGSelectDataTypeworkingYears;
    
    [self giveDataToPickerWithTypee:_pickerViewType];
    _selectedBtn = sender;
    
    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
    [_pickview showIn:self.view];
}
-(void)hideKeyBoard{
    if ([self.hopeWorkingField isFirstResponder]) {
        [self.hopeWorkingField resignFirstResponder];
    }
    if ([self.judgeTextView isFirstResponder]) {
        [self.judgeTextView resignFirstResponder];
    }
}
@end
