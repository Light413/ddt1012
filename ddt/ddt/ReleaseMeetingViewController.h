//
//  ReleaseMeetingViewController.h
//  ddt
//
//  Created by allen on 15/10/22.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyBaseTableViewController.h"

@interface ReleaseMeetingViewController : MyBaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *titleField;

@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
