//
//  RegisterViewController.m
//  ddt
//
//  Created by allen on 15/10/16.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+MD5Addition.h"
#import "ServiceProtocolViewController.h"
#define ViewHeight 163.0
#define space 5.0
@interface RegisterViewController ()<UITextFieldDelegate>
{
    UIView *textFieldView;
    NSTimer *_timer;
    int count ;
    
    NSString * _yzm;//生成的验证码
}
@end

@implementation RegisterViewController
@synthesize backView;
@synthesize phoneNumField;
@synthesize passwordField;
@synthesize confirmPasswordField;
@synthesize mailField;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarItemWithBackTitle];
    self.title = @"账号注册";
    backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    backView.layer.borderWidth = 1;
    [self createRegisterViews];
//    //注册键盘收起的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView *sview in self.view.subviews)
        {
            sview.transform=CGAffineTransformMakeTranslation(0, -46);
        }
    } completion:^(BOOL finished) {
    }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView *sview in self.view.subviews)
        {
            sview.transform=CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
    }];
}

-(void)createRegisterViews{
    phoneNumField.delegate = self;
    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumField.placeholder = @"请输入正确的手机号";
    
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    passwordField.placeholder = @"输入6-12位数字和字母组合";
    
    confirmPasswordField.secureTextEntry = YES;
    confirmPasswordField.delegate = self;
    confirmPasswordField.placeholder = @"请重新输入密码";
    
    mailField.placeholder = @"请输入验证码";
    mailField.delegate = self;
    
    self.verifyBtn.layer.cornerRadius = 3;
    self.verifyBtn.layer.masksToBounds = YES;
}
-(void)goback:(UIButton *)btn{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([phoneNumField isFirstResponder]) {
        [phoneNumField resignFirstResponder];
    }
    if ([passwordField isFirstResponder]) {
        [passwordField resignFirstResponder];
    }
    if ([confirmPasswordField isFirstResponder]) {
        [confirmPasswordField resignFirstResponder];
    }
    if ([mailField isFirstResponder]) {
        [mailField resignFirstResponder];
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

//判断密码是否合法
-(BOOL)isRight:(NSString*)pwd
{
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:pwd];
}

#pragma mark --注册操作
- (IBAction)registerBtnClick:(id)sender {
    //    jsondata={"mobile":"15136216190","pwd":"111","token":"15136216190(!)*^*1446701200"
    if (![[MySharetools shared]isMobileNumber:phoneNumField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填入正确的手机号"];
        return;
    }
    if (![self isRight:passwordField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入含有字母和数字的(6-12)位密码"];return;
    }
    if (![passwordField.text isEqual:confirmPasswordField.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码输入不同，请重新输入"];
        return;
    }
    if (![self.mailField.text isEqualToString:_yzm]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的验证码"];return;
    }
    
    NetIsReachable;
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSString *token = [NSString stringWithFormat:@"%@(!)*^*%@",phoneNumField.text,timeString];

    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumField.text,@"mobile",[passwordField.text  stringFromMD5],@"pwd",token,@"token",nil];
    NSString *jsonStr = [NSString jsonStringFromDictionary:dic1];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:jsonStr,@"jsondata", nil];
    
    [SVProgressHUD showWithStatus:@"正在提交"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_register", @"") parms:dic2 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"...responseObject  :%@",responseObject);
        
        if ([[responseObject objectForKey:@"result"]integerValue] == 0) {
            [MobClick event:@"event_register"];
            
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"message"]];
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"请求服务器失败,请重试"]; 
    }];
    
    [HttpRequestManager doPostOperationWithTask:_task];
}

- (IBAction)registerProtocol:(id)sender {
    ServiceProtocolViewController *service = [[ServiceProtocolViewController alloc]init];
    service.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:service animated:YES];
}


#pragma mark -- 生成验证码
-(NSString*)makeyzm
{
    NSMutableString * _s = [[NSMutableString alloc] initWithCapacity:6];
    for (int i = 0; i<6; i++) {
        NSInteger index = arc4random()%10;
        [_s appendString:[NSString stringWithFormat:@"%ld",index]];
    }
    return _s;
}

//获取验证码
- (IBAction)verifyNumBtnClick:(id)sender {
    //判断手机号
    if (![[MySharetools shared]isMobileNumber:phoneNumField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填入正确的手机号"];
        return;
    }
    //生成验证码
    _yzm = [self makeyzm];
    if (_yzm ==nil) {
        _yzm = @"134736";
    }
    
    NetIsReachable;
    //发送验证码
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSString *token = [NSString stringWithFormat:@"%@(!)*^*%@",phoneNumField.text,timeString];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumField.text,@"mobile",phoneNumField.text,@"username",_yzm,@"yzm",token,@"token",nil];
    NSString *jsonStr = [NSString jsonStringFromDictionary:dic1];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:jsonStr,@"jsondata", nil];

    RequestTaskHandle *_h = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_getcheckcode", @"") parms:dic2 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"]integerValue] ==0) {
                NSLog(@"发送验证码成功");
            }
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [HttpRequestManager doPostOperationWithTask:_h];
    
    UIButton *btn = (UIButton *)sender;
    btn.backgroundColor = RGBA(235, 235, 235, 1.0);
    count = 60;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verifyBtnChange:) userInfo:nil repeats:YES];
    }

}
-(void)verifyBtnChange:(NSTimer *)timer{
    --count;
    [self.verifyBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",count] forState:UIControlStateNormal];
    self.verifyBtn.userInteractionEnabled = NO;
    self.verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    if (count == 0) {
        [timer invalidate];
        _timer = nil;
        self.verifyBtn.backgroundColor = RGBA(229, 165, 45, 1);
        [self.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verifyBtn.userInteractionEnabled = YES;
    }
}
@end
