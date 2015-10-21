//
//  PersonalInfoViewController.m
//  ddt
//
//  Created by allen on 15/10/19.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "PersonalInfoViewController.h"

@interface PersonalInfoViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation PersonalInfoViewController
@synthesize nameField;
@synthesize maleBtn;
@synthesize femaleBtn;
@synthesize birthBtn;
@synthesize weixinField;
@synthesize companyField;
@synthesize recommandPersonBtn;
@synthesize serviceAreaBtn;
@synthesize bussinessSortBtn;
@synthesize keyWordField;
@synthesize typeInLabel;
@synthesize InfoTextView;
@synthesize backView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息完善";
    backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    backView.layer.borderWidth = 1;
    InfoTextView.delegate = self;
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        typeInLabel.hidden = YES;
    }else{
        typeInLabel.hidden = NO;
    }
}
- (IBAction)birthBtnClick:(id)sender {
}
- (IBAction)recommandPersonBtnClick:(id)sender {
}
- (IBAction)serviceBtnClick:(id)sender {
}
- (IBAction)bussinessSortBtnClick:(id)sender {
}
- (IBAction)saveInfoBtnClick:(id)sender {
}
@end
