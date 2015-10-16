//
//  LoginViewController.h
//  ddt
//
//  Created by allen on 15/10/14.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGBaseVC.h"
#import "QCheckBox.h"
@interface LoginViewController : NGBaseVC
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet QCheckBox *remeberPasswordandPhone;
@property (weak, nonatomic) IBOutlet QCheckBox *autoLoginNextime;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regesterBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordBtn;
@property (weak, nonatomic) IBOutlet UIView *mainView;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)registerBtnClick:(id)sender;
- (IBAction)findBackBtnClick:(id)sender;

@end
