//
//  NGJieDanDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGJieDanDetailVC.h"
#import <CoreText/CoreText.h>
@interface NGJieDanDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *daikuanLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *renqiLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *jifenLab;
@property (weak, nonatomic) IBOutlet UIButton *btn_qiangDan;

@property (weak, nonatomic) IBOutlet UIButton *btn_love;//收藏
@property (weak, nonatomic) IBOutlet UIButton *btn_tel;//电话号码
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLab;//联系人

@end

@implementation NGJieDanDetailVC
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self initData];
    [self initSubviews];
}

-(void)initData
{
    _s1 = [self.danZiInfoDic objectForKey:@"cs_ch"]?[self.danZiInfoDic objectForKey:@"cs_ch"]:@"未知";
    _s2 = [self.danZiInfoDic objectForKey:@"cs_type"]?[self.danZiInfoDic objectForKey:@"cs_type"]:@"";
    _s3 = [self.danZiInfoDic objectForKey:@"zxqk"]?[self.danZiInfoDic objectForKey:@"zxqk"]:@"未知";
    _s4 = [self.danZiInfoDic objectForKey:@"cs_age"]?[self.danZiInfoDic objectForKey:@"cs_age"]:@"0";
    _s5 = [self.danZiInfoDic objectForKey:@"cs_dkje"]?[self.danZiInfoDic objectForKey:@"cs_dkje"]:@"未知";
    _s6 = [self.danZiInfoDic objectForKey:@"cs_dkqx"]?[self.danZiInfoDic objectForKey:@"cs_dkqx"]:@"未知";
    _s7 = [self.danZiInfoDic objectForKey:@"bz"]?[self.danZiInfoDic objectForKey:@"bz"]:@"";
    _s8 = [self.danZiInfoDic objectForKey:@"frompf"]?[self.danZiInfoDic objectForKey:@"frompf"]:@"0";
    _s9 = [self.danZiInfoDic objectForKey:@"see"]?[self.danZiInfoDic objectForKey:@"see"]:@"0";
    _s10 = [self.danZiInfoDic objectForKey:@"tjsj"]?[self.danZiInfoDic objectForKey:@"tjsj"]:@"未知";
    _s11 = [self.danZiInfoDic objectForKey:@"jifen"]?[self.danZiInfoDic objectForKey:@"jifen"]:@"0";
    _s12 = [self.danZiInfoDic objectForKey:@"fromxm"]?[self.danZiInfoDic objectForKey:@"fromxm"]:@"0";//联系人
    _s13 = [self.danZiInfoDic objectForKey:@"fmobile"]?[self.danZiInfoDic objectForKey:@"fmobile"]:@"---";//电话
    self.btn_love.selected = [[self.danZiInfoDic objectForKey:@"isbook"] boolValue];
}

-(void)initSubviews
{
//    self.nameLab.font = [UIFont boldSystemFontOfSize:14];
    self.nameLab.textColor = BarDefaultColor;
//    self.ageLab.font = [UIFont boldSystemFontOfSize:14];
    self.ageLab.textColor = BarDefaultColor;
//    self.daikuanLab.font = [UIFont boldSystemFontOfSize:14];
    self.daikuanLab.textColor = BarDefaultColor;
//    self.detailLab.font = [UIFont boldSystemFontOfSize:14];
    self.detailLab.textColor = BarDefaultColor;
//    self.renqiLab.font = [UIFont boldSystemFontOfSize:14];
    self.renqiLab.textColor = BarDefaultColor;
    
//    self.timeLab.font = [UIFont boldSystemFontOfSize:14];
    self.timeLab.textColor = BarDefaultColor;
    self.jifenLab.font = [UIFont boldSystemFontOfSize:14];
    self.jifenLab.textColor = BarDefaultColor;
    
    self.nameLab.text = [NSString stringWithFormat:@"称呼：%@ 类型：%@",_s1,_s2];
    self.ageLab.text = [NSString stringWithFormat:@"征信：%@ 年龄：%@",_s3,_s4];
    self.daikuanLab.text = [NSString stringWithFormat:@"贷款金额：%@ 贷款期限：%@",_s5,_s6];
    self.detailLab.text = [NSString stringWithFormat:@"%@",_s7];
    self.renqiLab.text = [NSString stringWithFormat:@"信誉评分：%@ 浏览人次：%@",_s8,_s9];
    self.timeLab.text = [NSString stringWithFormat:@"甩单时间：%@",_s10];
    self.jifenLab.text = [NSString stringWithFormat:@"锁定此单,需花费 %@ 个积分",_s11];
    NSMutableAttributedString *mutableAttributedString_attrs = [[NSMutableAttributedString alloc] initWithString:self.jifenLab.text];
    [mutableAttributedString_attrs beginEditing];
    NSRange rang = NSMakeRange(9, _s11.length);

    [mutableAttributedString_attrs addAttribute:(NSString *)NSForegroundColorAttributeName
                                          value:(id)[UIColor redColor]
                                          range:rang];
    //kCTFontAttributeName - NSFontAttributeName
    [mutableAttributedString_attrs addAttribute:(NSString *)kCTFontAttributeName
                                          value:[UIFont boldSystemFontOfSize:18]
                                          range:rang];
    self.jifenLab.attributedText = [mutableAttributedString_attrs copy];
    
    self.contactPersonLab.text = [NSString stringWithFormat:@"联系人: %@",_s12];
    [self.btn_tel setNormalTitle:_s13 andID:@""];//tel
    
    self.btn_love.hidden = self.isLove;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --btn action

- (IBAction)qinagDanAction:(id)sender {
    
}

//收藏
- (IBAction)love_btn_action:(UIButton *)sender {
    NSString *uid = [self.danZiInfoDic objectForKey:@"uid"];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",tel,@"mobile",@"3",@"type",uid,@"id", nil];
    NSDictionary *_d1 = [MySharetools getParmsForPostWith:dic];
    
    [SVProgressHUD showWithStatus:!self.btn_love.selected ?@"添加收藏":@"取消收藏"];
    NSString *_url =!self.btn_love.selected?NSLocalizedString(@"url_my_love", @""): NSLocalizedString(@"url_my_nolove", @"");
    
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:_url parms:_d1 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        sender.selected = !sender.selected;
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
    [HttpRequestManager doPostOperationWithTask:_task];
}

//打电话
- (IBAction)telAction:(UIButton *)sender {

    NSString* str = [NSString stringWithFormat:@"sms://%@",_s13];
    [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:str]];
}

static const float _h =80;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        case 1:
        case 3:return _h; break;
        case 5:
            if (self.isLove)
            {
                return 0;
            }
            else
            return _h; break;
        case 2:
        {
           CGSize _new =  [ToolsClass calculateSizeForText:_s7 : CGSizeMake(CurrentScreenWidth -30, 999) font:[UIFont systemFontOfSize:14]];
            return _new.height + 40 > 80?_new.height + 40:80;
        } break;
        case 4:return 50;break;
        case 6:
            if (self.isLove)
            {
                return 80;
            }
            else
                return 0; break;
        default:return 0;break;
    }
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
