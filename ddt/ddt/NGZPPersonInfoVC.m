//
//  NGZPPersonInfoVC.m
//  ddt
//
//  Created by wyg on 15/11/28.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGZPPersonInfoVC.h"

@interface NGZPPersonInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *gangweiLab;
@property (weak, nonatomic) IBOutlet UILabel *xueliLab;
@property (weak, nonatomic) IBOutlet UILabel *oldLab;
@property (weak, nonatomic) IBOutlet UILabel *gongziLab;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *yewuLab;
@property (weak, nonatomic) IBOutlet UILabel *pjLab;

@end

@implementation NGZPPersonInfoVC
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initSubviews];
}

-(void)initData
{
    _s1 = [self.infoDic objectForKey:@"xm"]?[self.infoDic objectForKey:@"xm"]:@"未知";
    _s2 = [self.infoDic objectForKey:@"xb"]?[self.infoDic objectForKey:@"xb"]:@"";
    _s3 = [self.infoDic objectForKey:@"age"]?[self.infoDic objectForKey:@"age"]:@"未知";
    _s4 = [self.infoDic objectForKey:@"fmobile"]?[self.infoDic objectForKey:@"fmobile"]:@"未知";
    _s5 = [self.infoDic objectForKey:@"work"]?[self.infoDic objectForKey:@"work"]:@"不限";
    _s6 = [self.infoDic objectForKey:@"xl"]?[self.infoDic objectForKey:@"xl"]:@"未知";
    _s7 = [self.infoDic objectForKey:@"old"]?[self.infoDic objectForKey:@"old"]:@"未知";
    _s8 = [self.infoDic objectForKey:@"money"]?[self.infoDic objectForKey:@"money"]:@"0";
    _s9 = [self.infoDic objectForKey:@"yw_quye"] && ![((NSString*)[self.infoDic objectForKey:@"yw_quye"]) isEqualToString:@""] ?[self.infoDic objectForKey:@"yw_quye"]:@"不限";//
    _s10 = [self.infoDic objectForKey:@"yw_type"]?[self.infoDic objectForKey:@"yw_type"]:@"未知";//业务类型
    _s11 = [self.infoDic objectForKey:@"content"]?[self.infoDic objectForKey:@"content"]:@"这个人还没有评价";//pj
}

-(void)initSubviews
{
    self.nameLab.text = [NSString stringWithFormat:@"%@ \t\t\t\t%@ \t\t\t\t%@",_s1,_s2,_s3];
    self.telLab.text = [NSString stringWithFormat:@"联系方式:%@",_s4];
    self.gangweiLab.text = [NSString stringWithFormat:@"%@",_s5];
    self.xueliLab.text = [NSString stringWithFormat:@"%@",_s6];
    self.oldLab.text = [NSString stringWithFormat:@"%@",_s7];
    self.gongziLab.text = [NSString stringWithFormat:@"%@",_s8];
    self.areaLab.text = [NSString stringWithFormat:@"%@",_s9];
    self.yewuLab.text = [NSString stringWithFormat:@"%@",_s10];
    self.pjLab.text = [NSString stringWithFormat:@"%@",_s11];
}


static const float _h =50;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:return 80;break;
        case 1:
        case 2:
        case 3:return _h; break;
        case 4:
        {
            CGSize _new =  [ToolsClass calculateSizeForText:_s10 : CGSizeMake(CurrentScreenWidth -30, 999) font:[UIFont systemFontOfSize:15]];
            return _new.height + 30 > 60?_new.height + 30:60;
        } break;
        case 5:
        {
            CGSize _new =  [ToolsClass calculateSizeForText:_s11 : CGSizeMake(CurrentScreenWidth -30, 999) font:[UIFont systemFontOfSize:15]];
            return _new.height + 30 > 60?_new.height + 30:60;
        } break;
        default:return 0;break;
    }
}




- (IBAction)btnAction:(UIButton *)sender {
    NSString *str;
    if (sender.tag == 300) {
       //tel
        str = [NSString stringWithFormat:@"tel://%@",_s4];
    }
    else if (sender.tag ==301)
    {
    //msg
        str = [NSString stringWithFormat:@"sms://%@",_s4];
    }
    
    [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:str]];
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
