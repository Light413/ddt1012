//
//  ModifyPasswordViewController.m
//  ddt
//
//  Created by huishuyi on 15/10/27.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "NSString+MD5Addition.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>
{
    UITextField *phoneNumberField;
    UITextField *phoneNumberField1;
}
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码修改";
    [self createLeftBarItemWithBackTitle];
    [self creatViews];
    // Do any additional setup after loading the view.
}
-(void)creatViews{
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, CurrentScreenWidth-20, 81)];
    phoneView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    phoneView.layer.borderWidth = 1;
    phoneView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(phoneView.left+3, 5, 65, 30)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.text = @"新的密码:";
    nameLabel.textColor = [UIColor darkGrayColor];
    [phoneView addSubview:nameLabel];
    phoneNumberField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 6, phoneView.width-nameLabel.width-3, 30)];
//    phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    phoneNumberField.placeholder = @"输入6-12位数字和字母组合";
    phoneNumberField.tag = 201;
    phoneNumberField.font = [UIFont systemFontOfSize:14];
    phoneNumberField.delegate = self;
    phoneNumberField.returnKeyType = UIReturnKeyDone;
    [phoneView addSubview:phoneNumberField];
    
    UIImageView *midLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, phoneView.width, 0.5)];
    midLine.backgroundColor = [UIColor lightGrayColor];
    [phoneView addSubview:midLine];
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(phoneView.left+3, 46, 65, 30)];
    nameLabel1.font = [UIFont systemFontOfSize:13];
    nameLabel1.text = @"确认密码:";
    nameLabel1.textColor = [UIColor darkGrayColor];
    [phoneView addSubview:nameLabel1];
    phoneNumberField1 = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 47, phoneView.width-nameLabel.width-3, 30)];
//    phoneNumberField1.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField1.tag = 201;
    phoneNumberField1.placeholder = @"再次输入新密码";
    phoneNumberField1.font = [UIFont systemFontOfSize:14];
    phoneNumberField1.delegate = self;
    phoneNumberField1.secureTextEntry = YES;
    phoneNumberField1.returnKeyType = UIReturnKeyDone;
    [phoneView addSubview:phoneNumberField1];
    
    UIButton *findpassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findpassBtn.backgroundColor = RGBA(229, 165, 45, 1);
    findpassBtn.frame = CGRectMake(10, phoneView.bottom+10, CurrentScreenWidth-20, 40);
    [findpassBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [findpassBtn addTarget:self action:@selector(findOK:) forControlEvents:UIControlEventTouchUpInside];
    [findpassBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    findpassBtn.layer.cornerRadius = 5;
    findpassBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:phoneView];
    [self.view addSubview:findpassBtn];
}
-(void)goback:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)isRight:(NSString*)pwd
{
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:pwd];
}

-(void)findOK:(UIButton *)btn{
    
    if (![self isRight:phoneNumberField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入含有字母和数字的(6-12)位密码"];return;
    }
    if (![phoneNumberField.text isEqualToString:phoneNumberField1.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];return;
    }
    //
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",tel,@"mobile", [phoneNumberField.text stringFromMD5],@"pwd",nil];
    NSDictionary *_d = [MySharetools getParmsForPostWith:dic];
    RequestTaskHandle *_h = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_reset_pwd", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"]integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5), dispatch_get_main_queue(), ^{
                //...去重新登录
                [[MySharetools shared]removeSessionid];
                [MySharetools shared].isFromMycenter = YES;
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"修改失败"];
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"请求服务器失败,请稍后重试"];
    }];
    [HttpRequestManager doPostOperationWithTask:_h];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITextField *textField = (UITextField *)[self.view viewWithTag:201];
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
