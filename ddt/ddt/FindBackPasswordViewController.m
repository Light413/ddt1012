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
    [self createLeftBarItemWithBackTitle];
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
    UITextField *phoneNumberField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, 5, phoneView.width-nameLabel.width-3, 30)];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.tag = 201;
    phoneNumberField.delegate = self;
    [phoneView addSubview:phoneNumberField];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, phoneView.bottom+5, CurrentScreenWidth-30, 30)];
    label.text = @"密码会发送到注册时设置的邮箱中";
    label.font = [UIFont systemFontOfSize:14];
    UIButton *findpassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findpassBtn.backgroundColor = RGBA(229, 165, 45, 1);
    findpassBtn.frame = CGRectMake(10, label.bottom+10, CurrentScreenWidth-20, 30);
    [findpassBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findpassBtn addTarget:self action:@selector(findOK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneView];
    [self.view addSubview:label];
    [self.view addSubview:findpassBtn];
}
-(void)goback:(UIButton *)btn{
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
