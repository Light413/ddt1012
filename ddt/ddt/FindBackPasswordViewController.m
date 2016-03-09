//
//  FindBackPasswordViewController.m
//  ddt
//
//  Created by allen on 15/10/16.
//  Copyright (c) 2015年 Light. All rights reserved.22916545
//

#import "FindBackPasswordViewController.h"

@interface FindBackPasswordViewController ()<UITextFieldDelegate>

@end

@implementation FindBackPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贷易通";
    [self creatViews];
    // Do any additional setup after loading the view.
}
-(void)creatViews{
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, CurrentScreenWidth-20, 40)];
    phoneView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    phoneView.layer.borderWidth = 1;
    phoneView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneView.left+3, 5, 50, 30)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.text = @"手 机:";
    nameLabel.textColor = [UIColor blackColor];
    [phoneView addSubview:nameLabel];
    UITextField *phoneNumberField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 5, phoneView.width-nameLabel.width-15, 30)];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.tag = 201;
    phoneNumberField.clearsOnBeginEditing = YES;
    phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumberField.placeholder = @"请输入注册时手机号码";
    phoneNumberField.font = [UIFont systemFontOfSize:13];
    phoneNumberField.delegate = self;
    [phoneView addSubview:phoneNumberField];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, phoneView.bottom+3, CurrentScreenWidth-30, 30)];
    label.text = @"密码会发送到注册时的手机号码";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    
    UIButton *findpassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findpassBtn.backgroundColor = BarDefaultColor;
    findpassBtn.frame = CGRectMake(10, label.bottom+10, CurrentScreenWidth-20, 30);
    [findpassBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findpassBtn addTarget:self action:@selector(findOK:) forControlEvents:UIControlEventTouchUpInside];
    findpassBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    findpassBtn.layer.cornerRadius = 5;
    findpassBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:phoneView];
    [self.view addSubview:label];
    [self.view addSubview:findpassBtn];
}
-(void)goback:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)findOK:(UIButton *)btn{
    UITextField *phoneNumberField = (UITextField *)[self.view viewWithTag:201];
    if (![[MySharetools shared]isMobileNumber:phoneNumberField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    NetIsReachable;
    NSString *nickName = [[MySharetools shared]getNickName];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:nickName,@"username",phoneNumberField.text,@"mobile", nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];
    [SVProgressHUD showWithStatus:@"正在加载"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_findpwd", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                
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
