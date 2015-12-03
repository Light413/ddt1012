//
//  TonghangTableViewCell.h
//  ddt
//
//  Created by allen on 15/10/21.
//  Copyright © 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TonghangSCModel.h"
@interface TonghangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commanyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
- (IBAction)messageBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *phoneCallBtn;

- (IBAction)phoneCallClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property(nonatomic,copy)void(^btnClickBlock)();
@property(nonatomic,copy)void(^btnmessageClickBlock)();
-(void)showDataFromModel:(TonghangSCModel *)model;
@end
