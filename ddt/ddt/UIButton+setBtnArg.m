//
//  UIButton+setBtnArg.m
//  ddt
//
//  Created by gener on 15/10/20.
//  Copyright © 2015年 Light. All rights reserved.
//

#import "UIButton+setBtnArg.h"

@implementation UIButton (setBtnArg)

-(void)setTitle:(NSString *)title
{
    objc_setAssociatedObject(self, @selector(title), title, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setTitle:title forState:UIControlStateNormal];
}
-(NSString *)title
{
    return objc_getAssociatedObject(self, @selector(title));
}

-(void)setID:(NSString *)ID
{
    objc_setAssociatedObject(self, @selector(ID), ID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)ID
{
    return objc_getAssociatedObject(self, @selector(ID));
}

-(void)setNormalTitle :(NSString*)title andID :(id)valueID
{
    [self setTitle:title];
    [self setID:valueID];
}

@end
