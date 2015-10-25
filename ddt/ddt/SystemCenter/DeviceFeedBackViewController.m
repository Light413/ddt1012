//
//  DeviceFeedBackViewController.m
//  ddt
//
//  Created by allenhzhang on 10/23/15.
//  Copyright (c) 2015 Light. All rights reserved.
//
#import "DeviceFeedBackViewController.h"

@interface DeviceFeedBackViewController ()<UITextViewDelegate>

@end

@implementation DeviceFeedBackViewController
@synthesize backView;
@synthesize deviceTextView;
@synthesize holderLabel;
@synthesize cancelBtn;
@synthesize wordNumLabel;
@synthesize submitBtnClick;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    backView.layer.borderColor = [RGBA(207, 207, 207, 1)CGColor];
    backView.layer.borderWidth = 1;
    deviceTextView.delegate = self;
    // Do any additional setup after loading the view.
}
-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        holderLabel.hidden = YES;
    }else{
        holderLabel.hidden = NO;
    }
    
    if (textView.text.length<=100) {
        wordNumLabel.text = [NSString stringWithFormat:@"%d/100",textView.text.length];
    }else{
        wordNumLabel.text = @"100/100";
        deviceTextView.editable = NO;
    }
    

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>=100) {
        return NO;
    }else{
        return YES;
    }
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

- (IBAction)cancelBtnClick:(id)sender {
}
- (IBAction)submitingBtnClick:(id)sender {
}
@end
