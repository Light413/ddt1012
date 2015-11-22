//
//  menuDetailViewController.h
//  ddt
//
//  Created by huishuyi on 15/11/1.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "MyBaseTableViewController.h"
#import "MenuOfMyCenterModel.h"
@interface menuDetailViewController : MyBaseTableViewController
@property (weak, nonatomic) IBOutlet UILabel *customerInfoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *customerInfoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuInfoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *menuInfoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *suodingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneImage;
- (IBAction)phoneBtnClick:(id)sender;
@property (nonatomic,strong)MenuOfMyCenterModel *menuModel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
