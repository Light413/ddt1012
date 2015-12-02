//
//  ModifyPasswordViewController.m
//  ddt
//
//  Created by huishuyi on 15/10/27.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>

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
    UITextField *phoneNumberField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 6, phoneView.width-nameLabel.width-3, 30)];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.placeholder = @"输入6-12位数字和字母组合";
    phoneNumberField.tag = 201;
    phoneNumberField.font = [UIFont systemFontOfSize:14];
    phoneNumberField.delegate = self;
    [phoneView addSubview:phoneNumberField];
    
    UIImageView *midLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, phoneView.width, 0.5)];
    midLine.backgroundColor = [UIColor lightGrayColor];
    [phoneView addSubview:midLine];
    UILabel *nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(phoneView.left+3, 46, 65, 30)];
    nameLabel1.font = [UIFont systemFontOfSize:13];
    nameLabel1.text = @"确认密码:";
    nameLabel1.textColor = [UIColor darkGrayColor];
    [phoneView addSubview:nameLabel1];
    UITextField *phoneNumberField1 = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 47, phoneView.width-nameLabel.width-3, 30)];
    phoneNumberField1.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField1.tag = 201;
    phoneNumberField1.placeholder = @"再次输入新密码";
    phoneNumberField1.font = [UIFont systemFontOfSize:14];
    phoneNumberField1.delegate = self;
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

-(void)findOK:(UIButton *)btn{
    [SVProgressHUD showInfoWithStatus:@"暂无接口"];
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
