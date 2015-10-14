//
//  NGSearchBar.m
//  ddt
//
//  Created by gener on 15/10/14.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGSearchBar.h"

@implementation NGSearchBar
{
    UITextField *_tf;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        _tf = [[UITextField alloc]initWithFrame:frame];
        [self addSubview:_tf];
        
        UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0, 35, 15);
        [_btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [_btn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _tf.rightView =_btn ;
        
    }
    return self;
}

-(void)searchBtnAction:(UIButton*)btn
{
    NSLog(@"searchBtnAction");
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
