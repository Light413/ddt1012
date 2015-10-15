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
    
    _selectedBtn = btn;
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
 /*
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
//        _tableView.separatorInset = UIEdgeInsetsMake(0, -30, 0, -30);
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    _tableView.frame = CGRectMake(0, _maskView.frame.origin.y, _maskView.frame.size.width, 0);
    CGRect rec = _tableView.frame;
    
    float _maxHeigt = [self.delegate popListView:self numberOfRowsInSection:0] * 44.0 ;
    _maxHeigt = _maxHeigt >_maskView.frame.size.height - 60? _maskView.frame.size.height - 60:_maxHeigt;
    
    rec.size.height = _maxHeigt + 2;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = rec;
    }];
    
    [self.window addSubview:_tableView];
  */
    
    if (_listView == nil) {
        _listView =  [[NGBaseListView alloc]initWithFrame:CGRectZero withDelegate:self];
    }
    _listView.frame  = CGRectMake(0, _maskView.frame.origin.y, _maskView.frame.size.width, 0);
    
    CGRect rec = _listView.frame;
    
    float _maxHeigt = [self.delegate popListView:self numberOfRowsInSection:0] * 44.0 ;
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
    
    _selectedBtn.selected = NO;
    _selectedBtn.backgroundColor = BtnNormalColor;
}

#pragma mark - NGBaseListDelegate

-(NSInteger)numOfTableViewInBaseView:(NGBaseListView *)baseListView
{
    return 2;
}

-(NSArray *)dataSourceOfBaseView
{
    return [self.delegate dataSourceOfPoplistview];
}

-(void)baseView:(NGBaseListView *)baseListView didSelectRowAtIndex:(NSInteger)index
{

}



/*
#pragma mark- tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate popListView:self numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(popListView:heightForRowAtIndexPath:)]) {
        return [self.delegate popListView:self heightForRowAtIndexPath:indexPath.row];
    }
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    
    NSString *_title = [self.delegate titleOfCellInPopView:self atIndex:indexPath.row];
    cell.textLabel.text = _title ? _title :@"";
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate popListView:self didSelectRowAtIndex:indexPath.row];
}

*/








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
