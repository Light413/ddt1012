//
//  DeviceFeedBackViewController.h
//  ddt
//
//  Created by allenhzhang on 10/23/15.
//  Copyright (c) 2015 Light. All rights reserved.
//

#import "MyBaseTableViewController.h"

@interface DeviceFeedBackViewController : MyBaseTableViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *deviceTextView;
@property (weak, nonatomic) IBOutlet UILabel *holderLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *wordNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtnClick;

- (IBAction)submitingBtnClick:(id)sender;



@end
