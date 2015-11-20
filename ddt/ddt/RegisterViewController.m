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
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    confirmPasswordField.secureTextEntry = YES;
    confirmPasswordField.delegate = self;
    mailField.delegate = self;
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

#pragma mark --注册操作
- (IBAction)registerBtnClick:(id)sender {
    //    jsondata={"mobile":"15136216190","pwd":"111","token":"15136216190(!)*^*1446701200"
    if (![[MySharetools shared]isMobileNumber:phoneNumField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填入正确的手机号"];
        return;
    }
    if (passwordField.text.length ==0) {
        [SVProgressHUD showInfoWithStatus:@"请填入密码"];
        return;
    }
    if (confirmPasswordField.text.length ==0) {
        [SVProgressHUD showInfoWithStatus:@"请填入密码"];
        return;
    }
    if (![passwordField.text isEqual:confirmPasswordField.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次密码输入不同，请重新输入"];
        return;
    }
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSString *token = [NSString stringWithFormat:@"%@(!)*^*%@",phoneNumField.text,timeString];
    //...test
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumField.text,@"mobile",[passwordField.text  stringFromMD5],@"pwd",token,@"token",nil];
    NSString *jsonStr = [NSString jsonStringFromDictionary:dic1];
    
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:jsonStr,@"jsondata", nil];
//    [SVProgressHUD showWithStatus:@"正在提交"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_register", @"") parms:dic2 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"...responseObject  :%@",responseObject);
        
        if ([[responseObject objectForKey:@"result"]integerValue] == 0) {
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
  [self.navigationController dismissViewControllerAnimated:YES completion:^{
      
  }];
}

- (IBAction)registerProtocol:(id)sender {
    ServiceProtocolViewController *service = [[ServiceProtocolViewController alloc]init];
    service.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:service animated:YES];
}

- (IBAction)verifyNumBtnClick:(id)sender {
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
