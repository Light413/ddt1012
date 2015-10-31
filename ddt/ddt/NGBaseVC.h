//
//  NGBaseVC.h
//  ddt
//
//  Created by gener on 15/7/26.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDPopVCDelegate <NSObject>

-(void)popViewControllerBack:(id)obj;


@end

@interface NGBaseVC : UIViewController

@property(nonatomic,assign)id<DDPopVCDelegate> delegate;

-(void)createLeftBarItemWithBackTitle;

-(void)goback:(UIButton *)btn;

@end
