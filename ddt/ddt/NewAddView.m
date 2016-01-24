//
//  NewAddView.m
//  ddt
//
//  Created by wyg on 16/1/23.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "NewAddView.h"
#define  kbordcolor [UIColor colorWithRed:0.851 green:0.855 blue:0.859 alpha:1]

@implementation NewAddView
{

    __weak IBOutlet UIButton *addtg;
    __weak IBOutlet UIButton *addbil;
}

-(void)awakeFromNib
{
    addtg.layer.borderColor = kbordcolor.CGColor;
    addtg.layer.borderWidth = 1;
    addtg.layer.cornerRadius = 5;
    addtg.layer.masksToBounds = YES;
    
    addbil.layer.borderColor = kbordcolor.CGColor;
    addbil.layer.borderWidth = 1;
    addbil.layer.cornerRadius = 5;
    addbil.layer.masksToBounds = YES;
}

-(void)setAdd_th:(NSString *)add_th
{
    [addtg setTitle:add_th forState:UIControlStateNormal];
}

-(void)setAdd_bil:(NSString *)add_bil
{
    [addbil setTitle:add_bil forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
