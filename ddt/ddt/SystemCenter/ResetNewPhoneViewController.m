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
    [findpassBtn addTarget:self action:@selector(findOK:) forControlEvents:UIControlEventTouchUpInside];
    findpassBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    findpassBtn.layer.cornerRadius = 5;
    findpassBtn.layer.masksToBounds = YES;
    verifyBtn.layer.cornerRadius = 5;
    verifyBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:phoneView];
    [self.view addSubview:findpassBtn];

}

-(void)verifyBtnClick:(UIButton *)btn{
    btn.backgroundColor = RGBA(235, 235, 235, 1.0);
    count = 60;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verifyBtnChange:) userInfo:nil repeats:YES];
    }
}
-(void)verifyBtnChange:(NSTimer *)timer{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    UIButton *btn = (UIButton *)[self.view viewWithTag:101];
    NSString *username = [[MySharetools shared]getPhoneNumber];
    NSString *tel = phoneNumberField.text;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tel,@"mobile",username,@"username",nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];
    RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_findpwd", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] ==0) {
                
            }else{
                
            }
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
        
    }];
    //[myTableView reloadData];
    [HttpRequestManager doPostOperationWithTask:task];
    
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
    
//    [SVProgressHUD showWithStatus:@"正在加载数据"];
//    NSString *username = [[MySharetools shared]getPhoneNumber];
//    NSString *tel = phoneNumberField.text;
//    NSString *yzm = phoneNumberField1.text;
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tel,@"mobile",username,@"username",yzm,@"yzm",nil];
//    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];;
//    
//    RequestTaskHandle *task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_findpwd", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            if ([[responseObject objectForKey:@"result"] integerValue] ==0) {
//                
//            }
//            
//            
//        }
//    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
//        
//    }];
//    //[myTableView reloadData];
//    [HttpRequestManager doPostOperationWithTask:task];
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
