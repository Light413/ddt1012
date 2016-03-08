//
//  MySharetools.m
//  ddt
//
//  Created by allen on 15/10/15.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "MySharetools.h"

@implementation MySharetools
static MySharetools *instance = nil;
+(MySharetools *)shared{
    @synchronized(self){
        if (!instance) {
            instance = [[MySharetools alloc]init];
        }
    }
    return instance;
}
-(id)getViewControllerWithIdentifier:(NSString *)Identifier andstoryboardName:(NSString *)storyboardname{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardname bundle:nil];
    id ViewController = [storyboard instantiateViewControllerWithIdentifier:Identifier];
    return ViewController;
}
//提示窗口
+ (void)msgBox:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
                                                   delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}


#pragma mark --登录相关
//切换根视图
-(void)changeRootVcWithLogin:(BOOL)_b
{
    UIViewController *_vc;
    _vc =_b? (
    {
        [self removeSessionid];
        [self getViewControllerWithIdentifier:@"LoginVCSBID" andstoryboardName:@"me"];
    }): \
    ({_vc = [[MySharetools shared]getViewControllerWithIdentifier:@"mainVCSBID" andstoryboardName:@"MainSB"];
        ((UITabBarController*)_vc).tabBar.barTintColor = [UIColor blackColor];
        ((UITabBarController*)_vc).tabBar.tintColor = [UIColor whiteColor];
        NSArray *titleArr  = @[@"首页",@"同行",@"单子",@"我的",];
        NSArray *_itemArr = ((UITabBarController*)_vc).tabBar.items;
        [_itemArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(UIBarButtonItem *)obj setTitle:[titleArr objectAtIndex:idx]];
        }];
        
        ((UITabBarController*)_vc).selectedIndex = 0;
        _vc;
    });
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:_vc];
}

-(void)hasSuccessLogin
{
    if (![self isSessionid]) {
//        [MySharetools msgBox:@"只有登录后才能操作"];//return NO;
        [self changeRootVcWithLogin:YES];
    }
}



#pragma mark ---sessionid相关方法
//获取sessionid
- (NSString *)getsessionid{
    NSString *sessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
    if (sessionid == nil) {
        sessionid = @"";
    }
    return sessionid;
}
//退出登录-清除数据操作
- (void)removeSessionid{
//    删除sessionid
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sessionid"];
//    删除缓存的积分
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:QIAN_DAO_JIFEN_KEY];
    
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rememberPhone"];
    
//    删除缓存的用户头像数据
    [self deleteImg];

}

//是否登陆成功
- (BOOL)isSessionid{
    NSString *sessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
    if (sessionid !=nil &&![sessionid isEqual:@"null"]&&sessionid.length>0) {
        return YES;
    }else{
        return NO;
    }
}

//登录成功后-修改头像数据
-(UIImage*)getImg
{
    NSString *imageFile = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[self getPhoneNumber]]];
    return  [[UIImage alloc]initWithContentsOfFile:imageFile];
}

-(void)deleteImg
{
    NSString *imageFile = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[self getPhoneNumber]]];
    if (imageFile) {
        [[NSFileManager defaultManager] removeItemAtPath:imageFile error:nil];
    }
}

#pragma mark --获取登陆成功后的信息
- (NSDictionary *)getLoginSuccessInfo{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginSuccessInfo"];
    return dict;
}
#pragma mark -- 获取昵称与username不同，即昵称
-(NSString *)getUserAvatarName
{
    NSString *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAvatar"];
    if (tmp==nil) {
        tmp = @"";
    }
    return tmp;
}

-(NSString *)getNickName{
    NSString *nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickName"];
    if (nickName==nil) {
        nickName = @"";
    }
    return nickName;
}
- (BOOL)isAutoLogin{
    BOOL flag = [[NSUserDefaults standardUserDefaults]boolForKey:@"isAutoLogin"];
    if (flag) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isRemeberPasswordandPhone{
    BOOL flag = (BOOL)[[NSUserDefaults standardUserDefaults]boolForKey:@"isRemeberPasswordandPhone"];
    if (flag) {
        return YES;
    }else{
        return NO;
    }
}
- (NSString *)getPhoneNumber{
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"rememberPhone"];
    if (phone == nil) {
        phone = @"";
    }
    return phone;
}
//获取密码
- (NSString *)getPassWord{
    NSString *passWord = [[NSUserDefaults standardUserDefaults]objectForKey:@"remeberPassword"];
    if (passWord==nil) {
        passWord = @"";
    }
    return passWord;
}

#pragma mark --请求参数处理
//获取网络请求参数
+(NSDictionary*)getParmsForPostWith:(NSDictionary*)dic
{
    if (dic == nil) {
        NSLog(@"post请求参数为空");
        return nil;
    }
    
    NSString * session = [[self alloc]getsessionid];//成功登陆
    NSString *jsonstr = [NSString jsonStringFromDictionary:dic];
    NSDictionary *new = [NSDictionary dictionaryWithObjectsAndKeys:jsonstr,@"jsondata",session,@"session", nil];
    return new;
}

+(NSDictionary*)getParmsForPostWith:(NSDictionary*)dic withToken:(BOOL)is
{
    if (dic == nil) {
        NSLog(@"post请求参数为空");
        return nil;
    }
    
    NSDictionary *new;
    NSString *tel = [[MySharetools shared]getPhoneNumber];
    NSMutableDictionary *_pars = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [_pars setObject:tel forKey:@"mobile"];
    [_pars setObject:tel forKey:@"username"];
    
    if (is) {
        NSDate *localDate = [NSDate date]; //获取当前时间
        NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)[localDate timeIntervalSince1970]];  //转化为UNIX时间戳
        NSString *token = [NSString stringWithFormat:@"%@(!)*^*%@",tel,timeString];
        [_pars setObject:token forKey:@"token"];
        
        NSString *jsonstr = [NSString jsonStringFromDictionary:_pars];
        new = [NSDictionary dictionaryWithObjectsAndKeys:jsonstr,@"jsondata", nil];
    }
    
    else
    {
        NSString * session = [[self alloc]getsessionid];//成功登陆
        NSString *jsonstr = [NSString jsonStringFromDictionary:_pars];
        new = [NSDictionary dictionaryWithObjectsAndKeys:jsonstr,@"jsondata",session,@"session", nil];
    }
    
    return new;
}


-(UIImage*) formatUploadImage:(UIImage*)photoimage
{
    int kMaxResolution = 960;
    
    CGImageRef imgRef = photoimage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    NSData *imgData = UIImageJPEGRepresentation(photoimage, 0.7);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if ([imgData length] > 524288) {
        if (width > kMaxResolution || height > kMaxResolution)
        {
            CGFloat ratio = width/height;
            if (ratio > 1)
            {
                bounds.size.width = kMaxResolution;
                bounds.size.height = bounds.size.width / ratio;
            }
            else
            {
                bounds.size.height = kMaxResolution;
                bounds.size.width = bounds.size.height * ratio;
            }
        }
    } else {
        bounds.size.width = width;
        bounds.size.height = height;
    }
    
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGFloat scaleRatioheight = bounds.size.height / height;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient =photoimage.imageOrientation;
    switch(orient)
    {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            //[NSException raise:NSInternalInconsistencyException format:@"Invalid?image?orientation"];
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatioheight);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatioheight);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}


- (BOOL)isMobileNumber:(NSString *)mobileNum{
    NSString * MOBILE = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[5|7])|(17[[^1-4],\\D]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


/**
 *  增加积分(签到或分享成功后获得积分)
 *
 *  @param type 1-签到操作+5分 2-分享操作+1分
 */
-(void)addJIFenWithType:(NSString*)type
{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *tel = [self getPhoneNumber];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:tel,@"username", tel,@"mobile",@"5",@"fee",dateString,@"bz",type,@"type",nil];//type 1:签到积分 ; 2 : 分享
        NSDictionary *_d = [MySharetools getParmsForPostWith:dic];
    
        [type integerValue]==1? [SVProgressHUD showWithStatus:@"签到中"]:"";
    
        RequestTaskHandle *_task = [RequestTaskHandle taskWithUrl:NSLocalizedString(@"url_qiandao", @"") parms:_d andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (![[responseObject objectForKey:@"result"]boolValue]) {
                    [type integerValue]==1? [SVProgressHUD showSuccessWithStatus:@"签到成功,积分+5"]:[SVProgressHUD showSuccessWithStatus:@"分享成功,积分+1"];
                    //获取保存上次登录后积累的签到积分
                    NSInteger oldaddjifen =[[NSUserDefaults standardUserDefaults]objectForKey:QIAN_DAO_JIFEN_KEY]? [[[NSUserDefaults standardUserDefaults]objectForKey:QIAN_DAO_JIFEN_KEY] integerValue] :0;
                    
                    [[NSUserDefaults standardUserDefaults]setObject:@(([type integerValue] ==1? 5 : 1) + oldaddjifen) forKey:QIAN_DAO_JIFEN_KEY];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                else if ([[responseObject objectForKey:@"result"]integerValue]==1)
                {
                    [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"message"]];
                }
                else
                    [SVProgressHUD showInfoWithStatus:@"操作失败,请稍后重试"];
            }
        } faileBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"操作失败,请稍后重试"];
        }];
        
        [HttpRequestManager doPostOperationWithTask:_task];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self changeRootVcWithLogin:YES];
    }
}

@end
