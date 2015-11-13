//
//  AddCommanyInfoViewController.m
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "AddCommanyInfoViewController.h"
#import "PersonanlBusinessViewController.h"
@interface AddCommanyInfoViewController ()<UITextViewDelegate>

@end
typedef NS_ENUM(NSUInteger, NGSelectDataType) {
    NGSelectDataTypeNone,  //0
    NGSelectDataTypeBusiness,     //选择业务
    NGSelectDataTypeworkingYears, //选择业务类型
    NGSelectDataTypeSalary,//工资
    NGSelectDataTypeArea//工作区域
};
@implementation AddCommanyInfoViewController
{
    NSArray *_pickViewDataArr;
    
    NGSelectDataType _pickerViewType;
    UIButton *_selectedBtn;//当前被选中的btn
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)serviceAreaBtnClick:(id)sender {
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

- (IBAction)chooseBusinessTypeBtnClick:(id)sender {
    PersonanlBusinessViewController *person = [[PersonanlBusinessViewController alloc]init];
    person.hidesBottomBarWhenPushed = YES;
    person.btnClickBlock = ^(NSString *name){
        [self.chooseBusinessTypeBtn setTitle:name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:person animated:YES];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.backHolderLabel.hidden = YES;
    }else{
        self.backHolderLabel.hidden = NO;
    }
}
- (IBAction)summitBtnClick:(id)sender {
    if (self.luruCommanynameField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入公司名称"];
        return;
    }
    if (self.addresscommanyNameField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入公司地址"];
        return;
    }
    if (self.jigouCodeFIeld.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入组织机构代码"];
        return;
    }
    if (self.contactorField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系人"];
        return;
    }
    if (self.phoneField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入电话"];
        return;
    }
    if (self.serviceAreaBtn.titleLabel.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请选择服务区域"];
        return;
    }
    if ([self.chooseBusinessTypeBtn.titleLabel.text isEqual:@"点击选择业务类型"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择业务类型"];
        return;
    }
    if (self.keywordField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入自设关键词"];
        return;
    }
    if (self.judgeTextView.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入业务内容"];
        return;
    }
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    //NSString *nickName = [[MySharetools shared]getNickName];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:tel,@"username",self.luruCommanynameField.text,@"commany",self.addresscommanyNameField.text,@"m_address",self.jigouCodeFIeld.text,@"orgenum",self.contactorField.text,@"lxr",self.phoneField.text,@"phone",self.keywordField.text,@"word",self.chooseBusinessTypeBtn.titleLabel.text,@"yewu",self.serviceAreaBtn.titleLabel.text,@"quyu",self.judgeTextView.text,@"content", nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];
    [SVProgressHUD showWithStatus:@"正在加载"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_addcompany", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"已提交审核"];                
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
@end
