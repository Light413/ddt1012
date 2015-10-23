//
//  MyResumeViewController.h
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyBaseTableViewController.h"

@interface MyResumeViewController : MyBaseTableViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *hopeWorkingField;
@property (weak, nonatomic) IBOutlet UIButton *businessTypeBtn;
- (IBAction)businessTypeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *certificateBtn;
- (IBAction)certificateBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *workingYearsBtn;
@property (weak, nonatomic) IBOutlet UIButton *workingYearsBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *salaryBtn;
- (IBAction)salaryBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBusinessTypeBtn;
- (IBAction)chooseBusinessTypeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *judgeTextView;
@property (weak, nonatomic) IBOutlet UILabel *judgeholderLabel;

- (IBAction)saveResumeBtnClick:(id)sender;


- (IBAction)areaBtnClick:(id)sender;
@end
