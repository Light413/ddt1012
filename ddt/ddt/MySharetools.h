//
//  MySharetools.h
//  ddt
//
//  Created by allen on 15/10/15.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySharetools : NSObject
@property (nonatomic) BOOL isFirstSignupViewController;
@property (nonatomic) BOOL isFromMycenter;
@property (nonatomic) BOOL isFirstLoginSuccess;
//@property (nonatomic) BOOL isAutoLogin;
//@property (nonatomic) BOOL isRemeberPasswordandPhone;
+(MySharetools *)shared;
-(id)getViewControllerWithIdentifier:(NSString *)Identifier andstoryboardName:(NSString *)storyboardname;
+ (void)msgBox:(NSString *)msg;
- (NSString *)getsessionid;//获取sessionid
- (void)removeSessionid;//删除sessionid
- (BOOL)isSessionid;//是否登陆成功
- (NSString *)getNickName;//获取姓名
- (NSDictionary *)getLoginSuccessInfo;
- (BOOL)isAutoLogin;
- (BOOL)isRemeberPasswordandPhone;
- (NSString *)getPhoneNumber;//获取手机号
- (NSString *)getPassWord;//获取密码
@end
