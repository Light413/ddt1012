//
//  NGJieDanDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/25.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGJieDanDetailVC.h"
#import <CoreText/CoreText.h>

#import "DanziTop.h"

#define btnEnableColor  [UIColor colorWithRed:0.976 green:0.643 blue:0.180 alpha:1]
#define btnDisableColor  [UIColor colorWithRed:0.757 green:0.757 blue:0.757 alpha:1]

#define cellSepLineColor [UIColor colorWithRed:0.906 green:0.910 blue:0.914 alpha:1].CGColor
#define cellSepLineWidth 0.5

@interface NGJieDanDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *cs_typeLab;

@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *jineLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *zxqkLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (weak, nonatomic) IBOutlet UILabel *jifenLab;


@property (weak, nonatomic) IBOutlet UIButton *btn_love;//收藏

@property (weak, nonatomic) IBOutlet UITableViewCell *cell_1;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_2;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell_3;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_4;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_5;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_6;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_7;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_8;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_9;


@end

@implementation NGJieDanDetailVC
{
    NSString * _s1;
    NSString * _s2;
    NSString * _s3;
    NSString * _s4;
    NSString * _s5;
    NSString * _s6;
    NSString * _s7;//详细说明
    NSString * _s8;//积分
    NSString * _s9;//是否收藏
    NSString * _s10;//名字
    NSString * _s11;//tel
    NSString * _s12;//立即锁定-按钮状态
    
    //top -个人信息数据
    NSString * _s13;//avantar
    NSString * _s14;//区域
    NSString * _s15;//甩单时间
    NSString * _s16;//浏览次数
    NSString * _s17;//靠谱指数
    NSString * _s18;//单子状态
    
    DanziTop *_top_v;
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
    _s1 = [self.danZiInfoDic objectForKey:@"cs_ch"]?[self.danZiInfoDic objectForKey:@"cs_ch"]:@"";
    _s2 = [self.danZiInfoDic objectForKey:@"cs_type"]?[self.danZiInfoDic objectForKey:@"cs_type"]:@"";
    _s3 = [self.danZiInfoDic objectForKey:@"cs_age"]?[self.danZiInfoDic objectForKey:@"cs_age"]:@"0";
    _s4 = [self.danZiInfoDic objectForKey:@"cs_dkje"]?[self.danZiInfoDic objectForKey:@"cs_dkje"]:@"0";
    _s5 = [self.danZiInfoDic objectForKey:@"cs_dkqx"]?[self.danZiInfoDic objectForKey:@"cs_dkqx"]:@"0";
    _s6 = [self.danZiInfoDic objectForKey:@"zxqk"]?[self.danZiInfoDic objectForKey:@"zxqk"]:@"";
    _s7 = [self.danZiInfoDic objectForKey:@"bz"]?[self.danZiInfoDic objectForKey:@"bz"]:@"";
    _s8 = [self.danZiInfoDic objectForKey:@"jifen"]?[self.danZiInfoDic objectForKey:@"jifen"]:@"0";
    
    //top
    _s13 = [self.danZiInfoDic objectForKey:@"formpic"]?[self.danZiInfoDic objectForKey:@"formpic"]:@"";
    _s14 = [self.danZiInfoDic objectForKey:@"yw_quyu"]?[self.danZiInfoDic objectForKey:@"yw_quyu"]:@"";
    _s15 = [self.danZiInfoDic objectForKey:@"tjsj"]?[self.danZiInfoDic objectForKey:@"tjsj"]:@"";
    _s16 = [self.danZiInfoDic objectForKey:@"see"]?[self.danZiInfoDic objectForKey:@"see"]:@"";
    _s17 = [self.danZiInfoDic objectForKey:@"frompf"]?[self.danZiInfoDic objectForKey:@"frompf"]:@"0";//...靠谱指数
    _s18 = [self.danZiInfoDic objectForKey:@"zt"]?[self.danZiInfoDic objectForKey:@"zt"]:@"";//...单子状态
    
    self.btn_love.selected = [[self.danZiInfoDic objectForKey:@"isbook"] boolValue];
    
    //是否被锁定
//    BOOL _b = [[self.danZiInfoDic objectForKey:@"zt"] boolValue];
//    if (_b) {
//        self.btn_qiangDan.backgroundColor = btnDisableColor;
//        [self.btn_qiangDan setTitle:@"您来晚了,已被他人锁定"];
//        [self.btn_qiangDan setUserInteractionEnabled:NO];
//        //收藏按钮是否隐藏
//        self.btn_love.hidden = YES;
//    }
//    else
//    {
//        self.btn_qiangDan.backgroundColor = btnEnableColor;
//        [self.btn_qiangDan setTitle:@"立即锁定"];
//    }

}

-(void)initSubviews
{
    //cell
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    for (UITableViewCell *_cell in @[self.cell_1,self.cell_2,self.cell_3,self.cell_4,self.cell_5,self.cell_6,self.cell_7,self.cell_8,self.cell_9]) {
        _cell.layer.borderColor = cellSepLineColor;
        _cell.layer.borderWidth = cellSepLineWidth;
    }

    //tableview -headerview
    NSArray *_arr = [[NSBundle mainBundle]loadNibNamed:@"DanziTop" owner:self options:nil];
    _top_v = [_arr lastObject];
    _top_v.frame = CGRectMake(0, 0, CurrentScreenWidth, 100);
    
    if (_s13 && _s13.length > 11 ) {
        NSString * url = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"url_get_avatar", @""),_s13];
        [_top_v.avatarimg setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cell_avatar_default"]];
    }
    else
    {
        _top_v.avatarimg.image =[UIImage imageNamed:@"cell_avatar_default"];
    }
    _top_v.areaLab.text = _s14;
    _top_v.timeLab.text = _s15;
    _top_v.timesLab.text = _s16;
    float _pf = [_s17 floatValue];
    _top_v.lead_value.constant -= (5 - _pf) * 20;
    _top_v.width_value.constant+= (5 - _pf) * 20;
    
    self.tableView.tableHeaderView = _top_v;
    
    self.nameLab.text = _s1;
    self.cs_typeLab.text = _s2;
    self.ageLab.text = _s3;
    self.jineLab.text = _s4;
    self.timeLab.text = _s5;
    self.zxqkLab.text = _s6;
    self.detailLab.text = _s7;
    
    self.jifenLab.text = [NSString stringWithFormat:@"锁定此单,需花费 %@ 个积分",_s8];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --btn action

- (IBAction)qinagDanAction:(id)sender {
    NSString *uid = [self.danZiInfoDic objectForKey:@"id"];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",tel,@"mobile",_s11,@"fee",uid,@"id", nil];
    NSDictionary *_d1 = [MySharetools getParmsForPostWith:dic];
    
    [SVProgressHUD showWithStatus:@"正在请求锁定"];
    NSString *_url =NSLocalizedString(@"url_lock_danzi", @"");
    
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:_url parms:_d1 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue ] == 0) {
                  [SVProgressHUD showInfoWithStatus:@"处理成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5), dispatch_get_main_queue(), ^{
                   [self.navigationController popViewControllerAnimated:YES];
                });
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"锁定失败,请稍后重试"];
            }
        }

    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
    [HttpRequestManager doPostOperationWithTask:_task];
}

//收藏
- (IBAction)love_btn_action:(UIButton *)sender {
    NSString *uid = [self.danZiInfoDic objectForKey:@"id"];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",tel,@"mobile",@"3",@"type",uid,@"id", nil];
    NSDictionary *_d1 = [MySharetools getParmsForPostWith:dic];
    
    [SVProgressHUD showWithStatus:!self.btn_love.selected ?@"添加收藏":@"取消收藏"];
    NSString *_url =!self.btn_love.selected?NSLocalizedString(@"url_my_love", @""): NSLocalizedString(@"url_my_nolove", @"");
    
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:_url parms:_d1 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        sender.selected = !sender.selected;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"hasDanziCollectionNoti" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
    [HttpRequestManager doPostOperationWithTask:_task];
}

//打电话
- (IBAction)telAction:(UIButton *)sender {
    sender.layer.cornerRadius = 1;
    sender.layer.masksToBounds = YES;
    NSString* str = [NSString stringWithFormat:@"tel://%@",_s13];
    [[UIApplication sharedApplication ]openURL:[NSURL URLWithString:str]];
}

static const float _h =50;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==6) {
        CGSize _new =  [ToolsClass calculateSizeForText:_s7 : CGSizeMake(CurrentScreenWidth - 140, 999) font:[UIFont systemFontOfSize:15]];
        return _new.height > 50?_new.height:50;
    }
    else if (indexPath.row ==9)
    {//btn
        return 60;
    }
    return _h;
    
}


@end
