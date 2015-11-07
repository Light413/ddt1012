//
//  AppDelegate.m
//  ddt
//
//  Created by gener on 15/7/1.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UMSocialData setAppKey:umengkey];
    
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
}

-(void)initTabBar
{
    NSArray *titleArr  = @[@"首页",@"同行",@"公司",@"我的",];
    self.rootTabVC.tabBar.tintColor = BarDefaultColor;
    NSArray *_itemArr = self.rootTabVC.tabBar.items;
    [_itemArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIBarButtonItem *)obj setTitle:[titleArr objectAtIndex:idx]];
    }];
}



@end
















