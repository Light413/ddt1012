//
//  RegisterViewController.m
//  ddt
//
//  Created by allen on 15/10/16.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "RegisterViewController.h"
#define ViewHeight 163.0
#define space 5.0
@interface RegisterViewController ()<UITextFieldDelegate>
{
    UIView *textFieldView;
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
    [self createRegisterViews];
    //注册键盘收起的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)registerBtnClick:(id)sender {
}

- (IBAction)registerProtocol:(id)sender {
}

- (IBAction)verifyNumBtnClick:(id)sender {
}
@end
