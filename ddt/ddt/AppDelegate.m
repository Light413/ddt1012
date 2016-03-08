//
//  AppDelegate.m
//  ddt
//
//  Created by gener on 15/7/1.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "AppDelegate.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"

#import "BaiDuLocationManger.h"

@interface AppDelegate ()<BMKGeneralDelegate>


@end

@implementation AppDelegate

BMKMapManager* _mapManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"kTXoqGQj9VoCyasyuwtxQv80" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [UMSocialData setAppKey:umengkey];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104880067" appKey:@"pqNu2AWR1n83gdML" url:@"http://www.123dyt.com"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxb2eb04bf9f024905" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.123dyt.com"];
    
    [[PgyUpdateManager sharedPgyManager]startManagerWithAppId:pgyAppId];
    [[PgyManager sharedPgyManager]startManagerWithAppId:pgyAppId];
    [[PgyManager sharedPgyManager]setEnableFeedback:NO];
    
    self.rootTabVC = (UITabBarController*)self.window.rootViewController;
    [self initTabBar];
    [self initsystem];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    NSLog(@"homedir  :%@",NSHomeDirectory());
    [MySharetools shared].isFirstSignupViewController = YES;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initsystem
{
    //配置HUD的风格
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.8f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    //xml parse
    if (![NGXMLReader hasAlreadyParserSuccess]) {
        NSLog(@".....start parser.....");
        [NGXMLReader parser];
    }
    
    //net reach
    [self startMonitor];
}

-(void)initTabBar
{
    NSArray *titleArr  = @[@"首页",@"同行",@"单子",@"我的",];
    self.rootTabVC.tabBar.barTintColor = [UIColor blackColor];//[UIColor colorWithRed:0.224 green:0.227 blue:0.231 alpha:1];
    self.rootTabVC.tabBar.tintColor = [UIColor whiteColor];
    NSArray *_itemArr = self.rootTabVC.tabBar.items;
    [_itemArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIBarButtonItem *)obj setTitle:[titleArr objectAtIndex:idx]];
//        [(UIBarButtonItem *)obj setTintColor:[UIColor whiteColor]];
    }];
}


#pragma mark --第三方 回调方法

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark -- baiduMapDelegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
        [[BaiDuLocationManger share]getLocationWithSuccessBlock:^(CLLocation *location) {
            
        } andFailBlock:^(NSError *error) {
            
        }];
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

//检测网络状态
-(void)startMonitor
{
    AFNetworkReachabilityManager *_manger = [AFNetworkReachabilityManager sharedManager];
    [_manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"______net change  :%ld",status);
    }];
    
    [_manger startMonitoring];
}



@end
















