//
//  NGTongHDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGTongHDetailVC.h"

@interface NGTongHDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *ywlxLab;
@property (weak, nonatomic) IBOutlet UILabel *ssgsLab;
@property (weak, nonatomic) IBOutlet UILabel *ywsmLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation NGTongHDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self initHeaderView];
}

-(void)initHeaderView
{
    float _h = _imgView.frame.size.height;
    
    UIImageView *_avarimg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
    _avarimg.image = [UIImage imageNamed:@"cell_avatar_default"];//...
    [_imgView addSubview:_avarimg];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(_avarimg.frame.origin.x + _avarimg.frame.size.width, (_h - 20)/2.0, 50, 20);
    [btn1 setTitle:@"积分" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"uc_shouc"] forState:UIControlStateNormal];
    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    [_imgView addSubview:btn1];
    UILabel *_lab1 = [[UILabel alloc]initWithFrame:CGRectMake(btn1.frame.origin.x  + (btn1.frame.size.width -30)/2.0, btn1.frame.origin.y + btn1.frame.size.height + 1, 30, 20)];
    _lab1.font = [UIFont systemFontOfSize:12];
    _lab1.text = @"100";//...
    _lab1.textAlignment = NSTextAlignmentCenter;
    [_imgView addSubview:_lab1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn1.frame.origin.x + btn1.frame.size.width, (_h - 20)/2.0, 50, 20);
    [btn2 setTitle:@"浏览" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"uc_add"] forState:UIControlStateNormal];
    [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    btn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [_imgView addSubview:btn2];
    UILabel *_lab2 = [[UILabel alloc]initWithFrame:CGRectMake(btn2.frame.origin.x  + (btn2.frame.size.width -30)/2.0, btn2.frame.origin.y + btn2.frame.size.height + 1, 30, 20)];
    _lab2.font = [UIFont systemFontOfSize:12];
    _lab2.text = @"100";//...
    _lab2.textAlignment = NSTextAlignmentCenter;
    [_imgView addSubview:_lab2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(btn2.frame.origin.x + btn2.frame.size.width, (_h - 20)/2.0, 50, 20);
    [btn3 setTitle:@"评论" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"uc_say"] forState:UIControlStateNormal];
    [btn3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn3 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    btn3.titleLabel.font = [UIFont systemFontOfSize:12];
    [_imgView addSubview:btn3];
    UILabel *_lab3 = [[UILabel alloc]initWithFrame:CGRectMake(btn3.frame.origin.x  + (btn3.frame.size.width -30)/2.0, btn3.frame.origin.y + btn3.frame.size.height + 1, 30, 20)];
    _lab3.font = [UIFont systemFontOfSize:12];
    _lab3.text = @"100";//...
    _lab3.textAlignment = NSTextAlignmentCenter;
    [_imgView addSubview:_lab3];
    
    UILabel *_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(btn1.frame.origin.x+3, _avarimg.frame.origin.y, 60, 20)];
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = [UIColor greenColor];
    _nameLab.text = @"张三丰";
    [_imgView addSubview:_nameLab];
    
    UILabel *_sexLab = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x + _nameLab.frame.size.width + 30, _avarimg.frame.origin.y, 20, 20)];
    _sexLab.font = [UIFont systemFontOfSize:12];
    _sexLab.textColor = [UIColor greenColor];
    _sexLab.text = @"男";
    [_imgView addSubview:_sexLab];
    
    UILabel *_ageLab = [[UILabel alloc]initWithFrame:CGRectMake(_sexLab.frame.origin.x+_sexLab.frame.size.width + 30, _avarimg.frame.origin.y, 20, 20)];
    _ageLab.font = [UIFont systemFontOfSize:12];
    _ageLab.textColor = [UIColor greenColor];
    _ageLab.text = @"88";
    [_imgView addSubview:_ageLab];
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark -tel,message ,love action
- (IBAction)btnAction:(id)sender {
    
    
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
