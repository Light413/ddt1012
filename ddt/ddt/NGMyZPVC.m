//
//  NGMyZPVC.m
//  ddt
//
//  Created by wyg on 15/12/13.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGMyZPVC.h"

@interface NGMyZPVC ()<UITextFieldDelegate,UITextViewDelegate,pickViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_zhiwei;
@property (weak, nonatomic) IBOutlet UITextField *tf_zpnum;
@property (weak, nonatomic) IBOutlet UITextField *tf_gsname;

@property (weak, nonatomic) IBOutlet UITextField *tf_addr;
@property (weak, nonatomic) IBOutlet UITextField *tf_lxr;
@property (weak, nonatomic) IBOutlet UITextField *tf_lxr_tel;


@property (weak, nonatomic) IBOutlet UIButton *btn_wages;
@property (weak, nonatomic) IBOutlet UIButton *btn_zhiwei_type;
@property (weak, nonatomic) IBOutlet UIButton *btn_workyear;
@property (weak, nonatomic) IBOutlet UIButton *btn_xueli;
@property (weak, nonatomic) IBOutlet UIButton *btn_area;
@property (weak, nonatomic) IBOutlet UIButton *btn_yewu_type;
@property (weak, nonatomic) IBOutlet UITextView *text_detail;

@end

@implementation NGMyZPVC
{
    BOOL _textviewHasStart;
    
    LPickerView * _pickview;
    NSArray * _pickViewDataArr;//pickview dataSource
    UIButton *_selectedBtn;//选择的btn
    UITextField *_current_tf;//当前正在输入的tf
    
    NSString * _yewu_type;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

-(void)initSubviews
{
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    
    UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inputBtn.frame = CGRectMake(0, 0, 100, 30);
    inputBtn.backgroundColor = [UIColor lightGrayColor];
    [inputBtn setTitle:@"完成" forState:UIControlStateNormal];
    [inputBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    inputBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [inputBtn addTarget:self action:@selector(inputbtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.text_detail.inputAccessoryView = inputBtn;
    [self textviewDetaultDisp:YES];
    
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClick)];
    [rightitem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightitem;
}

#pragma mark --发布
-(void)rightItemClick
{
    if (![self checkAllDataIsValid]) {
        return;
    }
    
    
    NSString *tel = [[MySharetools shared]getPhoneNumber];
//    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:tel,@"mobile",tel,@"username",self.titleField.text,@"m_title",self.addressField.text,@"m_address",self.meetingTimeBtn.titleLabel.text,@"m_time",self.introTextView.text,@"content", nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:nil];
    [SVProgressHUD showWithStatus:@"正在提交"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_add_zhaopin", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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



- (IBAction)btnAction:(UIButton *)sender {
    if (_current_tf && [_current_tf isFirstResponder]) {
        [_current_tf resignFirstResponder];
    }
    
    BOOL needpickview = YES;
    
    switch (sender.tag) {
        case 120://薪资
               _pickViewDataArr =  [DTComDataManger getData_qwxz]; 
            break;
        case 121://职位类别
            _pickViewDataArr =  [DTComDataManger getData_gwlx];
            break;
        case 122://工作经验
            _pickViewDataArr =  [DTComDataManger getData_gzjy];
            break;
        case 123://学历
            _pickViewDataArr =  [DTComDataManger getData_zgxl];
            break;
        case 124://区域
                _pickViewDataArr =  [NGXMLReader getCurrentLocationAreas];
            break;
        case 125://yewu
        {
            needpickview = NO;
            PersonanlBusinessViewController *person = [[PersonanlBusinessViewController alloc]init];
            person.btnClickBlock = ^(NSString *name){
                [sender setNormalTitle:name andID:@"ok"];
                _yewu_type = name;
                NSLog(@"1...btn title  :%@",name);
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:person animated:YES];
        }break;
            
        default:
            break;
    }

    
    if (needpickview) {
        _selectedBtn = sender;
        _pickview = [[LPickerView alloc]initWithDelegate:self];
        [_pickview showIn:self.view];
        needpickview = YES;
        self.tableView.scrollEnabled = NO;
    }
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _current_tf = textField;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

//textview相关方法
-(void)inputbtnAction
{
    if (!_textviewHasStart || self.text_detail.text.length < 1) {
        [self textviewDetaultDisp:YES];
    }
    [self.text_detail resignFirstResponder];
}

-(void)textviewDetaultDisp:(BOOL)has
{
    if (has) {
        self.text_detail.text = @"请输入你的招聘要求和详细职位描述.";
        self.text_detail.textColor = [UIColor lightGrayColor];
        _textviewHasStart = NO;
    }
    else
    {
        self.text_detail.text = @"";
        self.text_detail.textColor = [UIColor blackColor];
        _textviewHasStart = YES;
    }
}

#pragma mark -- UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!_textviewHasStart) {
        [self textviewDetaultDisp:NO];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text == 0) {
        [self textviewDetaultDisp:YES];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

#pragma mark-pickViewDelegate
-(void)pickerViewCanecelClick
{
    self.tableView.scrollEnabled = YES;
}

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
    self.tableView.scrollEnabled = YES;
    NSDictionary *_d = [_pickViewDataArr objectAtIndex:row];
    [_selectedBtn setNormalTitle:[_d objectForKey:@"NAME"] andID:[_d objectForKey:@"ID"]];
    _pickViewDataArr = nil;
    _selectedBtn  = nil;
}



#pragma mark- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float _h = 50.0;
    switch (indexPath.row) {
        case 10://业务类型
        {
            CGSize size = [ToolsClass calculateSizeForText:_yewu_type :CGSizeMake(CurrentScreenWidth - 100, 300) font:[UIFont systemFontOfSize:14]];
            return size.height > 50?size.height + 20:60;
        }break;
        case 11:return 80;break;
        default: break;
    }
    
    return _h;
}

//检测参数有效性
-(BOOL)checkAllDataIsValid
{
    if (self.tf_zhiwei.text.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请输入职位名称"];
        return NO;
    }
    else if (self.tf_zpnum.text.length < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入招聘人数"];
        return NO;
    }
    else if (self.btn_wages.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择工资"];
        return NO;
    }
    else if (self.btn_zhiwei_type.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入职位类别"];
        return NO;
    }
    else if (self.btn_workyear.ID ==nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请工作经验"];
        return NO;
    }
    else if (self.btn_xueli.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择学历"];
        return NO;
    }
    else if (self.tf_gsname.text.length < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入公司名称"];
        return NO;
    }
    else if (self.tf_addr.text.length < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入公司地址"];
        return NO;
    }
    else if (self.tf_lxr.text.length < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入联系人"];
        return NO;
    }
    
    else if (self.tf_lxr_tel.text.length < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入联系人电话"];
        return NO;
    }
    else if (self.btn_area.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择区域"];
        return NO;
    }
    else if (self.btn_yewu_type.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择业务类型"];
        return NO;
    }
    else if (self.text_detail.text.length < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入任职要求"];
        return NO;
    }

    return YES;
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
