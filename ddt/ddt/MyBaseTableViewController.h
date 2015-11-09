//
//  MyBaseTableViewController.h
//  ddt
//
//  Created by allen on 15/10/19.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBaseTableViewController : UITableViewController
@property(nonatomic,strong)UIWindow *window ;
-(void)createLeftBarItemWithBackTitle;
-(void)moreAction:(UIBarButtonItem *)barButtonItem;
-(void)createRightBarItemWithBackTitle:(NSString *)moreTitle
                          andImageName:(NSString *)imageName;
@end
