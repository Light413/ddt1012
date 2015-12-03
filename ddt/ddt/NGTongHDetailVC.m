//
//  NGTongHDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGTongHDetailVC.h"
#define Font    [UIFont systemFontOfSize:15]
#define Size    CGSizeMake(CurrentScreenWidth - 50, 1000)

#define Color_1 [UIColor colorWithRed:0.412 green:0.635 blue:0.757 alpha:1]
#define Color_2 [UIColor colorWithRed:0.161 green:0.439 blue:0.122 alpha:1]
#define Color_3 [UIColor colorWithRed:0.835 green:0.722 blue:0.439 alpha:1]


@interface NGTongHDetailVC ()<UIAlertViewDelegate>
{
    NSString *_s1;//姓名
    NSString *_s2;//性别
    NSString *_s3;//年龄
    NSString *_s4;//积分
    NSString *_s5;//浏览
    NSString *_s6;//评论
    NSString *_s7;//电话
    NSString *_s8;//业务类型
    NSString *_s9;//所属公司
    NSString *_s10;//业务说明
}
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *ywlxLab;
@property (weak, nonatomic) IBOutlet UILabel *ssgsLab;
@property (weak, nonatomic) IBOutlet UILabel *ywsmLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *lable_1;//业务类型
@property (weak, nonatomic) IBOutlet UILabel *lable_2;//所属公司
@property (weak, nonatomic) IBOutlet UILabel *lable_3;//业务说明
@property (weak, nonatomic) IBOutlet UIButton *is_love_btn;//收藏按钮

@end

@implementation NGTongHDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self loadData];
    [self initSubviews];
    [self initHeaderView];
}

//
-(void)loadData
{
    NSString *uid = [self.personInfoDic objectForKey:@"uid"];
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",uid,@"sid", nil];
    NSDictionary *_d1 = [MySharetools getParmsForPostWith:dic];
    
    [SVProgressHUD showWithStatus:@"正在请求数据"];
    NSString *_url =NSLocalizedString(@"url_tongh_detial", @"");
    
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:_url parms:_d1 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue ] == 0) {
                [SVProgressHUD dismiss];
            }
            else
            {
                [SVProgressHUD dismiss];
            }
        }
        
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
    [HttpRequestManager doPostOperationWithTask:_task];
}


-(void)initSubviews
{
    UIFont *_f = [UIFont boldSystemFontOfSize:15];
    self.ywlxLab.font = _f;
    self.ssgsLab.font = _f;
    self.ywsmLab.font = _f;
    self.telLab.font = [UIFont boldSystemFontOfSize:18];
    self.telLab.textColor = Color_3;
    self.lable_1.textColor = Color_1;
    self.lable_2.textColor = Color_3;
    self.lable_2.font = [UIFont boldSystemFontOfSize:14];
    
    //...初始值
    if (self.personInfoDic) {
        _s1 = [self.personInfoDic objectForKey:@"xm"];
        _s2 = [self.personInfoDic objectForKey:@"xb"];
        _s3 = [self.personInfoDic objectForKey:@"age"];
        _s4 = [self.personInfoDic objectForKey:@"fee"];
        _s5 = [self.personInfoDic objectForKey:@"see"];
        _s6 = [self.personInfoDic objectForKey:@"say"];
        _s7 = [self.personInfoDic objectForKey:@"mobile"];
        _s8 = [self.personInfoDic objectForKey:@"yewu"];
        _s9 = [self.personInfoDic objectForKey:@"company"];
        _s10 = [self.personInfoDic objectForKey:@"content"];
        self.is_love_btn.selected = [[self.personInfoDic objectForKey:@"isbook"]boolValue];
    }
    else
    {
        _s1 = @"测试数据";
        _s2 = @"男";
        _s3 = @"30";
        _s4 = @"130";
        _s5 = @"130";
        _s6 = @"130";
        _s7 = @"13012345678";
        _s8 = @"民间抵押个人－房产／民间抵押个人－车辆，信用卡借款方式对付健康附近开，高丽嗲的回复就是地方";
        _s9 = @"信和郑州公司 - 内存泄漏形象的比喻是操作系统可提供给所有";
        _s10 = @"所以“内存泄漏”是从操作系统的角度来看的。这里的存储空间并不是指物理内存，而是指虚拟内存大小，这个虚拟内存大小取决于磁盘交换区设定的大小";
    }

    
    _telLab.text = _s7;
    _lable_1.text = _s8;
    _lable_2.text = _s9;
    _lable_3.text = _s10;
}


-(void)initHeaderView
{
    float _h = _imgView.frame.size.height;
    UIImageView *_avarimg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
    _avarimg.layer.cornerRadius = 40;
    _avarimg.layer.masksToBounds = YES;
    NSString * pic =[self.personInfoDic objectForKey:@"pic"];
    if (pic && pic.length > 11 ) {
        NSString * url = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"url_get_avatar", @""),pic];
        [_avarimg setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cell_avatar_default"]];
    }
    else
    {
        _avarimg.image =[UIImage imageNamed:@"cell_avatar_default"];
    }

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
    _lab1.text = _s4;
    _lab1.textAlignment = NSTextAlignmentCenter;
    _lab1.textColor = Color_2;
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
    _lab2.text = _s5;
    _lab2.textAlignment = NSTextAlignmentCenter;
    _lab2.textColor = Color_2;
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
    _lab3.text = _s6;
    _lab3.textColor = Color_2;
    _lab3.textAlignment = NSTextAlignmentCenter;
    [_imgView addSubview:_lab3];
    
    UILabel *_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(btn1.frame.origin.x+3, _avarimg.frame.origin.y, 60, 20)];
    _nameLab.font = [UIFont boldSystemFontOfSize:16];
    _nameLab.textColor = Color_1;
    _nameLab.text = _s1;
    [_imgView addSubview:_nameLab];
    
    UILabel *_sexLab = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x + _nameLab.frame.size.width + 10, _avarimg.frame.origin.y, 20, 20)];
    _sexLab.font = [UIFont systemFontOfSize:14];
    _sexLab.textColor = Color_1;
    _sexLab.text = _s2;
    [_imgView addSubview:_sexLab];
    
    UILabel *_ageLab = [[UILabel alloc]initWithFrame:CGRectMake(_sexLab.frame.origin.x+_sexLab.frame.size.width +30, _avarimg.frame.origin.y, 20, 20)];
    _ageLab.font = [UIFont systemFontOfSize:14];
    _ageLab.textColor = Color_1;
    _ageLab.text = _s3;
    [_imgView addSubview:_ageLab];
}

-(void)awakeFromNib
{
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark -tel,message ,love action
- (IBAction)btnAction:(UIButton*)sender {
    switch (sender.tag) {
        case 311:// 打电话
        {
            UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"开始呼叫:%@",_s7] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _alert.tag = 501;
            [_alert show];
        }break;
        case 312:// 短息
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_s7]]];
        }break;
        case 313:// 收藏
        {
            NSString *uid = [self.personInfoDic objectForKey:@"uid"];
            NSString *tel = [[MySharetools shared]getPhoneNumber];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",tel,@"mobile",@"1",@"type",uid,@"id", nil];
            NSDictionary *_d1 = [MySharetools getParmsForPostWith:dic];
            
            [SVProgressHUD showWithStatus:!self.is_love_btn.selected ?@"添加收藏":@"取消收藏"];
            NSString *_url =!self.is_love_btn.selected?NSLocalizedString(@"url_my_love", @""): NSLocalizedString(@"url_my_nolove", @"");
            
            RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:_url parms:_d1 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                sender.selected = !sender.selected;
            } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
            }];
            [HttpRequestManager doPostOperationWithTask:_task];

        }break;
        default: break;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_s7]]];
    }
}

#define heightValue 60

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float _h= 30.0;
    switch (indexPath.row) {
        case 0:
        {
            _h = 0 ;
            
        }break;
        case 1:
        {
            _h += [ToolsClass calculateSizeForText:_s8 :Size font:Font].height;
            
        }break;
        case 2:
        {
            _h += [ToolsClass calculateSizeForText:_s9 :Size font:Font].height;
        }break;
        case 3:
        {
            _h += [ToolsClass calculateSizeForText:_s10 :Size font:Font].height;
            
        }break;
            
        default:return 0;
            break;
    }
    
    return _h > heightValue ? _h : heightValue;
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
