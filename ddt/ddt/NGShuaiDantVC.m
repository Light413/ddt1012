//
//  NGShuaiDantVC.m
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGShuaiDantVC.h"
#import "PersonanlBusinessViewController.h"

#define btnbasetag  330

typedef NS_ENUM(NSUInteger, NGSelectDataType) {
    NGSelectDataTypeNone,  //0
    NGSelectDataTypeAge,   //年龄
    NGSelectDataTypeTDaikuan, //贷款金额
    NGSelectDataTypeTDaikuanTime,//贷款期限
    NGSelectDataTypeYwlx, //选择业务类型
    NGSelectDataTypeArea  //选择区域数据
};


@interface NGShuaiDantVC ()<UITextFieldDelegate,UITextViewDelegate,pickViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL _textviewHasStart;
    LPickerView * _pickview;
    
    NSString * _kehusf;//客户身份
    NSArray *_kehusfArr;
    NSString * _zxstatus;//征信状态
    NSArray *_zxstatusArr;
    
    NSArray * _pickViewDataArr;//pickview dataSource
    UIButton *_selectedBtn;//选择的btn
    
    NSString * _sss;
}

@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_age;
@property (weak, nonatomic) IBOutlet UIButton *btn_jine;
@property (weak, nonatomic) IBOutlet UIButton *btn_timelimit;
@property (weak, nonatomic) IBOutlet UIButton *btn_yewutype;
@property (weak, nonatomic) IBOutlet UIButton *btn_area;
@property (weak, nonatomic) IBOutlet UITextField *tf_jifen;

@property (weak, nonatomic) IBOutlet UIView *textviewbg;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *textviewDeleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *textviewNumLab;
@end

@implementation NGShuaiDantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}

-(void)initSubviews
{
    self.textviewbg.layer.borderWidth = 1;
    self.textviewbg.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.textviewbg.layer.cornerRadius = 5;
    self.textviewbg.layer.masksToBounds = YES;
    self.btn_area.titleLabel.numberOfLines = 0;
    
    UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inputBtn.frame = CGRectMake(0, 0, 100, 30);
    inputBtn.backgroundColor = [UIColor lightGrayColor];
    [inputBtn setTitle:@"完成" forState:UIControlStateNormal];
    [inputBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    inputBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [inputBtn addTarget:self action:@selector(inputbtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.textview.inputAccessoryView = inputBtn;
    [self textviewDetaultDisp:YES];

    _kehusfArr = @[@"上班",@"个体",@"企业"];
    _zxstatusArr =@[@"正常",@"异常",@"白户"];
    
    self.tf_jifen.keyboardType = UIKeyboardTypeNumberPad;
}

//textview相关方法
-(void)inputbtnAction
{
    if (!_textviewHasStart || self.textview.text.length < 1) {
        [self textviewDetaultDisp:YES];
    }
    [self.textview resignFirstResponder];
}

-(void)textviewDetaultDisp:(BOOL)has
{
    if (has) {
        self.textview.text = @"详细说明: 户口所在地、社保、公积金、保单、资产情况、负债情况、工资形式、工资金额、工作年限、流水金额、借款用途、还款来源等详细说明。不要出现电话号码、QQ等其他联系方式";
        self.textview.textColor = [UIColor lightGrayColor];
            _textviewHasStart = NO;
    }
    else
    {
        self.textview.text = @"";
        self.textview.textColor = [UIColor blackColor];
            _textviewHasStart = YES;
    }
}


-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark -- btn action
//选择客户身份和征信状态
-(void)kehuisf_select:(UIButton*)btn withstartfirst:(BOOL)isfirst
{
    NSInteger starttag = isfirst ? btnbasetag : btnbasetag+8;
    
    btn.selected = !btn.selected;
    for (int i =0; i < 3; i++) {
      UIButton *tmp = (UIButton *) [self.tableView viewWithTag:i + starttag];
        tmp == btn?1: (tmp.selected = NO);
    }
    
    isfirst ? ( {_kehusf = btn.selected? _kehusfArr[btn.tag - starttag]  :nil;}):({_zxstatus = btn.selected? _zxstatusArr[btn.tag - starttag]  :nil;});
    
    NSLog(@"...kehushenfen : %@",_zxstatus);
}


- (IBAction)btnClickAction:(UIButton *)sender {
    BOOL needpickview = NO;

    if (self.tf_jifen.isFirstResponder) {
        [self.tf_jifen resignFirstResponder];
    }
    else if (self.tf_name.isFirstResponder)
    {
        [self.tf_name resignFirstResponder];
    }
    
    switch (sender.tag - btnbasetag) {
        case 0://客户身份
        case 1:
        case 2:[self kehuisf_select:sender withstartfirst:YES];break;
         
        case 3://年龄
        {
          _pickViewDataArr =  [DTComDataManger getData_age];
            needpickview = YES;
        }break;
        case 4://贷款金额
        {
            _pickViewDataArr =  [DTComDataManger getData_daikuanjine];
              needpickview = YES;
        }break;
        case 5://贷款期限
        {
            _pickViewDataArr =  [DTComDataManger getData_daikuanTime];
              needpickview = YES;
        }break;
        case 6://业务类型
        {
            PersonanlBusinessViewController *person = [[PersonanlBusinessViewController alloc]init];
            person.btnClickBlock = ^(NSString *name){
                [sender setNormalTitle:name andID:@"ok"];
                _sss = name;
                NSLog(@"1...btn title  :%@",name);
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:person animated:YES];
        }break;
        case 7://区域
        {
            _pickViewDataArr =  [NGXMLReader getCurrentLocationAreas];
              needpickview = YES;
        }break;
            
        case 8://征信状态
        case 9:
        case 10:[self kehuisf_select:sender withstartfirst:NO];break;
            
        case 11:[self textviewDetaultDisp:YES];break;
        default:break;
    }
    
    if (needpickview) {
        _selectedBtn = sender;
        _pickview = [[LPickerView alloc]initWithDelegate:self];
        [_pickview showIn:self.view];
        needpickview = NO;
        self.tableView.scrollEnabled = NO;
    }

}

//立即甩单操作
- (IBAction)submintAction:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if ([self checkAllDataIsValid]) {
       //所有参数都合法
        
    }
    
}

//检测参数有效性
-(BOOL)checkAllDataIsValid
{
    if (self.tf_name.text.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请输入客户名称"];
        return NO;
    }else if (_kehusf == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入客户身份"];
        return NO;
    }
    else if (self.btn_age.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择年龄"];
        return NO;
    }
    else if (self.btn_jine.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择贷款金额"];
        return NO;
    }
    else if (self.btn_timelimit.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择贷款期限"];
        return NO;
    }
    else if (self.btn_yewutype.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择业务类型"];
        return NO;
    }
    else if (self.btn_area.ID == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择区域"];
        return NO;
    }
    
    else if (_zxstatus == nil)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择征信状态"];
        return NO;
    }
    else if (self.textview.text.length < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请填写详细说明"];
        return NO;
    }
    else if (self.tf_jifen.text.length < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请填写接单积分"];
        return NO;
    }
    
    return YES;
}


#pragma mark --UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    if (textView.text.length<=100) {
        self.textviewNumLab.text = [NSString stringWithFormat:@"%ld/100",textView.text.length];
    }else{
        self.textviewNumLab.text = @"100/100";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>=100) {
        return NO;
    }else{
        return YES;
    }
}


#pragma mark- UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float _h = 50.0;
    switch (indexPath.row) {
        case 0:break;
        case 1:break;
        case 2:break;
        case 3:break;
        case 4:break;
        case 6:break;
        case 7:break;
        case 9: break;
        case 5://业务类型
        {
           CGSize size = [ToolsClass calculateSizeForText:_sss :CGSizeMake(CurrentScreenWidth - 100, 300) font:[UIFont systemFontOfSize:14]];
            return size.height > 50?size.height + 20:60;
            return _h = 100;
        }break;
        case 8:return 120;break;
        case 10:return 80;break;
        default: break;
    }
    
    return _h;
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
