//
//  ResetNewPhoneViewController.m
//  ddt
//
//  Created by huishuyi on 15/11/7.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "ResetNewPhoneViewController.h"

@interface ResetNewPhoneViewController ()<UITextFieldDelegate>
{
    NSTimer *_timer;
    int count ;
    UITextField *phoneNumberField;
    UITextField *phoneNumberField1;
    
    NSString * _yzm;//生成的验证码
}
@end

@implementation ResetNewPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置手机号";
    [self creatViews];

    // Do any additional setup after loading the view.
}
-(void)creatViews{
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, CurrentScreenWidth-20, 81)];
    phoneView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    phoneView.layer.borderWidth = 1;
    phoneView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneView.left+3, 5, 60, 30)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"手机号:";
    nameLabel.textColor = [UIColor blackColor];
    [phoneView addSubview:nameLabel];
    phoneNumberField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 6, phoneView.width-nameLabel.width-3, 30)];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.placeholder = @"请输入新的手机号";
    phoneNumberField.tag = 201;
    phoneNumberField.font = [UIFont systemFontOfSize:14];
    phoneNumberField.delegate = self;
    phoneNumberField.returnKeyType = UIReturnKeyDone;
    [phoneView addSubview:phoneNumberField];
    
    UIImageView *midLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, phoneView.width, 0.5)];
    midLine.backgroundColor = [UIColor lightGrayColor];
    [phoneView addSubview:midLine];
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(phoneView.left+3, 46, 60, 30)];
    nameLabel1.font = [UIFont systemFontOfSize:14];
    nameLabel1.text = @"验证码:";
    nameLabel1.textColor = [UIColor blackColor];
    [phoneView addSubview:nameLabel1];
    phoneNumberField1 = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 47, phoneView.width-nameLabel.width-3, 30)];
    phoneNumberField1.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField1.tag = 201;
    phoneNumberField1.placeholder = @"请输入6位验证码";
    phoneNumberField1.font = [UIFont systemFontOfSize:14];
    phoneNumberField1.delegate = self;
    phoneNumberField1.returnKeyType = UIReturnKeyDone;
    [phoneView addSubview:phoneNumberField1];
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyBtn.frame = CGRectMake(phoneView.width-110, 45, 100, 30);
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    verifyBtn.backgroundColor = RGBA(229, 165, 45, 1);
    verifyBtn.tag = 101;
    [verifyBtn addTarget:self action:@selector(verifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:verifyBtn];
    
    UIButton *findpassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findpassBtn.backgroundColor = RGBA(229, 165, 45, 1);
    findpassBtn.frame = CGRectMake(10, phoneView.bottom+10, CurrentScreenWidth-20, 30);
    [findpassBtn setTitle:@"提交" forState:UIControlStateNormal];
    [findpassBtn addTarget:self action:@selector(resetTel:) forControlEvents:UIControlEventTouchUpInside];
    findpassBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    findpassBtn.layer.cornerRadius = 5;
    findpassBtn.layer.masksToBounds = YES;
    verifyBtn.layer.cornerRadius = 5;
    verifyBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:phoneView];
    [self.view addSubview:findpassBtn];

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

-(void)verifyBtnClick:(UIButton *)btn{
    //判断手机号
    if (![[MySharetools shared]isMobileNumber:phoneNumberField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填入正确的手机号"];
        return;
    }
    //生成验证码
    _yzm = [self makeyzm];
    if (_yzm ==nil) {
        _yzm = @"134736";
    }
    //发送验证码
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSString *token = [NSString stringWithFormat:@"%@(!)*^*%@",phoneNumberField.text,timeString];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumberField.text,@"mobile",phoneNumberField.text,@"username",_yzm,@"yzm",token,@"token",nil];
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
    
    btn.backgroundColor = RGBA(235, 235, 235, 1.0);
    count = 60;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verifyBtnChange:) userInfo:nil repeats:YES];
    }
}
-(void)verifyBtnChange:(NSTimer *)timer{
    UIButton *btn = (UIButton *)[self.view viewWithTag:101];
    
    --count;
    [btn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",count] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    if (count == 0) {
        [timer invalidate];
        _timer = nil;
        btn.backgroundColor = RGBA(229, 165, 45, 1);
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
    }
}

-(void)goback:(UIButton *)btn{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --提交
-(void)resetTel:(UIButton *)btn{
    if (![[MySharetools shared]isMobileNumber:phoneNumberField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请填入正确的手机号"];
        return;
    }
    if (![phoneNumberField1.text isEqualToString:_yzm]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的验证码"];return;
    }
    
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:tel,@"username",phoneNumberField.text,@"mobile", nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];
    [SVProgressHUD showWithStatus:@"正在提交"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_resetphone", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
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

#pragma mark -- uitextfield method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITextField *textField = (UITextField *)[self.view viewWithTag:201];
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
