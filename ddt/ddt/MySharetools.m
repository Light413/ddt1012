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
                                                   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}
#pragma mark --- 获取sessionid
- (NSString *)getsessionid{
    NSString *sessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
    return sessionid;
}
#pragma mark ---删除sessionid
- (void)removeSessionid{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sessionid"];
}
#pragma mark ---是否登陆成功
- (BOOL)isSessionid{
    NSString *sessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionid"];
    if (sessionid !=nil &&![sessionid isEqual:@"null"]&&sessionid.length>0) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark --获取登陆成功后的信息
- (NSDictionary *)getLoginSuccessInfo{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginSuccessInfo"];
    return dict;
}
#pragma mark -- 获取昵称与username不同，即昵称
-(NSString *)getNickName{
    NSString *nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickName"];
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
    return phone;
}
//获取密码
- (NSString *)getPassWord{
    NSString *passWord = [[NSUserDefaults standardUserDefaults]objectForKey:@"remeberPassword"];
    return passWord;
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

@end
