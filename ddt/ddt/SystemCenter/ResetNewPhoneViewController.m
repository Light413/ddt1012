//
//  ResetNewPhoneViewController.m
//  ddt
//
//  Created by huishuyi on 15/11/7.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "ResetNewPhoneViewController.h"

@interface ResetNewPhoneViewController ()
{
    NSTimer *_timer;
    int count ;
}
@end

@implementation ResetNewPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码修改";
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
    UITextField *phoneNumberField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 6, phoneView.width-nameLabel.width-3, 30)];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.placeholder = @"请输入新的手机号:";
    phoneNumberField.tag = 201;
    phoneNumberField.font = [UIFont systemFontOfSize:14];
    phoneNumberField.delegate = self;
    [phoneView addSubview:phoneNumberField];
    
    UIImageView *midLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, phoneView.width, 0.5)];
    midLine.backgroundColor = [UIColor lightGrayColor];
    [phoneView addSubview:midLine];
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(phoneView.left+3, 46, 60, 30)];
    nameLabel1.font = [UIFont systemFontOfSize:14];
    nameLabel1.text = @"验证码:";
    nameLabel1.textColor = [UIColor blackColor];
    [phoneView addSubview:nameLabel1];
    UITextField *phoneNumberField1 = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 47, phoneView.width-nameLabel.width-3, 30)];
    phoneNumberField1.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField1.tag = 201;
    phoneNumberField1.placeholder = @"请输入6位验证码";
    phoneNumberField1.font = [UIFont systemFontOfSize:14];
    phoneNumberField1.delegate = self;
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
    [findpassBtn addTarget:self action:@selector(findOK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneView];
    [self.view addSubview:findpassBtn];
    
    //[[NSTimer alloc]initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(verifyBtnChange) userInfo:nil repeats:60];
}
-(void)verifyBtnClick:(UIButton *)btn{
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
-(void)findOK:(UIButton *)btn{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
