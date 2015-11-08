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
@end
