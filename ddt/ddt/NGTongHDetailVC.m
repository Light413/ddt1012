//
//  NGTongHDetailVC.m
//  ddt
//
//  Created by wyg on 15/10/24.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "NGTongHDetailVC.h"
#import "PersonInfoTop.h"
#define Font    [UIFont systemFontOfSize:15]
#define Size    CGSizeMake(CurrentScreenWidth - 70, 1000)

#define Color_1 [UIColor colorWithRed:0.412 green:0.635 blue:0.757 alpha:1]
#define Color_2 [UIColor colorWithRed:0.161 green:0.439 blue:0.122 alpha:1]
#define Color_3 [UIColor colorWithRed:0.835 green:0.722 blue:0.439 alpha:1]


@interface NGTongHDetailVC ()<UIAlertViewDelegate,UIScrollViewDelegate>
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
    
    NSString *_s11;//微信
    NSString *_s12;//区域
    
    UIView *_maskView;
    UIImageView *_bigimgView;
    
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
@property (weak, nonatomic) IBOutlet UITableViewCell *yewu_cell;
@property (weak, nonatomic) IBOutlet UITableViewCell *gs_cell;
@property (weak, nonatomic) IBOutlet UITableViewCell *yewude_cell;

@end

@implementation NGTongHDetailVC

const float border_w = 0.6;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self.tableView setContentInset:UIEdgeInsetsMake(0, -10, 0, -20)];
    self.yewu_cell.layer.borderColor = [UIColor colorWithRed:0.906 green:0.910 blue:0.914 alpha:1].CGColor;
    self.yewu_cell.layer.borderWidth = border_w;
    
    self.gs_cell.layer.borderColor = [UIColor colorWithRed:0.906 green:0.910 blue:0.914 alpha:1].CGColor;
    self.gs_cell.layer.borderWidth = border_w;
    
    self.yewude_cell.layer.borderColor = [UIColor colorWithRed:0.906 green:0.910 blue:0.914 alpha:1].CGColor;
    self.yewude_cell.layer.borderWidth = border_w;
    
    
    [self loadData];
    [self initSubviews];
    [self initHeaderView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"check_person_info"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"check_person_info"];
}

//
-(void)loadData
{
    NetIsReachable;
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
        _s11 = [self.personInfoDic objectForKey:@"weixin"]?[self.personInfoDic objectForKey:@"weixin"]:@"";
        _s12 = [self.personInfoDic objectForKey:@"quyu"]?[self.personInfoDic objectForKey:@"quyu"]:@"";
        
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
    __weak typeof(self)weakself = self;
    
    //头像
    NSString * pic =[self.personInfoDic objectForKey:@"pic"];
    
    NSArray *_arr = [[NSBundle mainBundle]loadNibNamed:@"PersonInfoTop" owner:self options:nil];
    PersonInfoTop *_v = _arr[0];
    _v.frame =  _imgView.frame;
    _v.tapAvatarBlock = ^{
//        CheckAvatarVC *vc = [[CheckAvatarVC alloc]init];
//        [weakself.navigationController pushViewController:vc animated:YES];
        [weakself showImgWith:pic];
    };
    
    
    if (pic && pic.length > 11 ) {
        NSString * url = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"url_get_avatar", @""),pic];
        [_v.avantar sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cell_avatar_default"] options:SDWebImageRefreshCached];
    }
    else
    {
        _v.avantar.image =[UIImage imageNamed:@"cell_avatar_default"];
    }

    _v.name.text = _s1;
    _v.sex.text = _s2;
    _v.age.text = _s3;
    
    _v.jifen.text = _s4;
    _v.renqi.text = _s5;
    _v.pinlun.text = _s6;
    _v.tel.text = _s7;
    _v.weixin.text = _s11;
    _v.area.text = _s12;
    
    [_imgView addSubview:_v];
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
            NetIsReachable;
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
            _h += [ToolsClass calculateSizeForText:_s9 :Size font:Font].height;

        }break;
        case 1:
        {
            _h += [ToolsClass calculateSizeForText:_s8 :Size font:Font].height;
        }break;
        case 2:
        {
            _h += [ToolsClass calculateSizeForText:_s10 :Size font:Font].height;
            
        }break;
        case 3:
        {
            _h = 0 ;
            
        }break;
        default:return 0;break;
    }
    
    return _h > heightValue ? _h : heightValue;
}




#pragma mark --头像的缩放和显示
-(void)showImgWith:(NSString *)urlStr
{
    if (_maskView == nil) {
        _maskView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        _maskView.backgroundColor = [UIColor blackColor];
        
        _bigimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (CurrentScreenHeight - CurrentScreenWidth) / 2.0, CurrentScreenWidth,  CurrentScreenWidth)];
        _bigimgView.userInteractionEnabled = YES;
        
        UIScrollView *_scr = [[UIScrollView alloc]initWithFrame:_maskView.frame];
        _scr.contentSize = [[UIScreen mainScreen] bounds].size;
        _scr.delegate  =self;
        _scr.minimumZoomScale = 1;
        _scr.maximumZoomScale = 3;
        _scr.showsHorizontalScrollIndicator = NO;
        _scr.showsVerticalScrollIndicator = NO;
        
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissImg)]];
        
        if (urlStr && urlStr.length > 11 ) {
            NSString * url = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"url_get_avatar", @""),urlStr];
             [_bigimgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"cell_avatar_default"] options:SDWebImageRefreshCached];
        }
        else
        {
            _bigimgView.image =[UIImage imageNamed:@"cell_avatar_default"];
        }
        
        [_scr addSubview:_bigimgView];
        [_maskView addSubview:_scr];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
}

-(void)dismissImg
{
    [_maskView removeFromSuperview];
    _maskView = nil;
}

#pragma mark --UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _bigimgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _bigimgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
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
