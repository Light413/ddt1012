//
//  NGBaseNavigationVC.m
//  ddt
//
//  Created by gener on 15/7/5.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGBaseNavigationVC.h"
#define NGNavigationBgColor [UIColor colorWithRed:0.106 green:0.580 blue:0.984 alpha:1];

@interface NGBaseNavigationVC ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation NGBaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /** 设置navigationBar的外观 */
    
    if (IOS7LATER) {
        self.navigationBar.translucent = YES;//设置半透明效果
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.barTintColor = BarDefaultColor;//设置bar的背景颜色
        [self.navigationBar setTintColor:[UIColor whiteColor]];//设置按钮字体颜色
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];//设置标题颜色
    }
    
//    __weak typeof(self)weakself = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//          self.interactivePopGestureRecognizer.delegate = weakself;
//            self.delegate = weakself;
//    }

    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated==YES)
        
        self.interactivePopGestureRecognizer.delegate = nil;

    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated==YES)
        self.interactivePopGestureRecognizer.delegate = nil;
    
   return [super popViewControllerAnimated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count<2||self.visibleViewController==[self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}


@end


