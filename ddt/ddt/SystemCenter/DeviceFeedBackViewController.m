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
    deviceTextView.text = @"";
    wordNumLabel.text = @"0/100";
}
- (IBAction)submitingBtnClick:(id)sender {
    if (self.deviceTextView.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入意见反馈"];
        return;
    }
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    //NSString *nickName = [[MySharetools shared]getNickName];
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *date = [NSString stringWithFormat:@"%@",localDate];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:date,@"date",tel,@"username",self.deviceTextView.text,@"content", nil];
    NSDictionary *paramDict = [MySharetools getParmsForPostWith:dict];
    [SVProgressHUD showWithStatus:@"正在加载"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_addsay", @"") parms:paramDict andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"message"]];
            }
        }
        
        NSLog(@"...responseObject  :%@",responseObject);
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"请求服务器失败"];
    }];
    
    [HttpRequestManager doPostOperationWithTask:_task];
}
@end
