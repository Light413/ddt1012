//
//  NGShuaiDantVC.m
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGShuaiDantVC.h"

@interface NGShuaiDantVC ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_age;
@property (weak, nonatomic) IBOutlet UIButton *btn_jine;
@property (weak, nonatomic) IBOutlet UIButton *btn_timelimit;
@property (weak, nonatomic) IBOutlet UIButton *btn_yewutype;
@property (weak, nonatomic) IBOutlet UIButton *btn_area;
@property (weak, nonatomic) IBOutlet UITextField *tf_jifen;

@property (weak, nonatomic) IBOutlet UIView *textviewbg;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *textviewDeleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *textviewNumLab;
@end

@implementation NGShuaiDantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
}

-(void)initSubviews
{
    self.textviewbg.layer.borderWidth = 1;
    self.textviewbg.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.textviewbg.layer.cornerRadius = 5;
    self.textviewbg.layer.masksToBounds = YES;
    
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;

}

#pragma mark -- btn action

- (IBAction)btnClickAction:(UIButton *)sender {
    
    
    
    
}

//立即甩单操作
- (IBAction)submintAction:(id)sender {
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
