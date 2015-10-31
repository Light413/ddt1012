//
//  PersonalInfoViewController.m
//  ddt
//
//  Created by allen on 15/10/19.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonanlBusinessViewController.h"
#import "NGDatePicker.h"
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
    UIView *_bgView;
    UIView *_maskView;
    UIDatePicker *datePicker;
    UITextField *recommandtextField;//填写推荐人
//    UILabel *dateLabel;
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
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(20, (CurrentScreenHeight-80)/2, CurrentScreenWidth-40, 80)];
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
    PersonanlBusinessViewController *person = [[PersonanlBusinessViewController alloc]init];
    person.hidesBottomBarWhenPushed = YES;
    person.btnClickBlock = ^(NSString *name){
        [bussinessSortBtn setTitle:name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:person animated:YES];
//    _pickerViewType = NGSelectDataTypeTaskType;
//    [self giveDataToPickerWithTypee:_pickerViewType];
//    _selectedBtn = sender;
//    LPickerView *_pickview = [[LPickerView alloc]initWithDelegate:self];
//    [_pickview showIn:self.view];
}
- (IBAction)saveInfoBtnClick:(id)sender {
    [self hideKeyboard];
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
@end
