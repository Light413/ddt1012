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
#define HeaderViewHeight 100.0
#define iconHeight 15.0
#define KimageName @"imageName"
#define KlabelName @"labelName"
@interface MycenterViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *datalist;
    UITableView *myTableView;
    UIView *backVIew;
    UIView *footView;
}
@end

@implementation MycenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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
-(void)showMydata{
    UILabel *nickNameLabel = (UILabel *)[self.view viewWithTag:101];
    nickNameLabel.text = [[MySharetools shared]getNickName];
    [nickNameLabel sizeToFit];
    UIButton *modifyBtn = (UIButton *)[self.view viewWithTag:105];
    modifyBtn.frame = CGRectMake(nickNameLabel.right+10, 10, 50, 15);
    UIImageView *line = (UIImageView *)[self.view viewWithTag:106];
    line.frame = CGRectMake(modifyBtn.left, modifyBtn.bottom, modifyBtn.frame.size.width, 1);
    
    UILabel *jifenLabel = (UILabel *)[self.view viewWithTag:102];
    NSString *jifen = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"fee"]];
    if (![jifen isEqual:@"(null)"]) {
        if (jifen.length>0) {
            jifenLabel.text = jifen;
        }else{
            jifenLabel.text = @"0";
        }
    }else{
        jifenLabel.text = @"0";
    }
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
    [self createHeader];
    [self creatFooter];
    [self creatTableView];
    datalist = @[@{KimageName: @"uc_shouc.png",
                   KlabelName:@"我的收藏"},
                 @{KimageName: @"uc_danzi.png",
                   KlabelName:@"我的单子"},
                 @{KimageName: @"uc_jianli.png",
                   KlabelName:@"我的简历"},
                 @{KimageName: @"uc_fabu.png",
                   KlabelName:@"发布交流会"},
                 @{KimageName: @"uc_jianli.png",
                   KlabelName:@"升级为公司会员"},
                 @{KimageName: @"uc_system.png",
                   KlabelName:@"系统中心"},
                 ];

    // Do any additional setup after loading the view from its nib.
    
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
//    [self presentViewController:nav animated:YES completion:nil];
}
-(void)creatTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight-49-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    myTableView.hidden = YES;
    [myTableView setTableHeaderView:backVIew];
    [myTableView setTableFooterView:footView];
}
#pragma mark --tableview 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return HeaderViewHeight;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return HeaderViewHeight;
//}
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = datalist[indexPath.row][KlabelName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *dimageview = [[UIImageView alloc] init];
    dimageview.frame=CGRectMake(0, 43, CurrentScreenWidth, 1);
    dimageview.backgroundColor=RGBA(215, 215, 215, 1);
    [cell.contentView addSubview:dimageview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    switch (index) {
        case 0:
        {
            MyCollectionViewController *collection = [[MyCollectionViewController alloc]init];
            collection.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collection animated:YES];
        }
            break;
        case 1:
        {
            MyListViewController *list = [[MyListViewController alloc]init];
            list .hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 2:
        {
            MyResumeViewController *resume = [[MySharetools shared]getViewControllerWithIdentifier:@"MyResume" andstoryboardName:@"me"];
            resume.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resume animated:YES];
        }
            break;
        case 3:
        {
            ReleaseMeetingViewController *meeting = [[MySharetools shared]getViewControllerWithIdentifier:@"ReleaseMeeting" andstoryboardName:@"me"];
            meeting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:meeting animated:YES];
        }
            break;
        case 4:
        {
            AddCommanyInfoViewController *commany = [[MySharetools shared]getViewControllerWithIdentifier:@"AddCommany" andstoryboardName:@"me"];
            commany.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commany animated:YES];
        }
            break;
        case 5:
        {
            SystemCenterViewController *system = [[SystemCenterViewController alloc]init];
            system.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:system animated:YES];
        }
            break;
            
        default:
            break;
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

-(void)createHeader{
    backVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, HeaderViewHeight)];
    backVIew.backgroundColor = [UIColor clearColor];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CurrentScreenWidth, HeaderViewHeight)];
    backImage.image = [UIImage imageNamed:@"bg_credit"];
    backImage.userInteractionEnabled = YES;
    //backImage.backgroundColor = [UIColor redColor];
    [backVIew addSubview:backImage];
    UIButton *userIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    userIcon.tag = 107;
    userIcon.frame = CGRectMake(10, 10, HeaderViewHeight-20, HeaderViewHeight-20);
    [userIcon setBackgroundImage:[UIImage imageNamed:@"head_noregist"] forState:UIControlStateNormal];
    [userIcon addTarget:self action:@selector(usericonBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backVIew addSubview:userIcon];
    UILabel *nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(userIcon.right+10, 10, 0, 15)];
    //nickNameLabel.text = [[MySharetools shared]getNickName];
    nickNameLabel.font = [UIFont systemFontOfSize:13];
    nickNameLabel.textColor = [UIColor greenColor];
    //nickNameLabel.backgroundColor = [UIColor blackColor];
    nickNameLabel.tag = 101;
    [nickNameLabel sizeToFit];
    [backVIew addSubview:nickNameLabel];
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.frame = CGRectMake(nickNameLabel.right+10, 10, 50, 15);
    [modifyBtn setTitle:@"点击修改" forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    modifyBtn.tag = 105;
    [modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(modifyInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(modifyBtn.left, modifyBtn.bottom, modifyBtn.frame.size.width, 1)];
    line.backgroundColor = [UIColor blackColor];
    line.tag = 106;
    [backVIew addSubview:modifyBtn];
    [backVIew addSubview:line];
    
    
    
    UIImageView *jifenicon = [[UIImageView alloc]initWithFrame:CGRectMake(userIcon.right+10, line.bottom+22, iconHeight, iconHeight)];
    jifenicon.image = [UIImage imageNamed:@"uc_shouc"];
    UILabel *jifenName = [[UILabel alloc]initWithFrame:CGRectMake(jifenicon.right, line.bottom+20, 30, 20)];
    jifenName.text = @"积分";
    jifenName.textAlignment = NSTextAlignmentRight;
    jifenName.font = [UIFont systemFontOfSize:12];
    UILabel *jifenLabel = [[UILabel alloc]initWithFrame:CGRectMake(jifenicon.left,jifenicon.bottom+5,iconHeight+30, 20)];
    jifenLabel.font = [UIFont systemFontOfSize:12];
    jifenLabel.textAlignment = NSTextAlignmentCenter;
    jifenLabel.tag = 102;
//    NSString *jifen = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"fee"]];
//    if (![jifen isEqual:@"(null)"]) {
//        if (jifen.length>0) {
//            jifenLabel.text = jifen;
//        }else{
//            jifenLabel.text = @"0";
//        }
//    }
    
    
    UIImageView *browseicon = [[UIImageView alloc]initWithFrame:CGRectMake(jifenName.right+5, line.bottom+22, iconHeight, iconHeight)];
    browseicon.image = [UIImage imageNamed:@"uc_add"];
    UILabel *browseName = [[UILabel alloc]initWithFrame:CGRectMake(browseicon.right, line.bottom+20, 30, 20)];
    browseName.text = @"浏览";
    browseName.textAlignment = NSTextAlignmentRight;
    browseName.font = [UIFont systemFontOfSize:12];
    UILabel *browseLabel = [[UILabel alloc]initWithFrame:CGRectMake(browseicon.left, jifenicon.bottom+5, iconHeight+30, 20)];
    browseLabel.font = [UIFont systemFontOfSize:12];
    browseLabel.textAlignment = NSTextAlignmentCenter;
    browseLabel.tag = 103;
//    NSString *see = [NSString stringWithFormat:@"%@",[[[MySharetools shared]getLoginSuccessInfo] objectForKey:@"see"]];
//    if (![see isEqual:@"(null)"]) {
//        if (see.length>0) {
//            browseLabel.text = see;
//        }else{
//            browseLabel.text = @"0";
//        }
//    }
    
    UIImageView *judgeicon = [[UIImageView alloc]initWithFrame:CGRectMake(browseName.right+5, line.bottom+22, iconHeight, iconHeight)];
    judgeicon.image = [UIImage imageNamed:@"uc_say"];
    UILabel *judegeName = [[UILabel alloc]initWithFrame:CGRectMake(judgeicon.right, line.bottom+20, 30, 20)];
    judegeName.text = @"评论";
    judegeName.textAlignment = NSTextAlignmentRight;
    judegeName.font = [UIFont systemFontOfSize:12];
    UILabel *judgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(judgeicon.left, jifenicon.bottom+5, iconHeight+30, 20)];
    //judgeLabel.text = @"";
    judgeLabel.font = [UIFont systemFontOfSize:12];
    judgeLabel.textAlignment = NSTextAlignmentCenter;
    judgeLabel.tag = 104;
    
    [backVIew addSubview:jifenLabel];
    [backVIew addSubview:jifenicon];
    [backVIew addSubview:jifenName];
    
    [backVIew addSubview:browseLabel];
    [backVIew addSubview:browseicon];
    [backVIew addSubview:browseName];
    
    [backVIew addSubview:judgeLabel];
    [backVIew addSubview:judgeicon];
    [backVIew addSubview:judegeName];
    //[self.view addSubview:backVIew];
    
    
}
-(void)modifyInfo:(UIButton *)btn{
    PersonalInfoViewController *person = [[MySharetools shared]getViewControllerWithIdentifier:@"personInfo" andstoryboardName:@"me"];
    person.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:person animated:YES];
}
- (void)usericonBtn:(UIButton *)btn{
    //    UIView *bgView = [[UIView alloc]initWithFrame:self.window.frame];
    //    bgView.tag = 800;
    //    bgView.backgroundColor = [UIColor blackColor];
    //    bgView.alpha = 0.4;
    //    [self.window addSubview:bgView];
    //    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(20, 100, CurrentScreenWidth-40, 150)];
    //    secondView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    //    secondView.backgroundColor = [UIColor whiteColor];
    //    secondView.tag = 801;
    //    secondView.layer.masksToBounds = YES;
    //    secondView.layer.cornerRadius = 8;
    //    [self.window addSubview:secondView];
    
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
            UIButton *usericon = (UIButton *)[self.view viewWithTag:107];
            [usericon setBackgroundImage:image forState:UIControlStateNormal];
            NSData *dataImage = UIImageJPEGRepresentation([[MySharetools shared]formatUploadImage:image], 0.7);
//            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
//            [dataArray addObject:dataImage];
            [self postData:dataImage];
        }
    }];
}
-(void)postData:(NSData *)dataImage{
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
    NSString *token = [NSString stringWithFormat:@"%@(!)*^*%@",[[MySharetools shared]getPhoneNumber],timeString];
    //...test
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[[MySharetools shared] getNickName],@"username",@"test.jpg",@"pic",[Base64 stringByEncodingData:dataImage],@"data",token,@"token",nil];
    NSString *jsonStr = [NSString jsonStringFromDictionary:dic1];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:jsonStr,@"jsondata", nil];
    
    [SVProgressHUD showWithStatus:@"正在提交"];
    RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_usericon", @"") parms:dic2 andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"...responseObject  :%@",responseObject);
    } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [HttpRequestManager doPostOperationWithTask:_task constructingBodyWithBlock:(void(^)(id<AFMultipartFormData>))dataImage];
    [HttpRequestManager doPostOperationWithTask:_task constructingBodyWithBlock:^(id<AFMultipartFormData>formData){
        
    }];
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
