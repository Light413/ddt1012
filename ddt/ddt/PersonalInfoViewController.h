//
//  PersonalInfoViewController.h
//  ddt
//
//  Created by allen on 15/10/19.
//  Copyright (c) 2015年 Light. All rights reserved.
//
#import "MyBaseTableViewController.h"

@interface PersonalInfoViewController : MyBaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;//姓名
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;//男
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthBtn;
- (IBAction)birthBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *weixinField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UIButton *recommandPersonBtn;
- (IBAction)recommandPersonBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *serviceAreaBtn;
- (IBAction)serviceBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bussinessSortBtn;
- (IBAction)bussinessSortBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *keyWordField;
@property (weak, nonatomic) IBOutlet UILabel *typeInLabel;
@property (weak, nonatomic) IBOutlet UITextView *InfoTextView;
@property (weak, nonatomic) IBOutlet UIView *backView;
- (IBAction)saveInfoBtnClick:(id)sender;
@property(nonatomic,copy)NSString *itemKey;

- (IBAction)maleBtnClick:(id)sender;
- (IBAction)femaleBtnClick:(id)sender;


@end
