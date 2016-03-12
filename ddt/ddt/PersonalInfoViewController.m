//
//  PersonalInfoViewController.m
//  ddt
//完善个人信心
//  Created by allen on 15/10/19.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonanlBusinessViewController.h"
#import "NGDatePicker.h"
@interface PersonalInfoViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *recommandPersonTF;

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
    UIView *_bgView;
    UIView *_maskView;
    UIDatePicker *datePicker;
    UITextField *recommandtextField;//填写推荐人
//    UILabel *dateLabel;
    
    NSString *business;//业务类型
    
    BOOL _textviewHasStart;
    NSString * _yw_content;//业务内容
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息完善";

    maleBtn.selected = YES;
    femaleBtn.selected = NO;
    _pickerViewType = NGSelectDataTypeNone;
    self.itemKey = @"11";
    
    
    UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inputBtn.frame = CGRectMake(0, 0, 100, 30);
    inputBtn.backgroundColor = [UIColor lightGrayColor];
    [inputBtn setTitle:@"完成" forState:UIControlStateNormal];
    [inputBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    inputBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [inputBtn addTarget:self action:@selector(inputbtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.InfoTextView.inputAccessoryView = inputBtn;
    _yw_content = @"";
    
    [self showDefaultData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"check_me_info"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"check_me_info"];
}

-(void)showDefaultData{
    if ([[[MySharetools shared]getNickName]length]>0) {
        nameField.text = [[MySharetools shared]getNickName];
    }
    if ([[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"xb"] isEqual:@"男"]) {
        maleBtn.selected = YES;
        femaleBtn.selected = NO;
    }else{
        maleBtn.selected = NO;
        femaleBtn.selected = YES;
    }
    if ([[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"csrq"] length]>0) {
        [birthBtn setTitle:[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"csrq"] forState:UIControlStateNormal];
    }
    
    if ([[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"weixin"] length]>0) {
        weixinField.text = [[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"weixin"];
    }
    if ([[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"company"]length]>0) {
        companyField.text = [[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"company"];
    }
    NSString *tjr = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"tjr"]];
    if (![tjr isEqual:@"(null)"]&&tjr.length>0) {
        
        self.recommandPersonTF.text = tjr;
        
//        [recommandPersonBtn setTitle:tjr forState:UIControlStateNormal];
    }
    NSString *area = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"quyu"]];
    [serviceAreaBtn setTitle:area forState:UIControlStateNormal];
    
    business = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"yewu"]];
    [bussinessSortBtn setTitle:business forState:UIControlStateNormal];
    bussinessSortBtn.titleLabel.numberOfLines = 0;

    keyWordField.text = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"word"]];
    NSString *content = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo]objectForKey:@"content"]];
    if (![content isEqual:@"(null)"]&&content.length>0) {
        InfoTextView.text = content;
    }else{
        [self textviewDetaultDisp:YES];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row) {
        case 6:
        {
            CGSize size = [ToolsClass calculateSizeForText:business :CGSizeMake(CurrentScreenWidth - 100, 800) font:[UIFont systemFontOfSize:14]];
            return size.height > 50?size.height + 20:60;
        }break;
        case 8:return 90;break;
        case 9:return 80;break;
        default: return 50;
            break;
    }
    
    return 50;
    
}


- (IBAction)birthBtnClick:(id)sender {
    [self initViews];
    [self hideKeyboard];
}

-(void)hideKeyboard{
    if ([nameField isFirstResponder]) {
        [nameField resignFirstResponder];
    }
    if ([weixinField isFirstResponder]) {
        [weixinField resignFirstResponder];
    }
    if ([companyField isFirstResponder]) {
        [companyField resignFirstResponder];
    }
    if ([keyWordField isFirstResponder]) {
        [keyWordField resignFirstResponder];
    }
    if ([InfoTextView isFirstResponder]) {
        [InfoTextView resignFirstResponder];
    }
}
- (IBAction)recommandPersonBtnClick:(id)sender {
    _maskView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = .3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [_maskView addGestureRecognizer:tap];
    [self.window addSubview:_maskView];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(20, (CurrentScreenHeight-80)/2-40, CurrentScreenWidth-40, 80)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.cornerRadius = 2;
    _bgView.layer.masksToBounds = YES;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, 35)];
    label.text = @"推荐人:";
    label.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:label];
    recommandtextField = [[UITextField alloc]initWithFrame:CGRectMake(label.right+5, 6, _bgView.width-label.width-10, 35)];
    recommandtextField.delegate = self;
    [_bgView addSubview:recommandtextField];
    UIImageView *midLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, _bgView.width, 0.5)];
    midLine.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:midLine];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(_bgView.width/2, 40.5, _bgView.width/2, 40);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [okBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(recommandBtnOKClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 40.5, _bgView.width/2, 40);
    [cancelBtn addTarget:self action:@selector(recommandBtnCancleClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.window addSubview:_bgView];
}
- (void)recommandBtnOKClick{
    [self disappear];
    [recommandPersonBtn setTitle:recommandtextField.text forState:UIControlStateNormal];
}
- (void)recommandBtnCancleClick{
    [self disappear];
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
    __weak typeof(self)weakSelf = self;
    
    PersonanlBusinessViewController *person = [[PersonanlBusinessViewController alloc]init];
    person.hidesBottomBarWhenPushed = YES;
    person.btnClickBlock = ^(NSString *name){
        [bussinessSortBtn setTitle:name forState:UIControlStateNormal];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:person animated:YES];
}

#pragma mark---保存用户信息
- (IBAction)saveInfoBtnClick:(id)sender {
    [self hideKeyboard];
    if (nameField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"姓名不能为空"];
        return;
    }
    if ([birthBtn.titleLabel.text isEqual:@"点击选择"]||birthBtn.titleLabel.text.length ==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择生日"];
        return;
    }
    if (weixinField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写微信"];
        return;
    }
    if (companyField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写公司"];
        return;
    }
//    if ([recommandPersonBtn.titleLabel.text isEqual:@"填写推荐人"]||recommandPersonBtn.titleLabel.text.length==0) {
//        [SVProgressHUD showInfoWithStatus:@"填写推荐人"];
//        return;
//    }
    if (self.recommandPersonTF.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"填写推荐人"];
        return;
    }
    
    if ([serviceAreaBtn.titleLabel.text isEqual:@"选择服务区域"]||serviceAreaBtn.titleLabel.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择服务区域"];
        return;
    }
    if ([bussinessSortBtn.titleLabel.text isEqual:@"点击选择业务分类"]||bussinessSortBtn.titleLabel.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择业务分类"];
        return;
    }
    if (keyWordField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写关键词"];
        return;
    }
    if (InfoTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写业务内容"];
        return;
    }
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSString *xb = @"";
    if (self.maleBtn.selected == YES) {
        xb = @"男";
    }else{
        xb = @"女";
    }
    
    NetIsReachable;
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:tel,@"username",nameField.text,@"xm",xb,@"xb",birthBtn.titleLabel.text,@"csrq",weixinField.text,@"weixin",companyField.text,@"company",bussinessSortBtn.titleLabel.text,@"yewu",serviceAreaBtn.titleLabel.text,@"quyu",InfoTextView.text,@"content",keyWordField.text,@"word",self.recommandPersonTF.text,@"tjr", nil];
    
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];
    [SVProgressHUD showWithStatus:@"数据提交中"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_adduserinfo", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [[NSUserDefaults standardUserDefaults]setObject:nameField.text forKey:@"nickName"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MySharetools shared]getLoginSuccessInfo]];
                [dict setObject:xb forKey:@"xb"];
                [dict setObject:birthBtn.titleLabel.text forKey:@"csrq"];
                [dict setObject:weixinField.text forKey:@"weixin"];
                [dict setObject:companyField.text forKey:@"company"];
//                [dict setObject:recommandPersonBtn.titleLabel.text forKey:@"tjr"];
               [dict setObject:self.recommandPersonTF.text forKey:@"tjr"];
                [dict setObject:serviceAreaBtn.titleLabel.text forKey:@"quyu"];
                [dict setObject:bussinessSortBtn.titleLabel.text forKey:@"yewu"];
                [dict setObject:keyWordField.text forKey:@"word"];
                [dict setObject:InfoTextView.text forKey:@"content"];
                [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"loginSuccessInfo"];
                [[NSUserDefaults standardUserDefaults]synchronize];
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


-(void)initViews{
    _maskView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = .3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [_maskView addGestureRecognizer:tap];
    [self.window addSubview:_maskView];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CurrentScreenHeight-280, CurrentScreenWidth, 280)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 2;
    _bgView.layer.masksToBounds = YES;
    
    UIButton*_btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel addTarget:self action:@selector(btncancel:) forControlEvents:UIControlEventTouchUpInside];
    _btnCancel.frame = CGRectMake(0, 0, 60, 35);
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_btnCancel];
    UIButton*_btnok = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnok addTarget:self action:@selector(btnok:) forControlEvents:UIControlEventTouchUpInside];
    _btnok.frame = CGRectMake(CurrentScreenWidth - 60, 0, 60, 35);
    [_btnok setTitle:@"确定" forState:UIControlStateNormal];
    [_btnok setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btnok.titleLabel.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_btnok];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, CurrentScreenWidth, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    datePicker.maximumDate = [NSDate date];
    
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:datePicker];
    [self.window addSubview:_bgView];
}
-(void)dateChanged:(UIDatePicker *)control{
    NSDate *_date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_date];
}
-(void)disappear{
    [_bgView removeFromSuperview];
    [_maskView removeFromSuperview];
}
-(void)btncancel:(UIButton*)btn
{
    [self disappear];
}
-(void)btnok:(UIButton*)btn
{
    [self disappear];
    NSDate *_date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_date];
    [birthBtn setTitle:dateString forState:UIControlStateNormal];
}
-(void)alertPop{
    if (nameField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"姓名不能为空"];
        return;
    }
    if ([birthBtn.titleLabel.text isEqual:@"点击选择"]||birthBtn.titleLabel.text.length ==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择生日"];
        return;
    }
    if (weixinField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写微信"];
        return;
    }
    if (companyField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写公司"];
        return;
    }
    if ([recommandPersonBtn.titleLabel.text isEqual:@"填写推荐人"]||recommandPersonBtn.titleLabel.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"填写推荐人"];
        return;
    }
    if ([serviceAreaBtn.titleLabel.text isEqual:@"选择服务区域"]||serviceAreaBtn.titleLabel.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择服务区域"];
        return;
    }
    if ([bussinessSortBtn.titleLabel.text isEqual:@"点击选择业务分类"]||bussinessSortBtn.titleLabel.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择业务分类"];
        return;
    }
    if (keyWordField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写关键词"];
        return;
    }
    if (InfoTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写业务内容"];
        return;
    }
}


//textview相关方法
-(void)inputbtnAction
{
    if (!_textviewHasStart || self.InfoTextView.text.length < 1) {
        [self textviewDetaultDisp:YES];
    }
    [self.InfoTextView resignFirstResponder];
}

-(void)textviewDetaultDisp:(BOOL)has
{
//    if (has) {
//        self.InfoTextView.text = @"请输入你的业务内容和详细描述.";
//        self.InfoTextView.textColor = [UIColor lightGrayColor];
//        _textviewHasStart = NO;
//    }
//    else
//    {
//        self.InfoTextView.text = @"";
//        self.InfoTextView.textColor = [UIColor blackColor];
//        _textviewHasStart = YES;
//    }
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



@end
