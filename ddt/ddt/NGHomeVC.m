//
//  NGHomeVC.m
//  ddt
//
//  Created by gener on 15/7/26.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGHomeVC.h"
#import "NGCollectionViewCell.h"
#import "NGXMLReader.h"
#import "NGItemsDetailVC.h"
#import "NGSearchCitiesVC.h"
#import "NGSecondVC.h"
#import "NGSearchBar.h"
#import "LoginViewController.h"
#import "HotPicVC.h"

#import <PgyUpdate/PgyUpdateManager.h>
#import "NewAddView.h"
#import "ScrollPicView.h"

#define ScrollViewHeight    (110 * SCREEN_SCALE)
#define AddViewHeight       80
#define Btn_share_height    40
#define Btn_qudao_height    60

#define CollectionHeaderViewHight (ScrollViewHeight + AddViewHeight +Btn_share_height + Btn_qudao_height+20)

#define FootRecordData @"FootRecordData"
#define TapStr @"最近访问的类别会出现在这里"

static NSString *NGCollectionHeaderReuseID = @"NGCollectionHeaderReuseID";
static NSString *showItemDetailIdentifier = @"showItemDetailIdentifier";//item 详情页Id
static NSString *showItemDetailIdentifier_in = @"showItemDetailIdentifier_in";//公司个人入口

static NSString *showSecondVCID     = @"showSecondVCID";//附近同行、接单、求职招聘
static NSString *showFeedBackVCID   = @"showFeedBackVCID";//意见反馈
static NSString *showTHContactID    = @"showTHContactID";//同行交流
static NSString *showShuaiDanID     = @"showShuaiDanID";//甩单
static NSString *showCarPriceVCID   = @"showCarPriceVCID";//车价评估

//#import "BaiDuLocationManger.h"
typedef NS_ENUM(NSInteger ,NextvcType)
{
    NextvcType_0,
    NextvcType_1,
    NextvcType_2,
    NextvcType_3,
};

@interface NGHomeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UMSocialUIDelegate,NGSearchBarDelegate,TopClickDelegate>

@end

@implementation NGHomeVC
{
    UIButton *leftBtn ;
    ScrollPicView *_topScrollView;
    UICollectionView *_collectionView;

    NSArray *_itemArray;//item元素项
    NSDictionary *_selectItemDic;//选中cell的数据项
    NSString *_option_info;//item附件信息，表明企业OR个人
    NSInteger _selectIndex;//选中cell索引,section =1用到
    
    UIView *searchView;
    
    NextvcType _vctype;
    
    NewAddView *_todaynewadd;//今日新增同行-单子视图
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path= [[NSBundle mainBundle]pathForResource:@"menuItem" ofType:@"plist"];
    _itemArray = [[NSArray alloc]initWithContentsOfFile:path];
    _selectIndex = 0;
    
    [self initCollectionView];
    [self getNewadd];

    //获取位置信息
    [[LocationManger shareManger]getLocationWithSuccessBlock:^(NSString *str) {
        [SVProgressHUD dismiss];
        NSLog(@"current location : %@",str);
        [[NSUserDefaults standardUserDefaults]setObject:@"上海市" forKey:CURRENT_LOCATION_CITY];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if (str) {
             [leftBtn setTitle:str forState:UIControlStateNormal];
        }
        else
        {
            [leftBtn setTitle:@"定位失败" forState:UIControlStateNormal];
        }

        //...上传位置信息<+31.19302052,+121.68571511>
        NSString *tel = [[MySharetools shared]getPhoneNumber];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username", tel,@"mobile",@"121.68571511,31.19302052",@"distance",nil];
        NSDictionary *_d = [MySharetools getParmsForPostWith:dic];
        
        RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_upLocation", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        [HttpRequestManager doPostOperationWithTask:_task];
        
    } andFailBlock:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"获取位置信息失败"];
    }];
    
    //...test检查版本更新
    [[PgyUpdateManager sharedPgyManager]checkUpdate];
    
    
    [self getTopPic];
    
   ;

    
    
    NSLog(@"#############:%@",NSStringFromCGRect(CurrentScreenFrame));
    NSLog(@"#############:%f",SCREEN_SCALE);
  /*
    [[BaiDuLocationManger share]getLocationWithSuccessBlock:^(CLLocation *loaction) {
//        CLGeocoder *geo = [[CLGeocoder alloc]init];
//        [geo reverseGeocodeLocation:loaction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            for (CLPlacemark *_p in placemarks) {
//                NSLog(@"...%@",_p);
//            }
//        }];
        CLGeocoder *geo = [[CLGeocoder alloc]init];
        [geo reverseGeocodeLocation:loaction completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark *place in placemarks) {
                //            NSLog(@"name,%@",place.name);                       // 位置名
                //            NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                //            NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                //            NSLog(@"locality,%@",place.locality);               // 市
                //            NSLog(@"subLocality,%@",place.subLocality);         // 区
                //            NSLog(@"country,%@",place.country);                 // 国家
//                cityname = place.locality;
            }}];
    } andFailBlock:^(NSError *error) {
        
    }];*/
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_collectionView reloadData];
//    [self getNewadd];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)awakeFromNib
{
    [self initTopView];
}

#pragma mark --获取数据
//新增
-(void)getNewadd
{
    NetIsReachable;
    NSDate *_date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_date];
    
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)[_date timeIntervalSince1970]];  //转化为UNIX时间戳
    NSString *token = [NSString stringWithFormat:@"%@(!)*^*%@",tel,timeString];
    
    NSDictionary *_dic =[NSDictionary dictionaryWithObjectsAndKeys:dateString,@"date",token,@"token",tel,@"mobile", nil];
    
    NSDictionary *_d = [MySharetools getParmsForPostWith:_dic];
    
    RequestTaskHandle *_h = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_todaynewadd", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"today new add : %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"]integerValue] ==0) {
                NSDictionary *_value = [responseObject objectForKey:@"data"];
                _todaynewadd.add_th = [_value objectForKey:@"userCount"];
                _todaynewadd.add_bil = [_value objectForKey:@"billCount"];
            }
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [HttpRequestManager doPostOperationWithTask:_h];
}

-(void)getTopPic
{
//    http://123dyt.com/mydyt/upload/hot/a1.png
    NetIsReachable;
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *_dic =[NSDictionary dictionaryWithObjectsAndKeys:tel,@"username", @"5",@"psize",@"1",@"pnum",@"1",@"type",nil];
    
    NSDictionary *_d = [MySharetools getParmsForPostWith:_dic];
    RequestTaskHandle *_h = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_gethot_pic", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"]integerValue] ==0) {
                NSArray *_arr = [responseObject objectForKey:@"data"];
                if (_arr && _arr.count > 0) {
                    
                    [[NSUserDefaults standardUserDefaults ]setObject:_arr forKey:@"SCROLL_PIC_DATA"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_topScrollView removeFromSuperview];
                        _topScrollView = nil;
                        _topScrollView = [[ScrollPicView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, ScrollViewHeight) withData:_arr];
                        _topScrollView.delegate = self;
                        [_collectionView reloadData];
                    });

                }
            }
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [HttpRequestManager doPostOperationWithTask:_h];
}


#pragma mark-init subview
-(void)initTopView
{
    self.title  = @"贷易通";
    self.automaticallyAdjustsScrollViewInsets = NO;
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 100, 40);
    [leftBtn setImage:[UIImage imageNamed:@"bar_down_icon"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"bar_down_icon"] forState:UIControlStateHighlighted];
    
    [leftBtn setTitle:@"定位中" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    leftBtn.titleLabel.textAlignment  = NSTextAlignmentLeft;
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, -10, 3, -10)];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(5, -10, 5, 95)];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [leftBtn addTarget:self action:@selector(locationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    [rightBtn setImage:[UIImage imageNamed:@"bar_qiandao_icon"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"bar_qiandao_icon"] forState:UIControlStateHighlighted];
    [rightBtn setTitle:@"签到" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -35)];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 5, -10)];
    [rightBtn addTarget:self action:@selector(siginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    //搜索栏初始化
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth -100, 35)];
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, searchView.width, searchView.height)];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.alpha = .95;
    searchField.font = [UIFont systemFontOfSize:12];
    searchField.placeholder = @"\t\t\t输入搜索关键字";
    searchField.layer.masksToBounds = YES;
    searchField.layer.cornerRadius = 3;
    [searchView addSubview:searchField];
    searchField.delegate = self;
    
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, 35, 15);
    [_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [_btn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    searchField.rightView =_btn ;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, searchView.width, 20);
    [btn addTarget:self action:@selector(jumpTosearch) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btn];
//    self.navigationItem.titleView = searchView;

    NSArray *_a22 = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCROLL_PIC_DATA"];
    
    _topScrollView = [[ScrollPicView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, ScrollViewHeight) withData:_a22];
    _topScrollView.delegate = self;
    
    //今日新增视图
    NSArray *_addarr = [[NSBundle mainBundle]loadNibNamed:@"NewAddView" owner:nil options:nil];
    _todaynewadd = [_addarr lastObject];
}

-(void)initCollectionView
{
    float _w = (CurrentScreenWidth -20 -3) / 4.0;
    UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.itemSize =CGSizeMake(_w, 80);
    _layout.minimumLineSpacing = 10;
    _layout.minimumInteritemSpacing = 1;
    _layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    _layout.headerReferenceSize = CGSizeMake(0, CollectionHeaderViewHight);//_topScrollView.frame.origin.y+ScrollViewHeight
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, CurrentScreenWidth, CurrentScreenHeight -64-44) collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.bounces = NO;
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource  = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NGCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NGCollectionViewCellID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"NGCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NGCollectionHeaderReuseID];
}


#pragma mark -选择城市
-(void)locationBtnAction :(UIButton*)btn
{
    [self performSegueWithIdentifier:@"searchCityIdentifier" sender:nil];
}

//签到
-(void)siginBtnAction :(UIButton*)btn
{
    NetIsReachable;
    //检测是否登录
    if (![[MySharetools shared]hasSuccessLogin]) {
        return;
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username", tel,@"mobile",@"5",@"fee",dateString,@"bz",@"1",@"type",nil];//type 1:签到积分 ; 2 : 分享
    NSDictionary *_d = [MySharetools getParmsForPostWith:dic];
    [SVProgressHUD showWithStatus:@"签到中"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_qiandao", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (![[responseObject objectForKey:@"result"]boolValue]) {
                [MobClick event:@"event_sign"];
                
                [SVProgressHUD showSuccessWithStatus:@"签到成功,积分+5"];
                //签到成功,获取保存上次登录后积累的签到积分
                NSInteger oldaddjifen =[[NSUserDefaults standardUserDefaults]objectForKey:QIAN_DAO_JIFEN_KEY]? [[[NSUserDefaults standardUserDefaults]objectForKey:QIAN_DAO_JIFEN_KEY] integerValue] :0;
                
                [[NSUserDefaults standardUserDefaults]setObject:@(5 + oldaddjifen) forKey:QIAN_DAO_JIFEN_KEY];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            else if ([[responseObject objectForKey:@"result"]integerValue]==1)
            {
                [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"message"]];
            }
            else
                [SVProgressHUD showInfoWithStatus:@"签到失败,请稍后重试"];
        }
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"签到失败,请稍后重试"];
    }];
    
    [HttpRequestManager doPostOperationWithTask:_task];
}

#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark -
#pragma mark -TopClickDelegate
-(void)clickPicWithUrl:(NSString *)url
{
    [MobClick event:@"event_click_ad"];
    
    HotPicVC * vc = [[HotPicVC alloc]init];
    vc.desurl = url;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//记录访问足迹 -(已弃用)
-(NSString *)footerRecord:(NSString*)str
{
    NSMutableString *_des = [[NSMutableString alloc]init];
    NSArray *_arr =  [[NSUserDefaults standardUserDefaults] objectForKey:FootRecordData];
    if (str) {
        if (_arr) {
            NSMutableArray *_tmp = [NSMutableArray arrayWithArray:_arr];
            if ([_tmp containsObject:str]) {
                [_tmp removeObject:str];
            }
            [_tmp insertObject:str atIndex:0];
            if (_tmp.count > 3) {
                [_tmp removeLastObject];
            }
            [[NSUserDefaults standardUserDefaults]setObject:_tmp forKey:FootRecordData];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@[str] forKey:FootRecordData];
        }
    }
    else
    {
        if (_arr) {
            for (int i =0; i < _arr.count; i++) {
                [_des appendString:[NSString stringWithFormat:@" %@",_arr[i]]];
            }
            return _des;
        }
    }

    return TapStr;
}

#pragma mark -UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _itemArray?_itemArray.count:0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_itemArray && _itemArray.count > 0) {
        NSArray *_arr = [_itemArray objectAtIndex:section];
        return _arr?_arr.count:0;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *_arr = [_itemArray objectAtIndex:indexPath.section];
    NSDictionary *dic = [_arr objectAtIndex:indexPath.row];
    NGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NGCollectionViewCellID" forIndexPath:indexPath];
    cell.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dic objectForKey:@"imagename"]]];
    cell.title.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return nil;
    }
    UICollectionReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NGCollectionHeaderReuseID forIndexPath:indexPath];
    for (id _s in reuseView.subviews) {
        [_s removeFromSuperview];
    }
    
    UILabel *_line = [[UILabel alloc]init];
//    [reuseView addSubview:_line];
    _line.backgroundColor = [UIColor lightGrayColor];
    _line.alpha = 0.5;
    
    if (indexPath.section ==0) {
        [reuseView addSubview:_topScrollView];//100
        
        //今日新增
        _todaynewadd.frame = CGRectMake(5, _topScrollView.bottom + 5, CurrentScreenWidth - 10, AddViewHeight);//85
        [reuseView addSubview:_todaynewadd];
        
        //搜索栏
        NGSearchBar *_searchBar = [[NGSearchBar alloc]initWithFrame:CGRectMake(10,_todaynewadd.bottom+2, CurrentScreenWidth  -80, 30)];
        _searchBar.placeholder = @"输入搜索关键字";//30
        _searchBar.delegate = self;
        [reuseView addSubview:_searchBar];
        
        //分享按钮
        UIButton *_shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(CurrentScreenWidth -70,_todaynewadd.bottom -2, 60, Btn_share_height);//40
        [reuseView addSubview:_shareBtn];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
        [_shareBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 35)];
        [_shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        //企业和个人渠道btn
        float _btn_w = (CurrentScreenWidth -30)/ 2.0;
        for (int i =0; i<2; i++) {
            UIButton *btnport = [UIButton buttonWithType:UIButtonTypeCustom];//70
            btnport.frame = CGRectMake(10+(_btn_w + 10) *i, _shareBtn.bottom + 5, _btn_w, Btn_qudao_height);//60
            [reuseView addSubview:btnport];
            btnport.tag = 17 + i;
            btnport.layer.cornerRadius = 5;
            btnport.layer.masksToBounds = YES;
            [btnport setTintColor:[UIColor whiteColor]];
            btnport.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnport setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, _btn_w - 60)];
            [btnport setTitleEdgeInsets:UIEdgeInsetsMake(0, -55, 0, 5)];
            [btnport setShowsTouchWhenHighlighted:YES];
            [btnport addTarget:self action:@selector(btnAction_in:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                btnport.backgroundColor = [UIColor colorWithRed:0.914 green:0.416 blue:0.282 alpha:1];
                [btnport setImage:[UIImage imageNamed:@"person_in"] forState:UIControlStateNormal];
                [btnport setTitle:@"个人贷款渠道" forState:UIControlStateNormal];
            }
            else if (i == 1)
            {
                btnport.backgroundColor = [UIColor colorWithRed:0.278 green:0.545 blue:0.788 alpha:1];
                [btnport setImage:[UIImage imageNamed:@"company_in"] forState:UIControlStateNormal];
                [btnport setTitle:@"企业贷款渠道" forState:UIControlStateNormal];
            }
        }
        
        _line.frame = CGRectMake(0,  CollectionHeaderViewHight - 1, CurrentScreenWidth, 1);
    }
    else if (indexPath.section ==1)
    {
        _line.frame = CGRectMake(0, 1, CurrentScreenWidth, 1);
    }
    return reuseView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //key,title
    _vctype = NextvcType_1;
    _option_info =nil;
    _selectItemDic =[[_itemArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row];
    [self footerRecord:[_selectItemDic objectForKey:@"title"]];
    if (indexPath.section == 0) {
        _option_info = indexPath.row < 4 ? @"个人":(indexPath.row < 8 ?@"企业":@"");
        [self performSegueWithIdentifier:showItemDetailIdentifier sender:nil];

    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0://甩单
            {
                //检测是否登录
                if (![[MySharetools shared]hasSuccessLogin]) {
                    return;
                }
                
                [self performSegueWithIdentifier:showShuaiDanID sender:nil];
            }break;
                
            case 1://交流会
            {
                [self performSegueWithIdentifier:showTHContactID sender:nil];
            }break;
                
            case 2://求职
            {
                _selectIndex = 5;
                [self performSegueWithIdentifier:showSecondVCID sender:nil];
            }break;
                
            case 3://车价评估
            {
                [self performSegueWithIdentifier:showCarPriceVCID sender:nil];
            }break;
            default:
                break;
        }

    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeZero;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return section?CGSizeMake(0, 0): CGSizeMake(0, CollectionHeaderViewHight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -shareBtn Action
-(void)shareBtnAction
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:umengkey
                                      shareText:@"贷易通-你身边的贷款专家,http://www.123dyt.com"
                                     shareImage:[UIImage imageNamed:@"wx108x108"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSms,nil]
                                       delegate:self];
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    NSLog(@"...%@",platformName);

    if ([platformName isEqualToString:@"wxsession"]) {
      [UMSocialData defaultData].extConfig.wechatSessionData.title = @"";
    }
    else if ([platformName isEqualToString:@"qq"])
    {
        [UMSocialData defaultData].extConfig.qqData.title = @"贷易通";
    }//sina
    
}

//实现回调方法（可选）
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [MobClick event:@"event_share"];
        
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        if ([MySharetools shared].isSessionid) {
             [[MySharetools shared]addJIFenWithType:@"2"];
        }
    }
}


#pragma mark --NGSearchBarDelegate
-(void)searchBarWillBeginSearch:(NGSearchBar *)searchBar
{
    [self jumpTosearch];
}

- (BOOL)textFieldShouldEndEditing:(NGSearchBar*)textField
{
    return YES;
}

#pragma mark --个人，企业贷款入口
-(void)btnAction_in:(UIButton*)btn
{
    if (btn.tag ==17) {
        NSLog(@"...person");
        _vctype = NextvcType_2;
    }
    else if (btn.tag ==18)
    {
        NSLog(@"...company");
        _vctype = NextvcType_3;
    }
    
    [self performSegueWithIdentifier:showItemDetailIdentifier_in sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:showItemDetailIdentifier]) {//item详情页
        NGItemsDetailVC *_vc = [segue destinationViewController];
        _vc.superdic = _selectItemDic;
        _vc.vcType = _vctype;
//        _vc.optional_info = _option_info;
    }
    else if ([segue.identifier isEqualToString:showItemDetailIdentifier_in])
    {
        NGItemsDetailVC *_vc = [segue destinationViewController];
        _vc.superdic = _selectItemDic;
        _vc.vcType = _vctype;
    }
    else if ([segue.identifier isEqualToString:showSecondVCID])
    {
        NGSecondVC *_vc = [segue destinationViewController];
        _vc.hidesBottomBarWhenPushed = YES;
        _vc.title = @"test";
        _vc.vcType = _selectIndex;
    }
    else if ([segue.identifier isEqualToString:@"searchCityIdentifier"])
    {
        NGSearchCitiesVC *vc = (NGSearchCitiesVC *)[((NGBaseNavigationVC*)[segue destinationViewController]) topViewController];
        
        vc.popViewBackBlock = ^(id obj){
            NSDictionary *_d = (NSDictionary*)obj;
            [leftBtn setNormalTitle:[_d objectForKey:@"NAME"] andID:[_d objectForKey:@"ID"]];
            [[NSUserDefaults standardUserDefaults]setObject:[_d objectForKey:@"NAME"] forKey:CURRENT_LOCATION_CITY];
            [[NSUserDefaults standardUserDefaults]synchronize];
        };
    }
}


#pragma mark -- 点击搜索在此跳转
-(void)jumpTosearch{
    
     [self performSegueWithIdentifier:@"showUserSearchId" sender:nil];
}

@end




