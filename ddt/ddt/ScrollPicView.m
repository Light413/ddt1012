//
//  ScrollPicView.m
//  ddt
//
//  Created by wyg on 16/3/6.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "ScrollPicView.h"

@interface ScrollPicView ()<UIScrollViewDelegate>
{
    UIScrollView *_topScrollView;
    UIPageControl *_pageCtr;
    NSArray *_dataSource;
    
    NSTimer *_timer;
}

@end



@implementation ScrollPicView

-(instancetype)initWithFrame:(CGRect)frame withData:(NSArray*)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        _topScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _topScrollView.contentSize = CGSizeMake(frame.size.width * 6, frame.size.height) ;
        _topScrollView.backgroundColor = [UIColor lightGrayColor];
        _topScrollView.delegate = self;

        _topScrollView.contentInset = UIEdgeInsetsZero;
        _topScrollView.pagingEnabled = YES;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_topScrollView];
        
        //...test
        for (int i=0; i < 4; i++) {
            UIImageView *imgv = [[UIImageView alloc]init];
            imgv.frame = CGRectMake(frame.size.width * (i+1), 0, frame.size.width, frame.size.height);
            imgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.png",i]];
            [_topScrollView addSubview:imgv];
        }
        
        UIImageView *imgv1 = [[UIImageView alloc]init];
        imgv1.frame = CGRectMake(0 , 0, frame.size.width, frame.size.height);
        imgv1.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.png",3]];
        [_topScrollView addSubview:imgv1];
        
        UIImageView *imgv2 = [[UIImageView alloc]init];
        imgv2.frame = CGRectMake(frame.size.width * 5 , 0, frame.size.width, frame.size.height);
        imgv2.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.png",0]];
        [_topScrollView addSubview:imgv2];
        
        _pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        _pageCtr.numberOfPages  = 4;
        _pageCtr.currentPageIndicatorTintColor =[UIColor colorWithRed:0.345 green:0.678 blue:0.910 alpha:1];
        _pageCtr.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:_pageCtr];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        
        _topScrollView.contentOffset = CGPointMake(0, 0);
        [_topScrollView scrollRectToVisible:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height) animated:NO];
    }
    
    return self;
}


#pragma mark -timer action
-(void)timerAction
{

    int _p = _pageCtr.currentPage;
    _p++;
    _p = _p > 3?0:_p;
    
    _pageCtr.currentPage = _p;
    
    [_topScrollView scrollRectToVisible:CGRectMake(_topScrollView.size.width *(_p+1 ), 0, _topScrollView.size.width, _topScrollView.size.height) animated:YES];
    
//        CGPoint currentPoint = _topScrollView.contentOffset;
//        currentPoint.x += CurrentScreenWidth;
//        if (currentPoint.x > 3 * CurrentScreenWidth) {
//            currentPoint = CGPointZero;
//            _topScrollView.contentOffset = CGPointMake(0, 0);
//        }
//    
//        [UIView animateWithDuration:.2 animations:^{
//            _topScrollView.contentOffset = currentPoint;
//        } completion:^(BOOL finished) {
//           //currentPoint.x / _topScrollView.frame.size.width;
//
//        }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _topScrollView) {
        NSInteger index = scrollView.contentOffset.x / CurrentScreenWidth;

        _pageCtr.currentPage = scrollView.contentOffset.x / CurrentScreenWidth  - 1;
 
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _topScrollView) {
        NSInteger index = scrollView.contentOffset.x / CurrentScreenWidth;
        if (index == 0) {
            [scrollView scrollRectToVisible:CGRectMake(320 * 4,0,320,scrollView.frame.size.height) animated:YES];
        }
        if (index ==5) {
//            [scrollView scrollRectToVisible:CGRectMake(320 ,0,320,scrollView.frame.size.height) animated:YES];
            [scrollView setContentOffset:CGPointMake(320, 0)];
        }
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
