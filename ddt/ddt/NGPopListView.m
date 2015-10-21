//
//  NGPopListView.m
//  ddt
//
//  Created by gener on 15/10/14.
//  Copyright (c) 2015年 Light. All rights reserved.
//

#import "NGPopListView.h"

#define BtnNormalColor  [UIColor colorWithRed:0.749 green:0.792 blue:0.859 alpha:1]
#define BtnSelectColer  [UIColor colorWithRed:0.808 green:0.855 blue:0.918 alpha:0.5]
#define BtnHeight 40

@implementation NGPopListView
{
    UIView *_maskView;
    UIView *_superView;
    
//    UITableView *_tableView;
    UIButton *_selectedBtn;
    NSInteger _selectedBtnTag;
    
    NGBaseListView *_listView;
}

-(instancetype)initWithFrame:(CGRect)frame withDelegate :(id)delegate withSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.backgroundColor = [UIColor lightGrayColor];
        _superView = superView;
        
        NSInteger section = [self.delegate numberOfSectionInPopView:self];
        float width = (frame.size.width ) * 1.0 / section;
        for (int i=0; i < section; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1000  +i;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:[self.delegate titleOfSectionInPopView:self atIndex:i] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0 + width * i, 0,i==section-1? width:width - 0.5, BtnHeight);
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setImage:[UIImage imageNamed:@"btn_down"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"btn_up"] forState:UIControlStateSelected];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, width - 20, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 15)];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:btn];
            btn.backgroundColor = BtnNormalColor;
        }
    }
    
    return self;
}

-(void)btnAction:(UIButton*)btn
{
    if (btn.selected) {
        return;
    }
    for (UIView *_v in self.subviews) {
        if ([_v isKindOfClass:[UIButton class]]) {
            ((UIButton*)_v).selected = NO;
            _v.backgroundColor = BtnNormalColor;
        }
    }
    btn.selected = YES;
    btn.backgroundColor = BtnSelectColer;
    _selectedBtnTag = btn.tag;
    _selectedBtn = btn;
    
    if (_listView) {
        [_listView removeFromSuperview];
        _listView = nil;
    }
    [self show];
}

//弹出视图
-(void)show
{
    if (_maskView == nil) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height  +64, self.frame.size.width, CurrentScreenHeight -(self.frame.origin.y + self.frame.size.height  +64))];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .7;
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)]];
    }
    [self.window addSubview:_maskView];

    if (_listView == nil) {
        _listView =  [[NGBaseListView alloc]initWithFrame:CGRectZero withDelegate:self];
    }
    _listView.frame  = CGRectMake(0, _maskView.frame.origin.y, _maskView.frame.size.width, 0);
    
    CGRect rec = _listView.frame;
    
    float _maxHeigt = [self.delegate popListView:self numberOfRowsWithIndex:_selectedBtnTag - 1000] * 44.0 ;
    _maxHeigt = _maxHeigt >_maskView.frame.size.height - 60? _maskView.frame.size.height - 60:_maxHeigt;
    
    rec.size.height = _maxHeigt + 2;
    [UIView animateWithDuration:0.3 animations:^{
        _listView.frame = rec;
    }];
    
    [self.window addSubview:_listView];
}

-(void)disappear
{
    [_listView removeFromSuperview];
    [_maskView removeFromSuperview];
    _listView = nil;
    
    _selectedBtn.selected = NO;
    _selectedBtn.backgroundColor = BtnNormalColor;
}

#pragma mark - NGBaseListDelegate

-(NSInteger)numOfTableViewInBaseView:(NGBaseListView *)baseListView
{
    return _selectedBtnTag == 1001 ? 2 : 1;
}

-(NSArray*)dataSourceOfBaseView
{
    return [self.delegate dataSourceOfPoplistviewWithIndex:_selectedBtnTag - 1000];//传递参数
}

-(NSArray *)dataSourceOfBaseViewWithKey:(NSString *)keyValue
{
    return [NGXMLReader getBaseTypeDataWithKey:keyValue];
}

-(void)baseView:(NGBaseListView *)baseListView didSelectObj:(id)obj1 secondObj:(id)obj2
{
    NSLog(@"obj1 : %@ ---- obj2 :%@",obj1,obj2);
//    [0]	(null)	@"ID" : @"719"
//    [1]	(null)	@"NAME" : @"黄浦区"
    NSString *_title =obj2?[obj2 objectForKey:@"NAME"]:([obj1 isKindOfClass:[NSDictionary class]] ? [obj1 objectForKey:@"NAME"]:obj1);
    
    [_selectedBtn setTitle:_title forState:UIControlStateNormal];
    
    [self disappear];
    
    //...获取btn 参数列表
    if ([self.delegate respondsToSelector:@selector(popListView:didSelectRowAtIndex:)]) {
        [self.delegate popListView:self didSelectRowAtIndex:0];
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
