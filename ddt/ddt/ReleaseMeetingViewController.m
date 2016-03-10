//
//  ReleaseMeetingViewController.m
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//
#import "ReleaseMeetingViewController.h"

@interface ReleaseMeetingViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIView *_bgView;
    UIView *_maskView;
    UIDatePicker *datePicker;
}
@end

@implementation ReleaseMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    self.backView.layer.borderWidth = 1;
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    
    [self createRightBarItemWithBackTitle:@"发布" andImageName:nil];
    self.introTextView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)moreAction:(UIBarButtonItem *)barButtonItem{
    if (self.titleField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入会议标题"];
        return;
    }
    if(self.addressField.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入会议地点"];
        return;
    }
    if ([self.meetingTimeBtn.titleLabel.text isEqual:@"选择会议时间"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择会议时间"];
        return;
    }
    if (self.introTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请录入会议说明"];
        return;
    }
    
    NetIsReachable;
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    //NSString *nickName = [[MySharetools shared]getNickName];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:tel,@"mobile",tel,@"username",self.titleField.text,@"m_title",self.addressField.text,@"m_address",self.meetingTimeBtn.titleLabel.text,@"m_time",self.introTextView.text,@"content", nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];
    [SVProgressHUD showWithStatus:@"正在加载"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_addmeeting", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                [MobClick event:@"event_dis_jiaoliuhui"];
                
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

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)meetingBtnClick:(id)sender {
    [self initViews];
    [self hideKeyboard];
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
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    //[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:datePicker];
    [self.window addSubview:_bgView];
    
    
    UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inputBtn.frame = CGRectMake(0, 0, 100, 30);
    inputBtn.backgroundColor = [UIColor lightGrayColor];
    [inputBtn setTitle:@"完成" forState:UIControlStateNormal];
    [inputBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    inputBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [inputBtn addTarget:self action:@selector(inputbtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.introTextView.inputAccessoryView = inputBtn;
}

//textview相关方法
-(void)inputbtnAction
{
    if (self.introTextView.text.length<1) {
        self.placeHolderLabel.hidden = NO;
    }
    [self.introTextView resignFirstResponder];
}


-(void)disappear{
    [_bgView removeFromSuperview];
    [_maskView removeFromSuperview];
}
-(void)hideKeyboard{
    if ([self.titleField isFirstResponder]) {
        [self.titleField resignFirstResponder];
    }
    if ([self.addressField isFirstResponder]) {
        [self.addressField  resignFirstResponder];
    }
    if ([self.introTextView isFirstResponder]) {
        [self.introTextView resignFirstResponder];
    }
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:_date];
    NSLog(@"%@",dateString);
    [self.meetingTimeBtn setTitle:dateString forState:UIControlStateNormal];
    [self.meetingTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

@end
