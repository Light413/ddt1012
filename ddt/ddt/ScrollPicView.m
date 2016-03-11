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
    NSArray *_picArr;//图片数据
    
    NSTimer *_timer;
}

@end


@implementation ScrollPicView

-(instancetype)initWithFrame:(CGRect)frame withData:(NSArray*)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!arr || arr.count ==0) {
            return self;
        }
        
        _picArr = arr;
        _topScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _topScrollView.contentSize = CGSizeMake(frame.size.width * (_picArr.count + 2), frame.size.height) ;
        _topScrollView.backgroundColor = [UIColor lightGrayColor];
        _topScrollView.delegate = self;
        _topScrollView.contentInset = UIEdgeInsetsZero;
        _topScrollView.pagingEnabled = YES;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_topScrollView];

        //...test-http://123dyt.com/mydyt/upload/hot/a1.png
        for (int i=0; i < _picArr.count + 2; i++) {
            NSDictionary * _d;
            if (i == 0 || i == _picArr.count) {
                _d = [_picArr objectAtIndex:_picArr.count - 1];
            }
            else if (i == 1 || i ==_picArr.count + 1)
            {
                _d = [_picArr objectAtIndex:0];
            }
            else
                _d = [_picArr objectAtIndex:i - 1];
            
            UIImageView *imgv = [[UIImageView alloc]init];
            imgv.frame = CGRectMake(frame.size.width * (i), 0, frame.size.width, frame.size.height);
            NSString *_imgurl = [NSString stringWithFormat:@"%@/%@",NSLocalizedString(@"url_scroll_pic", @""),[_d objectForKey:@"pic"]];
            
            [imgv sd_setImageWithURL:[NSURL URLWithString:_imgurl] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"image%d.png",0]] options:SDWebImageRefreshCached];
            
            [_topScrollView addSubview:imgv];
            imgv.userInteractionEnabled = YES;
            [imgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTapAction)]];
        }
  
        //pageCtr
        _pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        _pageCtr.numberOfPages  = _picArr.count;
        _pageCtr.currentPageIndicatorTintColor =[UIColor colorWithRed:0.345 green:0.678 blue:0.910 alpha:1];
        _pageCtr.pageIndicatorTintColor = [UIColor lightGrayColor];
        [_pageCtr addTarget:self action:@selector(pageTap:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageCtr];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        
        _topScrollView.contentOffset = CGPointMake(0, 0);
        [_topScrollView scrollRectToVisible:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height) animated:NO];
    }
    
    return self;
}

//点击事件
-(void)pageTap : (UIPageControl *)ctr
{
    NSInteger _p = ctr.currentPage;
    [_topScrollView scrollRectToVisible:CGRectMake(_topScrollView.size.width *(_p+1 ), 0, _topScrollView.size.width, _topScrollView.size.height) animated:YES];
}

-(void)imgTapAction
{
    NSDictionary *dic = [_picArr objectAtIndex:_pageCtr.currentPage];
    NSString *url = [dic objectForKey:@"url"];
    if (!url) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPicWithUrl:)]) {
        [self.delegate performSelector:@selector(clickPicWithUrl:) withObject:url];
    }
}

#pragma mark -timer action
-(void)timerAction
{
    NSInteger _p = _pageCtr.currentPage;
    _p++;
    _p = _p > _picArr.count?0:_p;
    
    _pageCtr.currentPage = _p;
    
    [_topScrollView scrollRectToVisible:CGRectMake(_topScrollView.size.width *(_p+1 ), 0, _topScrollView.size.width, _topScrollView.size.height) animated:YES];
}

#pragma mark --UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageCtr.currentPage = scrollView.contentOffset.x / CurrentScreenWidth  - 1;

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / CurrentScreenWidth;
    if (index == 0) {
        [scrollView setContentOffset:CGPointMake(CurrentScreenWidth * _picArr.count, 0)];

    }
    if (index ==_picArr.count  + 1) {
        [scrollView setContentOffset:CGPointMake(CurrentScreenWidth, 0)];
    }
}


//timer-
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / CurrentScreenWidth;
    
    if (index ==_picArr.count  + 1) {
        [scrollView setContentOffset:CGPointMake(CurrentScreenWidth, 0)];
    }
}


@end



