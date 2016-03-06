//
//  PersonInfoTop.m
//  ddt
//
//  Created by gener on 16/2/29.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "PersonInfoTop.h"

@implementation PersonInfoTop

-(void)awakeFromNib
{
    self.avantar.layer.cornerRadius = 40;
    self.avantar.layer.masksToBounds = YES;
    
    [self.avantar addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIcon)]];
}

-(void)tapIcon
{
    if (self.tapAvatarBlock) {
        self.tapAvatarBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
