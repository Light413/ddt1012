//
//  AddCommanyInfoViewController.h
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyBaseTableViewController.h"

@interface AddCommanyInfoViewController : MyBaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *luruCommanynameField;
@property (weak, nonatomic) IBOutlet UIButton *serviceAreaBtn;
- (IBAction)serviceAreaBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chooseBusinessTypeBtn;
- (IBAction)chooseBusinessTypeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *judgeTextView;
@property (weak, nonatomic) IBOutlet UILabel *backHolderLabel;
@property (weak, nonatomic) IBOutlet UITextField *addresscommanyNameField;
@property (weak, nonatomic) IBOutlet UITextField *jigouCodeFIeld;

@property (weak, nonatomic) IBOutlet UITextField *contactorField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *keywordField;

@property (weak, nonatomic) IBOutlet UIView *backView;
- (IBAction)summitBtnClick:(id)sender;

@end
