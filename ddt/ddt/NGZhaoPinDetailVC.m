//
//  NGZhaoPinDetailVC.m
//  ddt
//
//  Created by wyg on 15/11/26.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGZhaoPinDetailVC.h"

@interface NGZhaoPinDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *xueliLab;
@property (weak, nonatomic) IBOutlet UILabel *workageLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *yewuLab;
@property (weak, nonatomic) IBOutlet UILabel *distimeLab;
@property (weak, nonatomic) IBOutlet UILabel *needLab;
@property (weak, nonatomic) IBOutlet UILabel *gsnameLab;
@property (weak, nonatomic) IBOutlet UILabel *gsaddrLab;
@property (weak, nonatomic) IBOutlet UILabel *boosnameLab;
@property (weak, nonatomic) IBOutlet UIButton *boostelLab;

@end

@implementation NGZhaoPinDetailVC
{
    NSString * _s1;
    NSString * _s2;
    NSString * _s3;
    NSString * _s4;
    NSString * _s5;
    NSString * _s6;
    NSString * _s7;
    NSString * _s8;
    NSString * _s9;
    NSString * _s10;
    NSString * _s11;
    NSString * _s12;
    NSString * _s13;
    
    CGSize cellMaxFitSize;
    UIFont *cellFitfont;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cellMaxFitSize = CGSizeMake(CurrentScreenWidth -150, 999);
    cellFitfont = [UIFont systemFontOfSize:15];
    
    [self initData];
    [self initSubviews];
}

-(void)initData
{
    if (self.infoDic) {
        _s1 = [self.infoDic objectForKey:@"xl"];
        _s2 = [self.infoDic objectForKey:@"old"];
        _s3 = [self.infoDic objectForKey:@"num"];
        _s4 = [self.infoDic objectForKey:@"money"];
        _s5 = [self.infoDic objectForKey:@"quyu"];
        _s6 = [self.infoDic objectForKey:@"yewu"];
        _s7 = [self.infoDic objectForKey:@"tjsj"];
        _s8 = [self.infoDic objectForKey:@"content"];
        
        _s9 = [self.infoDic objectForKey:@"company"];
        _s10 = [self.infoDic objectForKey:@"address"];
        _s11 = [self.infoDic objectForKey:@"lxr"];
        _s12 = [self.infoDic objectForKey:@"phone"];
        _s13 = [self.infoDic objectForKey:@"work"];
    }

}

-(void)initSubviews
{
    self.xueliLab.text = _s1;
    self.workageLab.text  =_s2;
    self.numberLab.text = _s3;
    self.moneyLab.text = _s4;
    self.areaLab.text = _s5;
    self.yewuLab.text = _s6;
    self.distimeLab.text = _s7;
    self.needLab.text = _s8;
    
    self.gsnameLab.text = _s9;
    self.gsaddrLab.text = _s10;
    self.boosnameLab.text = _s11;
    [self.boostelLab setTitle:_s12 forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}


- (IBAction)telAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_s12]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 40;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==1) {
        return 30;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        UILabel *_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, 30)];
        _lab.text = _s13;
        _lab.font = [UIFont boldSystemFontOfSize:16];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.textColor = [UIColor colorWithRed:0.925 green:0.675 blue:0.173 alpha:1];
        _lab.backgroundColor = [UIColor whiteColor];
        return _lab;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 &&(indexPath.row ==5 || indexPath.row == 7)) {
        CGSize _new = [ToolsClass calculateSizeForText:indexPath.row ==5?_s6:_s8 :cellMaxFitSize font:cellFitfont];
        return _new.height > 60?_new.height:60;
    }
    return 50;
}



@end
