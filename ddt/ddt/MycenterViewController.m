//
//  MycenterViewController.m
//  ddt
//
//  Created by allen on 15/10/15.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "MycenterViewController.h"
#import "LoginViewController.h"
#import "NGBaseNavigationVC.h"
#import "PersonalInfoViewController.h"
#import "MyCollectionViewController.h"
#import "MyResumeViewController.h"
#import "MyListViewController.h"
#import "AddCommanyInfoViewController.h"
#import "ReleaseMeetingViewController.h"
#import "SystemCenterViewController.h"
#import "ModifyPasswordViewController.h"

#import "NGMyZPVC.h"
#import "MeInfoCell.h"

#define HeaderViewHeight 120.0
#define iconHeight 15.0
#define KimageName @"imageName"
#define KlabelName @"labelName"

static NSString * MeInfoCellID = @"MeInfoCellID";

@interface MycenterViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datalist;
    UITableView *myTableView;
    UIView *backVIew;
    UIView *footView;
    
    
    UIImageView * _user_icon_img;
}
@end

@implementation MycenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (![[MySharetools shared]isSessionid]) {
        if ([MySharetools shared].isFirstSignupViewController == YES) {
            [MySharetools shared].isFirstSignupViewController = NO;
            [MySharetools shared].isFromMycenter = YES;
            LoginViewController *login = [[MySharetools shared]getViewControllerWithIdentifier:@"loginView" andstoryboardName:@"me"];
            NGBaseNavigationVC *nav = [[NGBaseNavigationVC alloc]initWithRootViewController:login];
            [self.tabBarController presentViewController:nav animated:YES completion:nil];
        }else{
            self.tabBarController.selectedIndex = 0;
        }
        myTableView.hidden = YES;
    }else{
        if ([[MySharetools shared]isAutoLogin]) {
            if([MySharetools shared].isFirstLoginSuccess){
                [MySharetools shared].isFirstLoginSuccess = NO;
                self.tabBarController.selectedIndex = 0;
            }
            [self showMydata];
            //myTableView.hidden = NO;
        }else{
            if ([MySharetools shared].isFirstSignupViewController == YES) {
                myTableView.hidden = YES;
                [MySharetools shared].isFirstSignupViewController = NO;
                [MySharetools shared].isFromMycenter = YES;
                LoginViewController *login = [[MySharetools shared]getViewControllerWithIdentifier:@"loginView" andstoryboardName:@"me"];
                NGBaseNavigationVC *nav = [[NGBaseNavigationVC alloc]initWithRootViewController:login];
                [self.tabBarController presentViewController:nav animated:YES completion:nil];
            }else if([MySharetools shared].isFirstLoginSuccess){
                [MySharetools shared].isFirstLoginSuccess = NO;
                self.tabBarController.selectedIndex = 0;
                [self showMydata];
            }else{
                //myTableView.hidden = NO;
            }
        }
//        [self showMydata];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)showMydata{
    UILabel *nickNameLabel = (UILabel *)[self.view viewWithTag:101];
    NSString *ss =[[MySharetools shared]getNickName];
    nickNameLabel.text = ss;
    
    [nickNameLabel sizeToFit];
    UIButton *modifyBtn = (UIButton *)[self.view viewWithTag:105];
    modifyBtn.frame = CGRectMake(nickNameLabel.right+10, 10+20, 50, 15);
    UIImageView *line = (UIImageView *)[self.view viewWithTag:106];
    line.frame = CGRectMake(modifyBtn.left, modifyBtn.bottom, modifyBtn.frame.size.width, 1);
    
    //积分
    UILabel *jifenLabel = (UILabel *)[self.view viewWithTag:102];
    NSString *jifen = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"fee"]];
    NSInteger oldjifen = jifen?[jifen integerValue]:0;
    NSInteger addjifen =[[NSUserDefaults standardUserDefaults]objectForKey:QIAN_DAO_JIFEN_KEY]? [[[NSUserDefaults standardUserDefaults]objectForKey:QIAN_DAO_JIFEN_KEY] integerValue] :0;
     jifenLabel.text = [NSString stringWithFormat:@"%ld",oldjifen + addjifen];
    
    //浏览人次
    UILabel *browseLabel = (UILabel *)[self.view viewWithTag:103];
    NSString *see = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"see"]];
    if (![see isEqual:@"(null)"]) {
        if (see.length>0) {
            browseLabel.text = see;
        }else{
            browseLabel.text = @"0";
        }
    }else{
        browseLabel.text = @"0";
    }
    UILabel *judegeName = (UILabel *)[self.view viewWithTag:104];
    NSString *judge = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"judge"]];
    if (![judge isEqual:@"(null)"]) {
        if (judge.length>0) {
            judegeName.text = judge;
        }else{
            judegeName.text = @"0";
        }
    }else{
        judegeName.text = @"0";
    }
    myTableView.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    [self createLeftBarItemWithBackTitle];
//    [self createHeader];
    [self creatFooter];
    [self creatTableView];
    datalist = @[@[@{KimageName: @"uc_shouc.png",
                   KlabelName:@"我的收藏"},
                 @{KimageName: @"uc_danzi.png",
                   KlabelName:@"我的单子"}],
                 
                 @[@{KimageName: @"uc_jianli.png",
                   KlabelName:@"我要招聘"},
                 @{KimageName: @"uc_fabu.png",
                   KlabelName:@"发布交流会"}],

                 @[ @{KimageName: @"uc_system.png",
                      KlabelName:@"系统中心"},
                    @{KimageName: @"uc_pwd.png",
                     KlabelName:@"修改密码"}],
                 
                 @[ @{KimageName: @"uc_exit.png",
                      KlabelName:@"退出账号"}]
                 ];
    
    UIBarButtonItem *_item = [[UIBarButtonItem alloc]init];
    _item.title = @"";
    self.navigationItem.backBarButtonItem = _item;
}

-(void)creatTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, CurrentScreenWidth, CurrentScreenHeight-49) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    myTableView.hidden = YES;
    [myTableView setContentInset:UIEdgeInsetsMake(5, 0, 20, 0)];
    myTableView.showsVerticalScrollIndicator = NO;
    
//    [myTableView setTableHeaderView:backVIew];
//    [myTableView setTableFooterView:footView];
    [myTableView registerNib:[UINib nibWithNibName:@"MeInfoCell" bundle:nil] forCellReuseIdentifier:MeInfoCellID];
}

#pragma mark --tableview 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 120;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }
    return ((NSArray*)[datalist objectAtIndex:section - 1]).count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        MeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:MeInfoCellID forIndexPath:indexPath];
        __block typeof(self)weakSelf = self;
        
        cell.tapIconBlock = ^(UIImageView *img){
            [weakSelf usericon:img];
        };
        
        
        NSString*avatar = [[MySharetools shared]getUserAvatarName];
        NSString *icon_url;
        
        if (avatar && avatar.length > 11) {
            icon_url = [NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"url_get_avatar", @""),avatar];
        }
        
        [cell setCell:icon_url name:[[MySharetools shared]getNickName] jifen:[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"fee"] liulan:[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"see"] comm:[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"judge"]];
        
        return cell;
    }
    
    static NSString *cellId = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray *_arr = [datalist objectAtIndex:indexPath.section - 1];
    
    UIImage *image = [UIImage imageNamed:_arr[indexPath.row][KimageName]];
    image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
    
    cell.imageView.image = image;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = _arr[indexPath.row][KlabelName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *dimageview = [[UIImageView alloc] init];
    dimageview.frame=CGRectMake(0, 49, CurrentScreenWidth, 1);
    dimageview.backgroundColor=RGBA(215, 215, 215, 1);
    [cell.contentView addSubview:dimageview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.section;

    switch (index) {
        case 0:
        {
            [self modifyInfo:nil];
            
        }
            break;
        case 1://我的收藏+我的单子
        {
            !indexPath.row?(
                {MyCollectionViewController *collection = [[MyCollectionViewController alloc]init];
                collection.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collection animated:YES];}
            ):
            (
                {MyListViewController *list = [[MyListViewController alloc]init];
                list .hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:list animated:YES];}
             );
        }break;
        case 2://我要招聘+发布交流会
        {
            !indexPath.row?(
                {NGMyZPVC *resume = [[MySharetools shared]getViewControllerWithIdentifier:@"MyZP" andstoryboardName:@"me"];
                resume.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:resume animated:YES];}
                ):
    //            [self performSegueWithIdentifier:@"showMyZPID" sender:nil];
            
            (
             {ReleaseMeetingViewController *meeting = [[MySharetools shared]getViewControllerWithIdentifier:@"ReleaseMeeting" andstoryboardName:@"me"];
                meeting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:meeting animated:YES];}
             );
        }break;
        case 3://系统中心+修改密码
        {
            !indexPath.row?(
            {
                SystemCenterViewController *system = [[SystemCenterViewController alloc]init];
                system.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:system animated:YES];}):
            (
                {
                    [self modifyPassword:nil];
                }
            );
        }break;

        case 4://退出账号
        {
            [self logout:nil];
        }break;
            
        default: break;
    }
}
#pragma mark--创建尾视图
-(void)creatFooter{
    footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, 120)];
    UIButton *modifyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    modifyBtn.frame = CGRectMake(10, 20, CurrentScreenWidth-20, 35);
    modifyBtn.backgroundColor = RGBA(100, 177, 62, 1);
    [modifyBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modifyBtn.layer.masksToBounds = YES;
    modifyBtn.layer.cornerRadius = 5;
    [modifyBtn addTarget:self action:@selector(modifyPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *logouBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    logouBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    logouBtn.frame = CGRectMake(10, modifyBtn.bottom+10, CurrentScreenWidth-20, 35);
    logouBtn.backgroundColor = RGBA(100, 177, 62, 1);
    [logouBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [logouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logouBtn.layer.masksToBounds = YES;
    logouBtn.layer.cornerRadius = 5;
    [logouBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:modifyBtn];
    [footView addSubview:logouBtn];
}
-(void)modifyPassword:(UIButton *)btn{
    ModifyPasswordViewController *modify = [[ModifyPasswordViewController alloc]init];
    modify.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:modify animated:YES];
}
-(void)logout:(UIButton *)btn{
    [[MySharetools shared]removeSessionid];
    [MySharetools shared].isFromMycenter = YES;
    LoginViewController *login = [[MySharetools shared]getViewControllerWithIdentifier:@"loginView" andstoryboardName:@"me"];
    NGBaseNavigationVC *nav = [[NGBaseNavigationVC alloc]initWithRootViewController:login];
    [self.tabBarController presentViewController:nav animated:YES completion:nil];
}

-(void)modifyInfo:(UIButton *)btn{
    PersonalInfoViewController *person = [[MySharetools shared]getViewControllerWithIdentifier:@"personInfo" andstoryboardName:@"me"];
    person.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:person animated:YES];
}






#pragma mark --修改用户头像
- (void)usericon:(UIImageView *)img{
    _user_icon_img = img;
    UIActionSheet *useraction = [[UIActionSheet alloc]initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择本地图片",@"拍照", nil];
    [useraction showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self takeLocalAlbum];
            break;
        case 1:
            [self takePicture];
            break;
            
        default:
            break;
    }
}
-(void)takeLocalAlbum{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        picker.allowsEditing = YES;
    }
    [self.navigationController presentViewController:picker animated:YES completion:^{
        
    }];
}
-(void)takePicture{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        [self.navigationController presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        NSString *documentsDirectory =NSTemporaryDirectory();
        
        if ([mediaType isEqualToString:@"public.image"]){
            UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            
            NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:@"temp0.jpg"];
            [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFile atomically:YES];

            UIImage *_img = [[MySharetools shared]formatUploadImage:image];
            NSData *dataImage = UIImageJPEGRepresentation(_img, 0.6);
//            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
//            [dataArray addObject:dataImage];
            [self postData:dataImage];
        }
    }];
}

-(void)postData:(NSData *)dataImage{
    //获取json参数字符串
    NSString * token = [[MySharetools shared]getsessionid];
    NSString *dataStr = [Base64 stringByEncodingData:dataImage];
//    NSMutableString *_str = [[NSMutableString alloc]initWithString:dataStr];
//    [_str replaceOccurrencesOfString:@"+" withString:@"%2b" options:NSLiteralSearch range:NSMakeRange(0, _str.length)];
    
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSString *imgname = [NSString stringWithFormat:@"%@.jpg",tel];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username",imgname,@"pic",dataStr,@"data",nil];
    NSString *jsonStr = [NSString jsonStringFromDictionary:dic1];
    
    //post请求参数：jsondata + token
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:jsonStr,@"jsondata",token,@"session" ,nil];
    
    [SVProgressHUD showWithStatus:@"正在上传头像"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_usericon", @"") parms:dic2 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"result"] integerValue] == 0) {
              [SVProgressHUD showSuccessWithStatus:@"上传完成"];
              //...设置当前头像的图片
                UIImage *_ig = [[UIImage alloc]initWithData:dataImage];
                _user_icon_img.image = _ig;
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"message"]];
            }
        }

        NSLog(@"...responseObject  :%@",responseObject);
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"设置头像失败,请稍后重试"];
    }];

    [HttpRequestManager doPostOperationWithTask:_task];
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
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
