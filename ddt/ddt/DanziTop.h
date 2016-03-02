//
//  DanziTop.h
//  ddt
//
//  Created by gener on 16/3/1.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DanziTop : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarimg;
@property (weak, nonatomic) IBOutlet UILabel *areaLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *timesLab;


@property (weak, nonatomic) IBOutlet UILabel *maskView;

@property (weak, nonatomic) IBOutlet UIImageView *bill_statue_img;//工单状态

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lead_value;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width_value;

@end
