//
//  SystemCenterViewController.m
//  ddt
//
//  Created by allenhzhang on 10/23/15.
//  Copyright (c) 2015 Light. All rights reserved.
//

#import "SystemCenterViewController.h"
#import "AboutUsViewController.h"
#import "DeviceFeedBackViewController.h"
#import "JoinUsViewController.h"
#import "ResetNewPhoneViewController.h"

#import<CoreText/CoreText.h>

#define KimageName @"imageName"
#define KlabelName @"labelName"
@interface SystemCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datalist;
    UITableView *myTableView;
}
@end

@implementation SystemCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统中心";

    [self creatTableView];
    NSString * versionstr = [NSString stringWithFormat:@"版本更新 (当前版本:%@)",[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]init];
//    [attr addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(5, 10)];
//    [attr addAttribute:(NSString *)kCTFontAttributeName
//                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:14].fontName,14,NULL))range:NSMakeRange(5, 10)];
    
    datalist = @[@{KimageName: @"uc_system.png",
                   KlabelName:@"关于我们"},
                 @{KimageName: @"uc_danzi.png",
                   KlabelName:versionstr},
                 @{KimageName: @"uc_app.png",
                   KlabelName:@"意见反馈"},
                 @{KimageName: @"uc_pwd.png",
                   KlabelName:@"加入我们"},
                 @{KimageName: @"uc_setting_1.png",
                   KlabelName:@"重置手机号"},
                 ];

    // Do any additional setup after loading the view.
}
-(void)creatTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
}
#pragma mark --tableview 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datalist.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    UIImage *image = [UIImage imageNamed:datalist[indexPath.row][KimageName]];
    image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
    
    cell.imageView.image = image;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = datalist[indexPath.row][KlabelName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *dimageview = [[UIImageView alloc] init];
    dimageview.frame=CGRectMake(0, 49, CurrentScreenWidth, 1);
    dimageview.backgroundColor=RGBA(215, 215, 215, 1);
    [cell.contentView addSubview:dimageview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UIBarButtonItem *_item = [[UIBarButtonItem alloc]init];
    _item.title = @"";
    self.navigationItem.backBarButtonItem = _item;
    
    if (indexPath.row == 0) {
        AboutUsViewController *us = [[AboutUsViewController alloc]init];
        us.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:us animated:YES];
    }
    if (indexPath.row == 1) {
        
    }
    if (indexPath.row == 2) {
        DeviceFeedBackViewController *feedback = [[MySharetools shared]getViewControllerWithIdentifier:@"DeviceFeedBack" andstoryboardName:@"me"];
        feedback.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedback animated:YES];
    }
    if (indexPath.row == 3) {
        JoinUsViewController *joinUS = [[JoinUsViewController alloc]init];
        joinUS.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:joinUS animated:YES];
    }
    if (indexPath.row == 4) {
        ResetNewPhoneViewController *reset = [[ResetNewPhoneViewController alloc]init];
        reset.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reset animated:YES];
    }
    
}
-(void)goback:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
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
